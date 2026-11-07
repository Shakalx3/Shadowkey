#!/usr/bin/env python3
"""Experimental LLVM-objdump-backed ARM-to-C lifter for a subset of Shadowkey.

This is a bootstrap tool, not a replacement for NGageRecomp's Capstone lifter.
It uses the existing JSON recovery map and LLVM's ARM disassembler, then emits
C with explicit guest CPU registers and HLE/dispatch calls.
"""
import argparse, json, re, struct, subprocess, tempfile
from pathlib import Path

BASE=0x10000000
CODE_OFF=0x7c
CODE_SIZE=0x1009c4
COND={
 "eq":"ngage_zf(c)", "ne":"!ngage_zf(c)",
 "cs":"ngage_cf(c)", "hs":"ngage_cf(c)", "cc":"!ngage_cf(c)", "lo":"!ngage_cf(c)",
 "mi":"ngage_nf(c)", "pl":"!ngage_nf(c)", "vs":"ngage_vf(c)", "vc":"!ngage_vf(c)",
 "hi":"(ngage_cf(c) && !ngage_zf(c))", "ls":"(!ngage_cf(c) || ngage_zf(c))",
 "ge":"(ngage_nf(c) == ngage_vf(c))", "lt":"(ngage_nf(c) != ngage_vf(c))",
 "gt":"(!ngage_zf(c) && ngage_nf(c) == ngage_vf(c))",
 "le":"(ngage_zf(c) || ngage_nf(c) != ngage_vf(c))"
}
CCS=sorted(COND, key=len, reverse=True)
REG={"sp":13,"lr":14,"pc":15,"ip":12,"fp":11,"sl":10,"sb":9}
def reg(s):
    s=s.strip().lower()
    if s in REG: return REG[s]
    if s.startswith('r') and s[1:].isdigit(): return int(s[1:])
    raise ValueError("register "+s)
def split_ops(s):
    out=[]; cur=''; depth=0
    for ch in s:
        if ch in '[{(': depth+=1
        elif ch in ']})': depth-=1
        if ch==',' and depth==0:
            out.append(cur.strip());cur=''
        else: cur+=ch
    if cur.strip(): out.append(cur.strip())
    return out
def imm(s):
    s=s.strip()
    if not s.startswith('#'): raise ValueError("not immediate "+s)
    v=s[1:].replace('_','')
    return int(v,0)
def cimm(v): return f"0x{v & 0xffffffff:08x}u"
def shifted_operand(ops, rr_fn, carry_update=False):
    """Render ARM Operand2, including immediate/register shifts and RRX."""
    if not ops: return "0u"
    src=ops[0].strip()
    if src.startswith('#'):
        value=cimm(imm(src))
    else:
        value=rr_fn(src)
    if len(ops)<2: return value
    sh=ops[1].strip().lower()
    if sh=="rrx":
        return f"shadowkey_arm_shift_operand(c, {value}, 3u, 0u, 1u, {1 if carry_update else 0}u)"
    m=re.match(r'^(lsl|lsr|asr|ror)\s+(.+)$',sh,re.I)
    if not m: return value
    typ={"lsl":0,"lsr":1,"asr":2,"ror":3}[m.group(1).lower()]
    amount=m.group(2).strip()
    if amount.startswith('#'):
        av=f"{imm(amount)}u"; immediate=1
    else:
        av=f"({rr_fn(amount)} & 0xffu)"; immediate=0
    return f"shadowkey_arm_shift_operand(c, {value}, {typ}u, {av}, {immediate}u, {1 if carry_update else 0}u)"
def cond_mnem(m):
    for cc in CCS:
        if m.endswith(cc) and len(m)>len(cc):
            b=m[:-len(cc)]
            # Avoid stripping suffixes from actual base names unless plausible.
            if b in {"b","bl","bx","blx","mov","mvn","add","adds","sub","subs","rsb","rsbs",
                     "and","ands","orr","orrs","eor","eors","bic","bics","cmp","cmn","tst","teq",
                     "ldr","str","ldrb","strb","ldrh","strh","ldrsb","ldrsh","ldm","stm","ldmia","stmia",
                     "ldmib","stmib","ldmdb","stmdb","ldmda","stmda","lsl","lsr","asr","ror",
                     "mul","mla","swi","svc","nop","ldrbt","strbt","ldrt","strt","ldrd","strd",
                     "ldmfd","stmfd","ldmea","stmfd","push","pop","adc","sbc","rsc","rscs","teq","tst","mcr","cdp"}:
                return b,cc
    return m,None
