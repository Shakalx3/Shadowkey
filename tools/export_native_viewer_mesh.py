#!/usr/bin/env python3
"""Export several indexed Shadowkey models and their embedded RGB444 textures.

The record layout is still a tested candidate: compact XYZ positions, two
UV/index domains, then a 16-bit texture. Position remapping is index % vertex_count.
"""
import json, struct, sys
from pathlib import Path

SLOTS = (4, 5, 6)  # bottle, sbarrel, pinetree in models.txt

def read_model(data, idx_data, slot):
    count = struct.unpack_from("<I", idx_data)[0]
    if len(idx_data) != 4 + count * 8:
        raise ValueError("models.idx count/size mismatch")
    if slot >= count:
        raise ValueError(f"slot {slot} outside models.idx")
    offset, size = struct.unpack_from("<II", idx_data, 4 + slot * 8)
    end = offset + size
    if end > len(data):
        raise ValueError(f"slot {slot} extends beyond models.huge")
    header = struct.unpack_from("<7H", data, offset)
    vertex_count, uv_count, triangle_count, coord_count = header[2:6]
    if not vertex_count or coord_count != vertex_count * 3:
        raise ValueError(f"slot {slot}: unsupported coordinate header {header}")
    p = offset + 14
    coords = struct.unpack_from("<" + "h" * coord_count, data, p)
    p += coord_count * 2
    uv_a = struct.unpack_from(">" + "H" * uv_count, data, p)
    p += uv_count * 2
    uv_b = struct.unpack_from(">" + "H" * uv_count, data, p)
    p += uv_count * 2
    ix_a = struct.unpack_from("<" + "H" * (triangle_count * 3), data, p)
    p += triangle_count * 6
    ix_b = struct.unpack_from("<" + "H" * (triangle_count * 3), data, p)
    p += triangle_count * 6
    tex_type, width, height = struct.unpack_from("<3H", data, p)
    p += 6
    if not width or not height or width > 256 or height > 256:
        raise ValueError(f"slot {slot}: invalid texture dimensions {width}x{height}")
    if p + width * height * 2 > end:
        raise ValueError(f"slot {slot}: texture payload exceeds record")
    pixels = struct.unpack_from("<" + "H" * (width * height), data, p)
    if max(pixels) > 0xFFF:
        raise ValueError(f"slot {slot}: pixel data is not RGB444 candidate")
    faces = []
    for indices in (ix_a, ix_b):
        for i in range(0, len(indices), 3):
            tri = indices[i:i+3]
            if max(tri) >= uv_count:
                raise ValueError(f"slot {slot}: index outside component tables")
            corners = []
            for ui in tri:
                vi = ui % vertex_count
                corners.extend((vi, uv_a[ui], uv_b[ui]))
            faces.append(corners)
    return {
        "slot": slot, "offset": offset, "size": size, "header": header,
        "vertices": [coords[i:i+3] for i in range(0, len(coords), 3)],
        "faces": faces, "texture_type": tex_type, "width": width,
        "height": height, "pixels": pixels, "uv_max": [max(uv_a), max(uv_b)], "uv_pairs": uv_pair_count, "uv_pairs": uv_pair_count
    }

def emit_array(lines, ctype, name, values, per_line=12):
    lines.append(f"static const {ctype} {name}[] = {{")
    for i in range(0, len(values), per_line):
        lines.append("    " + ", ".join(str(x) for x in values[i:i+per_line]) + ",")
    lines.append("};")

def main():
    if len(sys.argv) != 2:
        raise SystemExit("usage: export_native_viewer_mesh.py ZONE_DIRECTORY")
    zone = Path(sys.argv[1])
    data = (zone / "models.huge").read_bytes()
    idx_data = (zone / "models.idx").read_bytes()
    models = [read_model(data, idx_data, s) for s in SLOTS]
    names = {4: "bottle", 5: "sbarrel", 6: "pinetree"}
    out = Path("source_bundle/host/step165")
    out.mkdir(parents=True, exist_ok=True)
    h = [
        "#ifndef SHADOWKEY_VIEWER_MODEL_DATA_H",
        "#define SHADOWKEY_VIEWER_MODEL_DATA_H",
        "struct TModelVertex { TInt x; TInt y; TInt z; };",
        "struct TModelFace { TInt a; TInt u0; TInt v0; TInt b; TInt u1; TInt v1; TInt c; TInt u2; TInt v2; };",
        "struct TModelData { const TModelVertex* vertices; TInt vertexCount; const TModelFace* faces; TInt faceCount; const TUint16* texture; TInt textureWidth; TInt textureHeight; const char* name; };"
    ]
    for m in models:
        n = names[m["slot"]]
        h.append(f"static const TModelVertex KVertices_{n}[] = {{")
        for x,y,z in m["vertices"]:
            h.append(f"    {{{x}, {y}, {z}}},")
        h.append("};")
        h.append(f"static const TModelFace KFaces_{n}[] = {{")
        for f in m["faces"]:
            h.append("    {" + ", ".join(map(str, f)) + "},")
        h.append("};")
        emit_array(h, "TUint16", f"KTexture_{n}", m["pixels"], 12)
    h.append("static const TModelData KModels[] = {")
    for m in models:
        n = names[m["slot"]]
        h.append(f'    {{KVertices_{n}, {len(m["vertices"])}, KFaces_{n}, {len(m["faces"])}, KTexture_{n}, {m["width"]}, {m["height"]}, "{n}"}},')
    h.extend(["};", "static const TInt KModelCount = sizeof(KModels) / sizeof(KModels[0]);", "#endif"])
    (out / "model_data.h").write_text("\n".join(h) + "\n", encoding="utf-8")
    report = [{
        "slot": m["slot"], "name": names[m["slot"]], "record_offset": m["offset"],
        "record_size": m["size"], "header_u16": list(m["header"]),
        "vertices": len(m["vertices"]), "faces_exported": len(m["faces"]),
        "texture": [m["width"], m["height"]], "texture_type": m["texture_type"],
        "uv_max": m["uv_max"], "pixel_word_range": [min(m["pixels"]), max(m["pixels"])],
        "index_remap": "index % vertex_count (candidate)"
    } for m in models]
    (out / "model_manifest.json").write_text(json.dumps(report, indent=2), encoding="utf-8")
    print(json.dumps(report, indent=2))

if __name__ == "__main__":
    main()
