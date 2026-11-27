#!/usr/bin/env python3
"""Export a small candidate Shadowkey model as C++ arrays for the Symbian viewer.

The model record structure is parsed from models.idx. The position-index mapping
(index modulo position_count) remains a hypothesis and is recorded in the report.
"""
import json, struct, sys
from pathlib import Path

def main():
    if len(sys.argv) != 3:
        raise SystemExit("usage: export_native_viewer_mesh.py ZONE_DIRECTORY MODEL_SLOT")
    zone = Path(sys.argv[1])
    slot = int(sys.argv[2])
    idx = (zone / "models.idx").read_bytes()
    huge = (zone / "models.huge").read_bytes()
    count = struct.unpack_from("<I", idx)[0]
    if len(idx) != 4 + count * 8:
        raise ValueError("models.idx count/size mismatch")
    if not 0 <= slot < count:
        raise ValueError("model slot outside models.idx")
    offset, size = struct.unpack_from("<II", idx, 4 + slot * 8)
    header = struct.unpack_from("<7H", huge, offset)
    vertex_count, index_value_count, triangle_count, coordinate_value_count = header[2:6]
    if coordinate_value_count != vertex_count * 3:
        raise ValueError("coordinate count does not equal vertex_count × 3")
    coord_offset = offset + 14
    uv_a_offset = coord_offset + coordinate_value_count * 2
    uv_b_offset = uv_a_offset + index_value_count * 2
    index_a_offset = uv_b_offset + index_value_count * 2
    index_b_offset = index_a_offset + index_value_count * 2
    tail_offset = index_b_offset + index_value_count * 2
    if tail_offset + 6 > offset + size:
        raise ValueError("record is too short for inferred mesh arrays")
    coords = struct.unpack_from("<" + "h" * coordinate_value_count, huge, coord_offset)
    idx_a = struct.unpack_from("<" + "H" * index_value_count, huge, index_a_offset)
    idx_b = struct.unpack_from("<" + "H" * index_value_count, huge, index_b_offset)
    if len(idx_a) != triangle_count * 3 or len(idx_b) != triangle_count * 3:
        raise ValueError("index arrays do not match triangle_count × 3")
    # Candidate remap: two expanded material/index domains address the same
    # compact coordinate array. Preserve this as a testable hypothesis.
    faces = [tuple(v % vertex_count for v in idx_a[i:i+3]) for i in range(0, len(idx_a), 3)]
    faces += [tuple(v % vertex_count for v in idx_b[i:i+3]) for i in range(0, len(idx_b), 3)]
    if any(max(face) >= vertex_count for face in faces):
        raise ValueError("remapped face index outside coordinate table")

    out = Path("source_bundle/host/step165")
    out.mkdir(parents=True, exist_ok=True)
    h = []
    h.append("#ifndef SHADOWKEY_VIEWER_MODEL_DATA_H")
    h.append("#define SHADOWKEY_VIEWER_MODEL_DATA_H")
    h.append("struct TModelVertex { TInt x; TInt y; TInt z; };")
    h.append("struct TModelFace { TInt a; TInt b; TInt c; };")
    h.append(f"static const TInt KModelVertexCount = {vertex_count};")
    h.append(f"static const TInt KModelFaceCount = {len(faces)};")
    h.append("static const TModelVertex KModelVertices[KModelVertexCount] = {")
    for i in range(vertex_count):
        x,y,z = coords[i*3:i*3+3]
        h.append(f"    {{{x}, {y}, {z}}},")
    h.append("};")
    h.append("static const TModelFace KModelFaces[KModelFaceCount] = {")
    for a,b,c in faces:
        h.append(f"    {{{a}, {b}, {c}}},")
    h.append("};")
    h.append("#endif")
    (out / "model_data.h").write_text("\n".join(h) + "\n", encoding="utf-8")

    texture_header = struct.unpack_from("<3H", huge, tail_offset)
    report = {
        "model_slot": slot, "record_offset": offset, "record_size": size,
        "header_u16": list(header), "vertex_count": vertex_count,
        "triangle_count_per_index_set": triangle_count,
        "index_values_per_set": index_value_count,
        "coordinate_values": coordinate_value_count,
        "coordinate_offset": coord_offset, "uv_a_offset": uv_a_offset,
        "uv_b_offset": uv_b_offset, "index_a_offset": index_a_offset,
        "index_b_offset": index_b_offset, "trailing_header_offset": tail_offset,
        "trailing_header_u16": list(texture_header),
        "face_count_exported": len(faces),
        "index_a_range": [min(idx_a), max(idx_a)],
        "index_b_range": [min(idx_b), max(idx_b)],
        "index_remap": "index % vertex_count (candidate; requires visual/device validation)",
        "note": "The two index domains are preserved as separate face sets. This is a first native rendering candidate, not a final validated interpretation."
    }
    (out / "model_manifest.json").write_text(json.dumps(report, indent=2), encoding="utf-8")
    print(json.dumps(report, indent=2))

if __name__ == "__main__":
    main()