def parse_reglist(s):
    s=s.strip()
    if not (s.startswith('{') and s.endswith('}')): raise ValueError("reglist "+s)
    vals=[]
    for part in split_ops(s[1:-1]):
        if '-' in part:
            a,b=part.split('-',1); vals.extend(range(reg(a),reg(b)+1))
        else: vals.append(reg(part))
    return sorted(set(vals))
def memop(s, pc):
    # Return (address C expression, base register number, writeback, post-index expression).
    s=s.strip()
    wb=s.endswith('!')
    if wb: s=s[:-1].strip()
    m=re.match(r'^\[(.*?)\](?:\s*,\s*(.+))?$',s)
    if not m: raise ValueError("memory "+s)
    inside,post=m.groups()
    parts=split_ops(inside)
    rn=reg(parts[0]); base=f"c->r[{rn}]"
    if rn==15: base=f"{pc+8:#x}u"
    expr=base
    if len(parts)>1:
        idxpart=parts[1].strip()
        # LLVM spells negative register offsets as "-rN" and shifts as a further operand.
        neg=idxpart.startswith('-')
        if idxpart.startswith('#'):
            n=imm(idxpart)
            expr=f"({expr} {'+' if n>=0 else '-'} {abs(n)}u)"
        else:
            rr=idxpart.lstrip('+-')
            ir=reg(rr)
            rv=f"c->r[{ir}]"
            shift=None; amount=None
            if len(parts)>2:
                sm=re.match(r'^(lsl|lsr|asr|ror)\s*#?(\d+)$',parts[2].strip(),re.I)
                if sm:
                    shift=sm.group(1).lower(); amount=int(sm.group(2))
            if shift and amount:
                if shift=='lsl': rv=f"({rv} << {amount})"
                elif shift=='lsr': rv=f"({rv} >> {amount})"
                elif shift=='asr': rv=f"((uint32_t)((int32_t){rv} >> {amount}))"
                else: rv=f"(({rv} >> {amount}) | ({rv} << {32-amount}))"
            expr=f"({expr} {'-' if neg else '+'} {rv})"
    if post:
        p=post.strip()
        if p.startswith('#'):
            n=imm(p); update=f"c->r[{rn}] {'+=' if n>=0 else '-='} {abs(n)}u;"
        else:
            neg=p.startswith('-'); rr=reg(p.lstrip('+-'))
            update=f"c->r[{rn}] {'-=' if neg else '+='} c->r[{rr}];"
        return base,rn,False,update
    return expr,rn,wb,None

def parse_llvm(path, code_path):
    # Build a minimal ARM ELF wrapper so LLVM decodes the raw E32 code segment.
    with tempfile.TemporaryDirectory() as td:
        s=Path(td)/"image.S"; o=Path(td)/"image.o"
        s.write_text(f'.syntax unified\n.arm\n.section .text,"ax",%progbits\n.global shadowkey_code\nshadowkey_code:\n.incbin "{Path(code_path).resolve()}", {CODE_OFF}, {CODE_SIZE}\n')
        cc=subprocess.run(["clang","-target","armv4t-none-eabi","-c",str(s),"-o",str(o)],capture_output=True,text=True)
        if cc.returncode: raise RuntimeError("clang failed: "+cc.stderr)
        r=subprocess.run(["llvm-objdump","-d","--triple=armv4t-none-eabi",str(o)],capture_output=True,text=True)
        if r.returncode: raise RuntimeError("llvm-objdump failed: "+r.stderr)
    pattern=re.compile(r'^\s*([0-9a-f]+):\s+([0-9a-f]{8})\s+([a-z][a-z0-9.]*)\s*(.*?)\s*$',re.I)
    ins={}
    for line in r.stdout.splitlines():
        m=pattern.match(line)
        if m:
            off=int(m.group(1),16)
            ins[BASE+off]=(int(m.group(2),16),m.group(3).lower(),m.group(4).split(' @ ')[0].strip())
    return ins
