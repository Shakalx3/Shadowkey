#!/usr/bin/env python3
"""Experimental IDA-free E32/ARM function recovery for Shadowkey's 6R51.APP.

This is a conservative prototype, NOT a replacement for IDA/Ghidra. It starts
from the E32 export (the app's NewApplication-style factory), follows direct
ARM BL calls, traverses basic blocks, and emits NGageRecomp-compatible JSON.
Only ARM-state 32-bit instructions are analyzed; Thumb, indirect calls, jump
 tables, exception metadata, and embedded data can cause missed/false results.

Usage:
  python shadowkey_recover.py 6R51.APP -o shadowkey_functions.json
  python shadowkey_recover.py 6R51.APP --root 0x1002841c --max-functions 10000
"""
import argparse, json, struct, hashlib, csv, re
from pathlib import Path
from collections import deque, Counter

CODE_OFF = 0x7C
CODE_SIZE = 0x1009C4
BASE = 0x10000000
DEFAULT_EXPORT = BASE + 0x2841C


def u32(b, off):
    return struct.unpack_from('<I', b, off)[0]

def s24(v):
    x = v & 0x00FFFFFF
    if x & 0x00800000:
        x -= 0x01000000
    return x << 2

def branch_kind(w):
    cond = (w >> 28) & 0xF
    if cond == 0xF:
        return None
    if (w & 0x0F000000) == 0x0B000000:
        return 'bl'
    if (w & 0x0E000000) == 0x0A000000:
        return 'b'
    return None

def branch_target(w, va):
    return (va + 8 + s24(w)) & 0xFFFFFFFF

def is_bx(w):
    return (w & 0x0FFFFFF0) == 0x012FFF10

def bx_reg(w):
    return w & 0xF

def is_push_prologue(w):
    # STMDB sp!, {register-list}; allow conditional variants.
    return (w & 0x0FFF0000) == 0x092D0000 and (w & 0xFFFF) != 0

def is_ldm_pc_return(w):
    # LDM* with PC in register list; conservative return heuristic.
    return ((w & 0x0E100000) == 0x08100000) and bool(w & (1 << 15))

def is_ldr_pc(w):
    # Single data transfer, load=1, Rd=pc. Used for indirect dispatch/jump tables.
    return ((w & 0x0C100000) == 0x04100000) and (((w >> 12) & 0xF) == 15)

def is_mov_pc_lr(w):
    # Data processing MOV pc,lr, with no shift/immediate operand.
    return ((w & 0x0FE0FFFF) == 0x01A0F00E)

def is_mov_lr_pc(w):
    return ((w & 0x0FE0FFFF) == 0x01A0E00F)

def is_in_code(va, base, size):
    return base <= (va & ~1) < base + size

