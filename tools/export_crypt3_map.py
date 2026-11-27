#!/usr/bin/env python3
"""Export a self-contained 2D placement/path map for the Crypt3 zone."""
from __future__ import annotations
import argparse
import csv
import html
import json
import pathlib
import struct
from collections import Counter

SCALE = 256.0
SIZE = 900
PAD = 55
WORLD = 130.0

def cstr(data: bytes) -> str:
    return data.split(b"\0", 1)[0].decode("ascii", "replace").replace("\xcc", "")

def load_entities(path: pathlib.Path):
    data = path.read_bytes()
    count = struct.unpack_from("<I", data)[0]
    if 4 + count * 72 != len(data):
        raise ValueError("Crypt3.ent does not match count × 72-byte records")
    rows = []
    for i in range(count):
        rec = data[4 + i * 72:4 + (i + 1) * 72]
        x, y, z = struct.unpack_from("<iii", rec, 0)
        yaw = struct.unpack_from("<i", rec, 20)[0]
        rows.append({
            "index": i, "x": x / SCALE, "y": y / SCALE, "z": z / SCALE,
            "yaw": yaw / SCALE, "label": cstr(rec[32:40]),
            "script": cstr(rec[40:72])
        })
    return rows

def load_path(path: pathlib.Path):
    data = path.read_bytes()
    # The name is followed by 0xCC padding; the 23-point count is at 0x42.
    count = struct.unpack_from("<H", data, 0x42)[0]
    start = 0x46
    expected = start + count * 2 * 4
    if expected != len(data):
        raise ValueError(f"Unexpected path layout: count={count}, expected bytes={expected}, actual={len(data)}")
    points = []
    for i in range(count):
        xraw = struct.unpack_from("<I", data, start + i * 8)[0]
        yraw = struct.unpack_from("<I", data, start + i * 8 + 4)[0]
        if xraw > 0xFFFF or yraw > 0xFFFF:
            raise ValueError(f"Path coordinate {i} exceeds 16-bit payload")
        points.append({"index": i, "x_raw": xraw, "y_raw": yraw,
                       "x": xraw / SCALE, "y": yraw / SCALE})
    return points