def lift_ins(addr, word, mnem, ops_s, heads, literal, indirect_call=False, jump_targets_by_addr=None):
    m,cc=cond_mnem(mnem)
    update_flags=False
    if m.endswith('s') and m[:-1] in {"add","sub","rsb","and","orr","eor","bic","mov","mvn","adc","sbc","rsc","lsl","lsr","asr","ror"}:
        m=m[:-1]; update_flags=True
    ops=split_ops(ops_s) if ops_s else []
    nextaddr=addr+4
    guard=lambda stmt: f"if ({COND[cc]}) {{ {stmt} }}" if cc in COND else stmt
    comment=f"/* {mnem} {ops_s} */"
    def branch_target_stmt(target_expr, candidates=None):
        targets=sorted(set(candidates or []))
        if not targets:
            return f"ngage_call(c, {target_expr}); return;"
        cases=" ".join(f"case {cimm(h)}: goto L_{h:08x};" for h in targets)
        return f"{{ uint32_t _target = {target_expr}; switch (_target) {{ {cases} default: ngage_call(c, _target); return; }} }}"
    def rr(s):
        rn = reg(s)
        # In ARM state, reading PC yields current instruction address + 8.
        return cimm(addr + 8) if rn == 15 else f"c->r[{rn}]"
    try:
        # Calls and branches.
        if m in ("bl","blx") and ops:
            # Direct BL target. BLX may also name a register; treat it as an indirect call.
            if m == "blx" and not ops[0].startswith("0x") and not ops[0].startswith("#"):
                target = rr(ops[0])
                stmt = f"c->r[14] = {cimm(nextaddr)}; ngage_call(c, {target});"
                if nextaddr in heads: stmt += f" goto L_{nextaddr:08x};"
                else: stmt += " return;"
                return guard(stmt)+" "+comment
            t=int(ops[0].split()[0],0)+BASE if ops[0].startswith("0x") else None
            if t is None: raise ValueError("call target "+ops[0])
            stmt=f"c->r[14] = {cimm(nextaddr)}; ngage_call(c, {cimm(t)});"
            if nextaddr in heads: stmt += f" goto L_{nextaddr:08x};"
            return guard(stmt)+ " "+comment
        if m in ("b","bx"):
            if m=="bx":
                if reg(ops[0])==14: stmt="return;"
                elif indirect_call:
                    stmt=f"ngage_call(c, {rr(ops[0])});"
                    if nextaddr in heads: stmt += f" goto L_{nextaddr:08x};"
                    else: stmt += " return;"
                else: stmt=f"ngage_call(c, {rr(ops[0])}); return;"
            else:
                off=int(ops[0].split()[0],0); t=BASE+off
                stmt=f"goto L_{t:08x};" if t in heads else f"ngage_call(c, {cimm(t)}); return;"
            return guard(stmt)+" "+comment
        # Stack/register multiple.
        if m=="push":
            regs=parse_reglist(ops[0]); n=len(regs)
            lines=[f"c->r[13] -= {4*n}u;"]
            for i,rn in enumerate(regs): lines.append(f"ngage_w32(c, c->r[13] + {4*i}u, c->r[{rn}]);")
            return guard(" ".join(lines))+" "+comment
        if m=="pop":
            regs=parse_reglist(ops[0]); n=len(regs); lines=[]
            for i,rn in enumerate(regs):
                if rn==15: lines.append("/* loaded PC; return */")
                else: lines.append(f"c->r[{rn}] = ngage_r32(c, c->r[13] + {4*i}u);")
            lines.append(f"c->r[13] += {4*n}u;")
            if 15 in regs: lines.append("return;")
            return guard(" ".join(lines))+" "+comment
        # ARM block transfer instructions (LDM/STM and addressing-mode aliases).
        if m.startswith("ldm") or m.startswith("stm"):
            load=m.startswith("ldm")
            baseop=ops[0]
            wb=baseop.endswith("!")
            baseop=baseop.rstrip("!")
            rn=reg(baseop)
            regtext=ops[1].replace("^","").strip()
            regs=parse_reglist(regtext)
            n=len(regs)
            suffix=m[3:]
            mode=suffix if suffix in ("ia","ib","da","db") else ""
            if not mode:
                aliases={"fd":("db" if load else "ib"),"fa":("da" if load else "ia"),
                         "ed":("ia" if load else "da"),"ea":("ib" if load else "db")}
                mode=aliases.get(suffix,("ia" if load else "ia"))
            low={"ia":0,"ib":4,"db":-4*n,"da":-4*n+4}[mode]
            b=f"c->r[{rn}]"
            lines=["{ uint32_t _b = "+b+";"]
            for i,rr in enumerate(regs):
                off=low+4*i
                a="_b" if off==0 else (f"_b + {off}u" if off>0 else f"_b - {-off}u")
                if load:
                    if rr==15: lines.append(f"c->r[15] = ngage_r32(c, {a});")
                    else: lines.append(f"c->r[{rr}] = ngage_r32(c, {a});")
                else:
                    lines.append(f"ngage_w32(c, {a}, c->r[{rr}]);")
            if wb:
                delta=4*n
                lines.append(f"{b} = _b {'+' if mode in ('ia','ib') else '-'} {delta}u;")
            if load and 15 in regs:
                lines.append("ngage_call(c, c->r[15]); return;")
            lines.append("}")
            return guard(" ".join(lines))+" "+comment
        # Data-processing operations.
        if m in ("mov","mvn") and len(ops)>=2:
            d=f"c->r[{reg(ops[0])}]"; val=shifted_operand(ops[1:], rr, update_flags)
            stmt=f"{d} = {'~(' + val + ')' if m=='mvn' else val};"
            if update_flags: stmt += f" ngage_set_nz(c, {d});"
            return guard(stmt)+" "+comment
        if m in ("adc","sbc","rsc") and len(ops)>=3:
            d=f"c->r[{reg(ops[0])}]"; a=rr(ops[1]); b=shifted_operand(ops[2:], rr, False)
            if m=="adc":
                stmt=f"{d} = {a} + {b} + (uint32_t)ngage_cf(c);"
                if update_flags: stmt=f"{d} = ngage_add_flags(c, {a}, {b}, (uint32_t)ngage_cf(c));"
            elif m=="sbc":
                stmt=f"{d} = {a} - {b} - (uint32_t)!ngage_cf(c);"
                if update_flags: stmt=f"{d} = ngage_sub_flags(c, {a}, {b} + (uint32_t)!ngage_cf(c));"
            else:  # RSC: Operand2 - Rn - (1-C)
                stmt=f"{d} = {b} - {a} - (uint32_t)!ngage_cf(c);"
                if update_flags: stmt=f"{d} = ngage_sub_flags(c, {b}, {a} + (uint32_t)!ngage_cf(c));"
            return guard(stmt)+" "+comment
        if m in ("add","sub","rsb","and","orr","eor","bic","cmp","cmn","tst","teq") and len(ops)>=2:
            if m in ("cmp","cmn","tst","teq"):
                a=rr(ops[0]); b=shifted_operand(ops[1:], rr, m in ("tst","teq") and update_flags)
                fn={"cmp":f"ngage_sub_flags(c, {a}, {b});","cmn":f"ngage_add_flags(c, {a}, {b}, 0);","tst":f"ngage_set_nz(c, {a} & {b});","teq":f"ngage_set_nz(c, {a} ^ {b});"}[m]
                return guard(fn)+" "+comment
            d=f"c->r[{reg(ops[0])}]"; a=rr(ops[1]); b=shifted_operand(ops[2:], rr, update_flags and m in ("and","orr","eor","bic"))
            op={"add":"+","sub":"-","rsb":"RSB","and":"&","orr":"|","eor":"^","bic":"BIC"}[m]
            if update_flags and m in ("add","sub","rsb"):
                if m=="add": stmt=f"{d} = ngage_add_flags(c, {a}, {b}, 0);"
                elif m=="sub": stmt=f"{d} = ngage_sub_flags(c, {a}, {b});"
                else: stmt=f"{d} = ngage_sub_flags(c, {b}, {a});"
            else:
                if op=="RSB": stmt=f"{d} = {b} - {a};"
                elif op=="BIC": stmt=f"{d} = {a} & ~({b});"
                else: stmt=f"{d} = {a} {op} {b};"
                if update_flags: stmt += f" ngage_set_nz(c, {d});"
            return guard(stmt)+" "+comment
        # Single-register shifts, as normalized by LLVM.
        if m in ("lsl","lsr","asr","ror") and len(ops)>=3:
            d=f"c->r[{reg(ops[0])}]"; a=rr(ops[1])
            if ops[2].startswith('#'):
                sh=imm(ops[2]); amt=str(sh)
            else:
                shreg=reg(ops[2]); amt=f"(c->r[{shreg}] & 31u)"
            if m=="lsl": expr=f"({a} << {amt})"
            elif m=="lsr": expr=f"({a} >> {amt})"
            elif m=="asr": expr=f"((uint32_t)((int32_t){a} >> {amt}))"
            else: expr=f"(({a} >> {amt}) | ({a} << ((32u - ({amt})) & 31u)))"
            stmt=f"{d} = {expr};"
            if update_flags: stmt+=f" ngage_set_nz(c, {d});"
            return guard(stmt)+" "+comment
        # Memory operations.
        # ARM post-index translation variants are ordinary memory accesses for our model.
        if m in ("ldrt","strt","ldrbt","strbt"):
            m={"ldrt":"ldr","strt":"str","ldrbt":"ldrb","strbt":"strb"}[m]
        sizes={"ldr":32,"str":32,"ldrb":8,"strb":8,"ldrh":16,"strh":16,"ldrsb":8,"ldrsh":16}
        if m in sizes and len(ops)>=2:
            dreg=reg(ops[0]); addr_expr,rn,wb,post=memop(ops[1],addr)
            if len(ops)>=3 and ops[1].endswith(']'):
                p=ops[2].strip()
                if p.startswith('#'):
                    n=imm(p); post=f"c->r[{rn}] {'+=' if n>=0 else '-='} {abs(n)}u;"
                else:
                    neg=p.startswith('-'); pr=reg(p.lstrip('+-'))
                    post=f"c->r[{rn}] {'-=' if neg else '+='} c->r[{pr}];"
            sz=sizes[m]
            if m.startswith("ldr"):
                # A PC-relative literal load is only [pc] or [pc, #imm]. Do not
                # mistake the #2 in [pc, rN, lsl #2] for a displacement: that
                # form is a computed jump-table dispatch (often LDR{cond} PC).
                is_pc_literal = (m == "ldr" and rn == 15 and not wb and post is None and
                                 re.match(r'^\[\s*pc\s*(?:,\s*#\s*[-+]?(?:0x[0-9a-f]+|\d+))?\s*\]$', ops[1], re.I) is not None)
                if is_pc_literal:
                    va=addr+8
                    mm=re.match(r'^\[\s*pc\s*,\s*#\s*(-?0x[0-9a-f]+|-?\d+)\s*\]$',ops[1],re.I)
                    if mm:
                        disp=int(mm.group(1),0); va=addr+8+disp
                    val=literal(va)
                    if dreg==15:
                        if val is not None:
                            if val in heads: stmt=f"goto L_{val:08x}; /* literal branch target {va:#x} */"
                            else: stmt=f"ngage_call(c, {cimm(val)}); return; /* literal branch target {va:#x} */"
                        else:
                            stmt=branch_target_stmt(f"ngage_r32(c, {addr_expr})", (jump_targets_by_addr or {}).get(addr, []))
                    elif val is not None: stmt=f"c->r[{dreg}] = {cimm(val)}; /* literal {va:#x} */"
                    else: stmt=f"c->r[{dreg}] = ngage_r32(c, {addr_expr});"
                elif dreg==15:
                    stmt=branch_target_stmt(f"ngage_r32(c, {addr_expr})", (jump_targets_by_addr or {}).get(addr, []))
                else:
                    fn={32:"ngage_r32",16:"ngage_r16",8:"ngage_r8"}[sz]
                    stmt=f"c->r[{dreg}] = {fn}(c, {addr_expr});"
            else:
                fn={32:"ngage_w32",16:"ngage_w16",8:"ngage_w8"}[sz]
                cast={32:"uint32_t",16:"uint16_t",8:"uint8_t"}[sz]
                stmt=f"{fn}(c, {addr_expr}, ({cast})c->r[{dreg}]);"
            if wb and not post:
                # Compute updated base using address expression.
                stmt+=f" c->r[{rn}] = {addr_expr};"
            if post: stmt+=" "+post
            if dreg==15 and m.startswith("ldr") and not ("return;" in stmt or "goto L_" in stmt or "switch (_target)" in stmt): stmt+=" return;"
            return guard(stmt)+" "+comment
    except Exception as e:
        reason=str(e).replace('"',"'")
        return f'ngage_unimplemented(c, {cimm(addr)}, "{mnem} {ops_s} [{reason}]"); '+comment
    return f'ngage_unimplemented(c, {cimm(addr)}, "{mnem} {ops_s}"); '+comment