class Recover:
    def __init__(self, data, base, code_off, code_size):
        self.file = data
        self.base = base
        self.code_off = code_off
        self.code_size = code_size
        self.code = data[code_off:code_off + code_size]
        self.words = len(self.code) // 4
        self.funcs = {}
        self.queue = deque()
        self.call_edges = set()
        self.unknown_indirect = Counter()
        self.out_of_range_calls = Counter()
        self.root = None
        self.known_starts = set()
        self.candidate_reason = {}

    def word_at(self, va):
        off = va - self.base
        if off < 0 or off + 4 > len(self.code) or off & 3:
            return None
        return struct.unpack_from('<I', self.code, off)[0]

    def looks_like_function(self, va):
        w = self.word_at(va)
        if w is None:
            return False
        if is_push_prologue(w):
            return True
        # Common frame setup: SUB sp,sp,#imm; MOV ip,sp; STM... or similar.
        if (w & 0xFFFFF000) == 0xE24DD000:
            w2 = self.word_at(va + 4)
            if w2 is not None and (is_push_prologue(w2) or (w2 & 0x0FFF0000) == 0x092D0000):
                return True
        return False

    def pointer_target_looks_like_function(self, va):
        """Conservative filter for vtable-like pointers in the final data-heavy image tail."""
        w = self.word_at(va)
        if w is None or (va & 3):
            return False
        if self.looks_like_function(va):
            return True
        bk = branch_kind(w)
        if bk == 'b' and ((w >> 28) & 0xF) == 0xE:
            return True  # unconditional tail veneer
        if is_bx(w) and bx_reg(w) == 14:
            return True  # trivial leaf / no-op override
        # Short leaf methods often have no stack frame (getters, bool-returning overrides).
        for i in range(12):
            wi = self.word_at(va + 4 * i)
            if wi is None:
                break
            if is_bx(wi) and bx_reg(wi) == 14:
                return True
            if is_mov_pc_lr(wi) or is_ldm_pc_return(wi):
                return True
            bki = branch_kind(wi)
            if bki == 'b' and ((wi >> 28) & 0xF) == 0xE:
                return i == 0
        return False

    def enqueue_call(self, src, target):
        target &= 0xFFFFFFFF
        # Strip Thumb bit for range checks; current pass can only decode ARM state.
        if not is_in_code(target, self.base, self.code_size):
            self.out_of_range_calls[target] += 1
            return
        if target & 3:
            # Odd/even interworking targets cannot be safely decoded as ARM here.
            self.unknown_indirect[target] += 1
            return
        self.call_edges.add((src, target))
        if target not in self.funcs and target not in self.queue:
            self.queue.append(target)

    def analyze_function(self, start):
        if start in self.funcs:
            return
        if not is_in_code(start, self.base, self.code_size) or start & 3:
            return
        todo = deque([start])
        seen = set()
        calls = set()
        while todo and len(seen) < 20000:
            pc = todo.popleft()
            while is_in_code(pc, self.base, self.code_size) and not (pc & 3):
                if pc in seen:
                    break
                # Don't absorb another already-known function into this one.
                if pc != start and pc in self.known_starts:
                    break
                seen.add(pc)
                w = self.word_at(pc)
                if w is None:
                    break
                bk = branch_kind(w)
                cond = (w >> 28) & 0xF
                unconditional = cond == 0xE
                if bk == 'bl':
                    target = branch_target(w, pc)
                    calls.add(target)
                    self.enqueue_call(pc, target)
                    pc += 4
                    continue
                if bk == 'b':
                    target = branch_target(w, pc)
                    # Conditional branches have both successors; unconditional branches
                    # usually stay within the function unless they tail-call a prologue.
                    if is_in_code(target, self.base, self.code_size):
                        if target != start and self.looks_like_function(target):
                            self.enqueue_call(pc, target)
                        else:
                            todo.append(target)
                    if unconditional:
                        break
                    pc += 4
                    continue
                if is_bx(w):
                    reg = bx_reg(w)
                    # ARMv4 indirect-call idiom: MOV LR,PC ; BX Rm. Continue after BX.
                    prev = self.word_at(pc - 4) if pc >= self.base + 4 else None
                    if reg != 14 and prev is not None and is_mov_lr_pc(prev):
                        self.unknown_indirect[pc] += 1
                        pc += 4
                        continue
                    # BX LR is a return; BX other register is an indirect tail dispatch.
                    if reg == 14 or unconditional:
                        break
                    pc += 4
                    continue
                if is_mov_pc_lr(w) or is_ldm_pc_return(w):
                    if unconditional:
                        break
                    pc += 4
                    continue
                if is_ldr_pc(w):
                    # Computed branch / virtual dispatch. End this path; a later CFG pass
                    # can recover jump-table targets when the table is identified.
                    self.unknown_indirect[pc] += 1
                    if unconditional:
                        break
                    pc += 4
                    continue
                pc += 4
        if not seen:
            return
        # A bad candidate can branch into earlier code. Keep only heads at/after the
        # candidate entry so the emitted JSON's byte window and start address agree.
        starts = sorted(h for h in seen if h >= start)
        if not starts:
            return
        hi = starts[-1] + 4
        off = start - self.base
        raw = self.code[off:off + (hi - start)]
        self.funcs[start] = {
            'name': f'sub_{start:08x}',
            'start': start,
            'end': hi,
            'size': hi - start,
            'thumb': False,
            'calls_out': len(calls),
            'candidate_reason': self.candidate_reason.get(start, 'call-target'),
            'heads': starts,
            'bytes': raw.hex(),
        }

    def scan_candidates(self, root):
        prologues = set()
        thunks = set()
        bl_targets = set()
        for off in range(0, len(self.code) - 3, 4):
            w = struct.unpack_from('<I', self.code, off)[0]
            va = self.base + off
            if is_push_prologue(w):
                prologues.add(va)
            # ARMv4 import veneer: LDR ip,[pc,#4]; LDR ip,[ip]; BX ip; literal.
            if off + 16 <= len(self.code):
                w1, w2, w3 = struct.unpack_from('<III', self.code, off)
                if w1 == 0xE59FC004 and w2 == 0xE59CC000 and w3 == 0xE12FFF1C:
                    thunks.add(va)
            bk = branch_kind(w)
            if bk == 'bl':
                t = branch_target(w, va)
                if is_in_code(t, self.base, self.code_size) and not (t & 3):
                    bl_targets.add(t)
        # A direct call target is trusted as a candidate only if it has a normal
        # stack prologue or matches the import-veneer idiom. This suppresses many
        # false targets caused by decoding literal pools as instructions.
        # Vtable-like pointer arrays live in the data-heavy tail of this E32 image.
        # Their targets include methods with no conventional stack prologue (e.g. tiny getters).
        # Restrict this heuristic to runs of >=4 consecutive code pointers in the final 16 KiB.
        pointer_targets = set()
        tail_off = max(0, len(self.code) - 0x4000)
        i = (tail_off + 3) & ~3
        while i + 4 <= len(self.code):
            w = struct.unpack_from('<I', self.code, i)[0]
            if self.base <= w < self.base + self.code_size and not (w & 3):
                run_start = i
                vals = []
                while i + 4 <= len(self.code):
                    v = struct.unpack_from('<I', self.code, i)[0]
                    if not (self.base <= v < self.base + self.code_size and not (v & 3)):
                        break
                    vals.append(v)
                    i += 4
                if len(vals) >= 4:
                    for target in vals:
                        if self.pointer_target_looks_like_function(target):
                            pointer_targets.add(target)
            else:
                i += 4
        self.pointer_table_starts = pointer_targets
        starts = set(prologues) | set(thunks) | pointer_targets | {root}
        for t in bl_targets:
            if t in prologues or t in thunks:
                starts.add(t)
        direct_call_leaf_targets = set()
        for t in bl_targets:
            if t not in prologues and t not in thunks and t not in pointer_targets:
                if self.pointer_target_looks_like_function(t):
                    direct_call_leaf_targets.add(t)
                    starts.add(t)
        self.pointer_table_starts = pointer_targets
        self.direct_call_leaf_starts = direct_call_leaf_targets
        self.known_starts = starts
        for x in prologues:
            self.candidate_reason[x] = 'stack-prologue'
        for x in thunks:
            self.candidate_reason[x] = 'import-thunk'
        for x in pointer_targets:
            self.candidate_reason.setdefault(x, 'pointer-table')
        for x in direct_call_leaf_targets:
            self.candidate_reason.setdefault(x, 'direct-call-leaf')
        self.candidate_reason[root] = 'export-root'
        return prologues, thunks, bl_targets

    def run(self, root, max_functions):
        self.root = root
        prologues, thunks, bl_targets = self.scan_candidates(root)
        # Analyze candidates in address order. Unlike a root-only call graph this
        # includes methods reached via vtables/indirect dispatch, common in Symbian C++.
        candidates = sorted(self.known_starts)
        for f in candidates:
            if len(self.funcs) >= max_functions:
                break
            self.analyze_function(f)
        return self.funcs, prologues, thunks, bl_targets


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('app', type=Path)
    ap.add_argument('-o', '--out', type=Path, default=Path('shadowkey_functions.json'))
    ap.add_argument('--root', type=lambda x: int(x, 0), default=DEFAULT_EXPORT)
    ap.add_argument('--base', type=lambda x: int(x, 0), default=BASE)
    ap.add_argument('--code-offset', type=lambda x: int(x, 0), default=CODE_OFF)
    ap.add_argument('--code-size', type=lambda x: int(x, 0), default=CODE_SIZE)
    ap.add_argument('--max-functions', type=int, default=10000)
    ap.add_argument('--imports-csv', type=Path, default=None, help='previously extracted import-block CSV (defaults to shadowkey_imports.csv beside the APP)')
    args = ap.parse_args()
    data = args.app.read_bytes()
    if len(data) < 0x80 or data[16:20] != b'EPOC':
        raise SystemExit('Not a recognizable E32Image: missing EPOC signature at 0x10')
    if args.code_offset + args.code_size > len(data):
        raise SystemExit('Configured code region extends beyond input file')
    code = data[args.code_offset:args.code_offset + args.code_size]
    if len(code) < 4:
        raise SystemExit('Empty code region')
    rec = Recover(data, args.base, args.code_offset, args.code_size)
    funcs, prologues, thunks, bl_targets = rec.run(args.root, args.max_functions)
    funcs_list = sorted(funcs.values(), key=lambda f: f['start'])

    # Resolve import veneers to the E32 ordinal arrays. The ordinal arrays are stored
    # contiguously in the tail of the code image. We find each DLL's array in import
    # block order, then map each veneer literal to its exact (DLL, ordinal) slot.
    imports_csv = args.imports_csv or (args.app.parent / 'shadowkey_imports.csv')
    import_blocks = []
    thunk_map = {}
    if imports_csv.exists():
        with imports_csv.open(newline='') as fh:
            for row in csv.DictReader(fh):
                if row.get('file') != '6R51.APP':
                    continue
                ords = [int(x.strip()) for x in row['ordinals'].split(',') if x.strip()]
                found = None
                for off in range(0, len(code) - 4 * len(ords) + 1, 4):
                    va = args.base + off
                    if import_blocks and va < import_blocks[-1]['base'] + 4 * len(import_blocks[-1]['ordinals']):
                        continue
                    vals = list(struct.unpack_from('<' + 'I' * len(ords), code, off))
                    if vals == ords:
                        found = va
                        break
                if found is None:
                    import_blocks.append({'dependency': row['dependency'], 'ordinals': ords, 'base': None})
                else:
                    import_blocks.append({'dependency': row['dependency'], 'ordinals': ords, 'base': found})
        for va in sorted(thunks):
            off = va - args.base
            ptr = struct.unpack_from('<I', code, off + 12)[0]
            for block in import_blocks:
                b = block['base']; ords = block['ordinals']
                if b is not None and b <= ptr < b + 4 * len(ords) and (ptr - b) % 4 == 0:
                    pos = (ptr - b) // 4
                    dll = block['dependency'].split('[')[0]
                    thunk_map[va] = {'dependency': block['dependency'], 'dll': dll,
                                     'ordinal': ords[pos], 'position': pos + 1,
                                     'slot_address': ptr}
                    break
    for f in funcs_list:
        t = thunk_map.get(f['start'])
        if t:
            safe_dll = re.sub(r'[^A-Za-z0-9_]', '_', t['dll'])
            f['name'] = f'import_{safe_dll}_ord_{t["ordinal"]}'
            f['import'] = {k: t[k] for k in ('dependency', 'ordinal', 'position', 'slot_address')}
    # One mapped code segment matches the schema consumed by NGageRecomp's lift.py.
    payload = {
        'functions': funcs_list,
        'segments': [{
            'name': '.text', 'start': args.base, 'end': args.base + len(code),
            'perm': 5, 'bytes': code.hex()
        }],
        'recovery': {
            'method': 'whole-image ARM prologue/import-veneer scan plus conservative CFG traversal',
            'root': args.root, 'base': args.base,
            'code_file_offset': args.code_offset, 'code_size': len(code),
            'input_sha256': hashlib.sha256(data).hexdigest(),
            'function_count': len(funcs_list),
            'prologue_candidates': len(prologues),
            'import_thunk_candidates': len(thunks),
            'vtable_pointer_candidates': len(getattr(rec, 'pointer_table_starts', set())),
            'direct_call_leaf_candidates': len(getattr(rec, 'direct_call_leaf_starts', set())),
            'unique_direct_BL_targets_in_image': len(bl_targets),
            'mapped_import_thunks': len(thunk_map),
            'import_blocks_found': sum(1 for b in import_blocks if b['base'] is not None),
            'import_block_count': len(import_blocks),
            'instruction_heads': sum(len(f['heads']) for f in funcs_list),
            'direct_call_edges': len(rec.call_edges),
            'unresolved_indirect_sites_or_targets': sum(rec.unknown_indirect.values()),
            'out_of_code_direct_call_targets': dict(rec.out_of_range_calls),
            'warning': 'Experimental; not IDA/Ghidra-grade. ARM-state only; vtable-like pointer runs in the final 16 KiB are a heuristic and can create false positives. Thumb, indirect calls/jump tables, and exact function boundaries are not fully recovered.'
        }
    }
    args.out.write_text(json.dumps(payload, separators=(',', ':')))
    report = args.out.with_suffix('.summary.txt')
    sizes = [f['size'] for f in funcs_list]
    roots_calls = sorted(t for s, t in rec.call_edges if s >= args.root and s < args.root + 0x10000)
    lines = [
        'Shadowkey IDA-free ARM CFG recovery (experimental)',
        f'Input: {args.app}',
        f'SHA-256: {hashlib.sha256(data).hexdigest()}',
        f'Root: 0x{args.root:08X}',
        f'Code: file+0x{args.code_offset:X}, VA 0x{args.base:08X}..0x{args.base+len(code):08X}, {len(code):,} bytes',
        f'Functions recovered: {len(funcs_list):,}',
        f'Stack-prologue candidates: {len(prologues):,}',
        f'Import-thunk candidates: {len(thunks):,}',
        f'Vtable-like pointer targets: {len(getattr(rec, "pointer_table_starts", set())):,}',
        f'Direct-call leaf/veneer targets: {len(getattr(rec, "direct_call_leaf_starts", set())):,}',
        f'Unique direct BL targets in linear sweep: {len(bl_targets):,}',
        f'Import blocks located: {sum(1 for b in import_blocks if b["base"] is not None)}/{len(import_blocks)}',
        f'Import thunks mapped to DLL+ordinal: {len(thunk_map):,}/{len(thunks):,}',
        f'Instruction heads across functions: {sum(len(f["heads"]) for f in funcs_list):,}',
        f'Direct call edges: {len(rec.call_edges):,}',
        f'Unresolved indirect sites/targets: {sum(rec.unknown_indirect.values()):,}',
        f'Function size median/max: {sorted(sizes)[len(sizes)//2] if sizes else 0:,} / {max(sizes) if sizes else 0:,} bytes',
        '', 'First 40 recovered functions:',
    ]
    for f in funcs_list[:40]:
        lines.append(f'  0x{f["start"]:08X}  size={f["size"]:6,}  heads={len(f["heads"]):5,}  calls={f["calls_out"]:3}  {rec.candidate_reason.get(f["start"], "call-target")}')
    lines += ['', 'Limitations:', payload['recovery']['warning']]
    report.write_text('\n'.join(lines) + '\n')
    # Sidecar CSVs make the recovered import layer auditable and reusable.
    thunk_csv = args.out.with_name('shadowkey_import_thunks.csv')
    with thunk_csv.open('w', newline='') as fh:
        w = csv.writer(fh)
        w.writerow(['thunk_address', 'slot_address', 'dependency', 'ordinal', 'position_in_dependency_block'])
        for va in sorted(thunk_map):
            t = thunk_map[va]
            w.writerow([f'0x{va:08X}', f'0x{t["slot_address"]:08X}', t['dependency'], t['ordinal'], t['position']])
    blocks_csv = args.out.with_name('shadowkey_import_blocks.csv')
    with blocks_csv.open('w', newline='') as fh:
        w = csv.writer(fh)
        w.writerow(['dependency', 'array_base', 'import_count', 'ordinals'])
        for b in import_blocks:
            w.writerow([b['dependency'], f'0x{b["base"]:08X}' if b['base'] is not None else '', len(b['ordinals']), ','.join(map(str,b['ordinals']))])
    print('\n'.join(lines))
    print(f'\nWrote {args.out} ({args.out.stat().st_size:,} bytes)')
    print(f'Wrote {report} ({report.stat().st_size:,} bytes)')
    print(f'Wrote {thunk_csv} ({thunk_csv.stat().st_size:,} bytes)')
    print(f'Wrote {blocks_csv} ({blocks_csv.stat().st_size:,} bytes)')

if __name__ == '__main__':
    main()