def category(script: str) -> str:
    s = script.lower()
    if "torch" in s: return "Torch"
    if "monster" in s or (s.startswith("cryptsh3") and s.endswith(".s")): return "Creature"
    if "door" in s: return "Door"
    if "chest" in s: return "Chest"
    return "Prop"

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("zone", type=pathlib.Path)
    args = ap.parse_args()
    root = args.zone
    entities = load_entities(root / "Crypt3.ent")
    path = load_path(root / "Crypt3.pth")
    for row in entities: row["category"] = category(row["script"])
    (root / "Crypt3_path.json").write_text(json.dumps(path, indent=2), encoding="utf-8")
    with (root / "Crypt3_path.csv").open("w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=list(path[0]))
        w.writeheader(); w.writerows(path)

    def sx(x): return PAD + x / WORLD * (SIZE - 2 * PAD)
    def sy(y): return SIZE - PAD - y / WORLD * (SIZE - 2 * PAD)
    palette = {"Torch":"#d69b35", "Creature":"#d65b45", "Door":"#428b72",
               "Chest":"#497eb5", "Prop":"#9872b2"}
    svg = [f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {SIZE} {SIZE}" role="img" aria-label="Crypt3 entity placements and UmbraKeth path">']
    svg.append('<rect width="100%" height="100%" fill="#15191f"/>')
    for tick in range(0, 131, 10):
        x, y = sx(tick), sy(tick)
        svg.append(f'<line x1="{x:.1f}" y1="{PAD}" x2="{x:.1f}" y2="{SIZE-PAD}" stroke="#35404a" stroke-width="1"/>')
        svg.append(f'<line x1="{PAD}" y1="{y:.1f}" x2="{SIZE-PAD}" y2="{y:.1f}" stroke="#35404a" stroke-width="1"/>')
        svg.append(f'<text x="{x:.1f}" y="{SIZE-PAD+22}" fill="#aab4bf" font-size="12" text-anchor="middle">{tick}</text>')
        svg.append(f'<text x="{PAD-12}" y="{y+4:.1f}" fill="#aab4bf" font-size="12" text-anchor="end">{tick}</text>')
    svg.append(f'<polyline points="{" ".join(f"{sx(p["x"]):.1f},{sy(p["y"]):.1f}" for p in path)}" fill="none" stroke="#f4e6a3" stroke-width="3" stroke-linejoin="round" stroke-linecap="round"/>')
    for p in path:
        x,y=sx(p["x"]),sy(p["y"])
        svg.append(f'<circle cx="{x:.1f}" cy="{y:.1f}" r="4" fill="#f4e6a3" stroke="#15191f" stroke-width="1"><title>UmbraKeth path point {p["index"]+1}: {p["x"]:.2f}, {p["y"]:.2f}</title></circle>')
    for e in entities:
        x,y=sx(e["x"]),sy(e["y"])
        color=palette[e["category"]]
        title=html.escape(f'#{e["index"]} {e["script"]} | x={e["x"]:.2f}, y={e["y"]:.2f}, z={e["z"]:.2f}, yaw={e["yaw"]:.2f}')
        radius=6 if e["script"].lower().endswith("umbra_keth.s") else 4
        svg.append(f'<circle cx="{x:.1f}" cy="{y:.1f}" r="{radius}" fill="{color}" stroke="#0c1014" stroke-width="1"><title>{title}</title></circle>')
    svg.append(f'<text x="{SIZE/2}" y="28" fill="#f1f4f7" font-size="19" text-anchor="middle">Crypt3 — {len(entities)} placements and UmbraKeth path ({len(path)} points)</text>')
    svg.append(f'<text x="{SIZE/2}" y="{SIZE-12}" fill="#aab4bf" font-size="12" text-anchor="middle">Candidate world coordinates: signed 8.8 (raw / 256) · hover markers for details</text>')
    svg.append('</svg>')
    svg_text="\n".join(svg)
    (root / "Crypt3_entity_path_map.svg").write_text(svg_text, encoding="utf-8")
    legend=" ".join(f'<span><i style="background:{color}"></i>{name} ({sum(e["category"]==name for e in entities)})</span>' for name,color in palette.items())
    page=f"""<!doctype html><html lang="en"><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Shadowkey — Crypt3 placement map</title><style>body{{margin:0;background:#0d1117;color:#e6edf3;font:15px system-ui}}main{{max-width:980px;margin:auto;padding:18px}}h1{{font-size:22px}}p{{color:#aab4bf}}svg{{width:100%;height:auto;border:1px solid #30363d;border-radius:10px}}.legend{{display:flex;gap:16px;flex-wrap:wrap;margin:12px 0}}.legend span{{display:flex;align-items:center;gap:6px}}.legend i{{width:10px;height:10px;border-radius:50%;display:inline-block}}a{{color:#8ab4f8}}</style><main><h1>Crypt3 — entity placements and UmbraKeth path</h1><p>Offline map generated from Crypt3.ent and Crypt3.pth. Hover a marker to inspect its source record. Coordinates are shown as raw / 256; this scale is supported by the matching entity and named path data, while the exact engine axis convention remains to be confirmed.</p><div class="legend">{legend}<span><i style="background:#f4e6a3"></i>UmbraKeth path ({len(path)} points)</span></div>{svg_text}<p>Generated by tools/export_crypt3_map.py. This is a placement plot, not reconstructed room geometry.</p></main></html>"""
    (root / "Crypt3_entity_path_map.html").write_text(page, encoding="utf-8")
    print(f"Exported {len(entities)} entity placements and {len(path)} UmbraKeth path points.")
    print("Path start/end:", path[0], path[-1])
    print("Entity categories:", dict(Counter(e["category"] for e in entities)))
    print("The entity at Umbra is near the first named path point; exact path semantics still need runtime validation.")

if __name__ == "__main__":
    main()