def main():
    global BASE, CODE_OFF, CODE_SIZE
    ap=argparse.ArgumentParser()
    ap.add_argument("app",type=Path)
    ap.add_argument("--map",dest="mapfile",type=Path,default=Path("shadowkey_functions.json"))
    ap.add_argument("--addr",type=lambda s:int(s,0),default=0x1002841c)
    ap.add_argument("--range",action="store_true",help="lift functions at/after --addr, up to --max-functions")
    ap.add_argument("-o","--out",type=Path,default=Path("shadowkey_lifted.c"))
    ap.add_argument("--max-functions",type=int,default=1)
    ap.add_argument("--base",type=lambda s:int(s,0),default=BASE)
    ap.add_argument("--code-offset",type=lambda s:int(s,0),default=CODE_OFF)
    ap.add_argument("--code-size",type=lambda s:int(s,0),default=CODE_SIZE)
    ap.add_argument("--prefix",type=str,default="",help="prefix emitted C function names")
    args=ap.parse_args()
    BASE, CODE_OFF, CODE_SIZE = args.base, args.code_offset, args.code_size
    data=args.app.read_bytes()
    js=json.loads(args.mapfile.read_text())
    allins=parse_llvm(None,args.app)
    fns=sorted(js["functions"],key=lambda f:f["start"])
    if args.range:
        selected=[f for f in fns if f["start"]>=args.addr][:args.max_functions]
    else:
        selected=[f for f in fns if f["start"]==args.addr][:1]
    if not selected:
        raise SystemExit(f"no function(s) selected at {args.addr:#x}")
    selected=selected[:args.max_functions]
    code=data[CODE_OFF:CODE_OFF+CODE_SIZE]
    def literal(va):
        off=va-BASE
        if off<0 or off+4>len(code): return None
        return int.from_bytes(code[off:off+4],"little")
    lines=[
      "/* Experimental LLVM-backed ARM lift; unsupported instructions are explicit stubs. */",
      "#include <stdint.h>",
      'typedef struct { uint32_t r[16]; uint32_t cpsr; uint8_t *mem; } ngage_cpu_t;',
      '#include \"shadowkey_arm_shift.h\"',
      "extern void ngage_call(ngage_cpu_t *, uint32_t);",
      "extern void ngage_unimplemented(ngage_cpu_t *, uint32_t, const char *);",
      "extern uint32_t ngage_r32(ngage_cpu_t *, uint32_t); extern void ngage_w32(ngage_cpu_t *, uint32_t, uint32_t);",
      "extern uint32_t ngage_r16(ngage_cpu_t *, uint32_t); extern void ngage_w16(ngage_cpu_t *, uint32_t, uint16_t);",
      "extern uint32_t ngage_r8(ngage_cpu_t *, uint32_t); extern void ngage_w8(ngage_cpu_t *, uint32_t, uint8_t);",
      "extern uint32_t ngage_add_flags(ngage_cpu_t *, uint32_t, uint32_t, uint32_t); extern uint32_t ngage_sub_flags(ngage_cpu_t *, uint32_t, uint32_t);",
      "extern void ngage_set_nz(ngage_cpu_t *, uint32_t);",
      "extern int ngage_zf(ngage_cpu_t *); extern int ngage_cf(ngage_cpu_t *); extern int ngage_nf(ngage_cpu_t *); extern int ngage_vf(ngage_cpu_t *);",
      ""
    ]
    total=lifted=stubs=0
    for fn in selected:
        # Expand each recovered block start to the complete instruction stream
        # up to its control-flow terminator. The old map often contained only
        # the first instruction of switch-table target blocks; the previous
        # emitter then called the next instruction as if it were a function,
        # corrupting SP/LR. We retain the original starts and walk fall-through
        # paths, adding every actual instruction address to the label set.
        heads_set=set(fn.get("heads",[]))
        jump_targets_by_addr={}
        work=list(heads_set)
        visited=set()
        while work:
            pc=work.pop()
            while fn["start"] <= pc < fn["end"] and pc not in visited:
                row=allins.get(pc)
                if row is None: break
                _,mn,opstr=row
                base_m,cc=cond_mnem(mn)
                ops=split_ops(opstr) if opstr else []
                visited.add(pc); heads_set.add(pc)
                # A computed LDR PC is a switch dispatch. Recover the table
                # targets from the relocated bytes using the preceding CMP.
                is_table=False
                if base_m=="ldr" and len(ops)>=2 and reg(ops[0])==15:
                    mm=re.match(r'^\[\s*pc\s*,\s*(r\d+)\s*,\s*lsl\s*#2\s*\]$',ops[1],re.I)
                    if mm:
                        idxreg=mm.group(1).lower(); maxidx=None
                        prev=allins.get(pc-4)
                        if prev:
                            _,pm,po=prev; pm,_=cond_mnem(pm)
                            p_ops=split_ops(po) if po else []
                            if pm=="cmp" and len(p_ops)==2 and p_ops[0].lower()==idxreg and p_ops[1].startswith('#'):
                                try: maxidx=imm(p_ops[1])
                                except Exception: pass
                        limit=maxidx+1 if maxidx is not None and 0<=maxidx<128 else 32
                        table_targets=[]
                        for i in range(limit):
                            target=literal(pc+8+i*4)
                            if target is None: break
                            if fn["start"] <= target < fn["end"] and target%2==0:
                                table_targets.append(target)
                                if target not in heads_set: heads_set.add(target); work.append(target)
                            elif maxidx is None:
                                break
                        if table_targets: jump_targets_by_addr[pc]=table_targets
                        is_table=True
                # Direct branch target discovery. Conditional branches retain
                # their fall-through path; unconditional branches end this block.
                if base_m=="b" and ops:
                    try:
                        target=BASE+int(ops[0].split()[0],0)
                        if fn["start"] <= target < fn["end"] and target not in heads_set:
                            heads_set.add(target); work.append(target)
                    except Exception: pass
                    if cc is None: break
                elif base_m=="bx":
                    if cc is None: break
                elif base_m=="pop" and ops and 15 in parse_reglist(ops[0]):
                    if cc is None: break
                elif base_m.startswith("ldm") and len(ops)>1 and 15 in parse_reglist(ops[1].replace("^","")):
                    if cc is None: break
                elif base_m=="ldr" and ops and reg(ops[0])==15:
                    if cc is None: break
                # Conditional computed jumps have a fall-through instruction;
                # unconditional ones terminate. For ordinary instructions and
                # BL calls, continue linearly until a terminator or gap.
                if is_table and cc is None: break
                pc += 4
        fn["heads"]=sorted(heads_set)
        heads=sorted(heads_set)
        headset=set(heads)
        lines.append(f"void {args.prefix}{fn['name']}(ngage_cpu_t *c) {{")
        lines.append("    (void)c;")
        if heads:
            lines.append("    if (0) { " + " ".join(f"goto L_{h:08x};" for h in heads) + " }")
        for va in heads:
            row=allins.get(va)
            if row is None:
                word=int.from_bytes(code[va-BASE:va-BASE+4],"little")
                mnem="UNKNOWN"; ops_s=f"0x{word:08x}"
            else:
                word,mnem,ops_s=row
            lines.append(f"L_{va:08x}:")
            prev = allins.get(va-4)
            indirect_call = False
            if prev is not None:
                _, pmnem, pops = prev
                compact = re.sub(r"\s+", "", pops.lower())
                # ARM call idiom: MOV LR, PC ; BX Rn. PC in MOV is VA+8.
                pbase, _pcond = cond_mnem(pmnem.lower())
                if pbase == "mov" and compact == "lr,pc":
                    indirect_call = True
            # Fix ARM's PC read for MOV LR, PC instead of using an uninitialized guest r15.
            if mnem.lower() == "mov" and re.sub(r"\s+", "", ops_s.lower()) == "lr,pc":
                lines.append(f"    c->r[14] = {cimm(va+8)}; /* mov lr, pc (ARM PC semantics) */")
            else:
                lines.append("    "+lift_ins(va,word,mnem,ops_s,headset,literal,indirect_call,jump_targets_by_addr))
            total+=1
            if "ngage_unimplemented" in lines[-1]: stubs+=1
            else: lifted+=1
            # If the next recovered instruction is not adjacent, end this basic block
            # by redispatching to the architectural fall-through address.
            if va+4 not in headset and not (mnem.startswith('b') or mnem.startswith('pop') or mnem in ('bx','bxne','bxeq','bxlt','bxgt')):
                lines.append(f"    ngage_call(c, {cimm(va+4)}); return;")
        lines.append("}")
        lines.append("")
    args.out.write_text("\n".join(lines))
    print(f"Wrote {args.out}; functions={len(selected)}, decoded heads={total}, lifted-subset={lifted}, explicit stubs={stubs}")
if __name__=="__main__": main()
