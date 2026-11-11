import json
import re
import sys

SVG_PATH = sys.argv[1]
OUT = sys.argv[2]

FPS = 60
TOTAL = 240
W, H = 200, 250
LOGO_SCALE = 200
LOGO_POS = [24.25, 12]
STROKE_COLOR = "#147484"


def hex_rgba(h):
    h = h.lstrip("#")
    return [int(h[i:i + 2], 16) / 255 for i in (0, 2, 4)] + [1]


def tokenize(d):
    return re.findall(r"[MmLlHhVvCcSsQqZz]|-?(?:\d+\.?\d*|\.\d+)(?:e-?\d+)?", d)


def parse_path(d):
    toks = tokenize(d)
    i = 0
    subpaths = []
    cur = None
    pos = [0.0, 0.0]
    start = [0.0, 0.0]
    last_ctrl = None
    cmd = None

    def num():
        nonlocal i
        v = float(toks[i])
        i += 1
        return v

    def add_cubic(c1, c2, p):
        v = cur["v"]
        prev = v[-1]
        cur["o"][-1] = [c1[0] - prev[0], c1[1] - prev[1]]
        v.append(list(p))
        cur["i"].append([c2[0] - p[0], c2[1] - p[1]])
        cur["o"].append([0, 0])

    while i < len(toks):
        t = toks[i]
        if re.match(r"[A-Za-z]", t):
            cmd = t
            i += 1
        rel = cmd.islower()
        c = cmd.upper()
        if c == "M":
            x, y = num(), num()
            if rel:
                x, y = x + pos[0], y + pos[1]
            cur = {"v": [[x, y]], "i": [[0, 0]], "o": [[0, 0]], "c": False}
            subpaths.append(cur)
            pos = [x, y]
            start = [x, y]
            cmd = "l" if rel else "L"
            last_ctrl = None
        elif c == "L":
            x, y = num(), num()
            if rel:
                x, y = x + pos[0], y + pos[1]
            add_cubic(pos, [x, y], [x, y])
            pos = [x, y]
            last_ctrl = None
        elif c == "H":
            x = num()
            x = x + pos[0] if rel else x
            add_cubic(pos, [x, pos[1]], [x, pos[1]])
            pos = [x, pos[1]]
            last_ctrl = None
        elif c == "V":
            y = num()
            y = y + pos[1] if rel else y
            add_cubic(pos, [pos[0], y], [pos[0], y])
            pos = [pos[0], y]
            last_ctrl = None
        elif c == "C":
            pts = [num() for _ in range(6)]
            if rel:
                pts = [pts[k] + pos[k % 2] for k in range(6)]
            c1, c2, p = pts[0:2], pts[2:4], pts[4:6]
            add_cubic(c1, c2, p)
            pos = p
            last_ctrl = c2
        elif c == "S":
            pts = [num() for _ in range(4)]
            if rel:
                pts = [pts[k] + pos[k % 2] for k in range(4)]
            c1 = [2 * pos[0] - last_ctrl[0], 2 * pos[1] - last_ctrl[1]] if last_ctrl else pos
            c2, p = pts[0:2], pts[2:4]
            add_cubic(c1, c2, p)
            pos = p
            last_ctrl = c2
        elif c == "Q":
            pts = [num() for _ in range(4)]
            if rel:
                pts = [pts[k] + pos[k % 2] for k in range(4)]
            q, p = pts[0:2], pts[2:4]
            c1 = [pos[0] + 2 / 3 * (q[0] - pos[0]), pos[1] + 2 / 3 * (q[1] - pos[1])]
            c2 = [p[0] + 2 / 3 * (q[0] - p[0]), p[1] + 2 / 3 * (q[1] - p[1])]
            add_cubic(c1, c2, p)
            pos = p
            last_ctrl = None
        elif c == "Z":
            cur["c"] = True
            v = cur["v"]
            if len(v) > 1 and abs(v[-1][0] - v[0][0]) < 1e-3 and abs(v[-1][1] - v[0][1]) < 1e-3:
                cur["i"][0] = cur["i"][-1]
                v.pop()
                cur["i"].pop()
                cur["o"].pop()
            pos = list(start)
            last_ctrl = None
    return subpaths


def r(x):
    return round(x, 4)


def sh(sp):
    return {
        "ty": "sh",
        "ks": {"a": 0, "k": {
            "c": sp["c"],
            "v": [[r(a), r(b)] for a, b in sp["v"]],
            "i": [[r(a), r(b)] for a, b in sp["i"]],
            "o": [[r(a), r(b)] for a, b in sp["o"]],
        }},
    }


EASE_OUT = {"o": {"x": [0.33], "y": [0]}, "i": {"x": [0.2], "y": [1]}}
EASE_IO = {"o": {"x": [0.45], "y": [0]}, "i": {"x": [0.55], "y": [1]}}
OVERSHOOT = {"o": {"x": [0.3], "y": [0]}, "i": {"x": [0.4], "y": [1.6]}}


def static(v):
    return {"a": 0, "k": v}


def anim(keys, ease=EASE_OUT):
    out = []
    for n, (t, v) in enumerate(keys):
        k = {"t": t, "s": v if isinstance(v, list) else [v]}
        if n < len(keys) - 1:
            k.update(ease)
        out.append(k)
    return {"a": 1, "k": out}


def transform(p=(0, 0), a=(0, 0), s=None, o=None):
    return {
        "ty": "tr",
        "p": p if isinstance(p, dict) else static(list(p)),
        "a": static(list(a)),
        "s": s or static([100, 100]),
        "r": static(0),
        "o": o or static(100),
        "sk": static(0),
        "sa": static(0),
    }


def group(name, items, tr=None):
    return {"ty": "gr", "nm": name, "it": items + [tr or transform()]}


def fill(color, opacity=None):
    return {"ty": "fl", "c": static(hex_rgba(color)), "o": opacity or static(100), "r": 1}


def stroke(color, width):
    return {"ty": "st", "c": static(hex_rgba(color)), "o": static(100), "w": static(width), "lc": 2, "lj": 2}


def trim(t0, t1):
    return {"ty": "tm", "s": static(0), "e": anim([(t0, 0), (t1, 100)], EASE_IO), "o": static(0), "m": 1}


svg = open(SVG_PATH).read()
paths = re.findall(r'<path d="([^"]+)" fill="([^"]+)"', svg)
shapes = [(parse_path(d), color) for d, color in paths]

HANDS, CENTER_OUT, RIGHT_OUT, LEFT_OUT = 0, 3, 6, 9
CENTER_FILLS, RIGHT_FILLS, LEFT_FILLS = (1, 2), (4, 5), (7, 8)
TEXT = range(10, 20)

draw_timing = {CENTER_OUT: (0, 45), LEFT_OUT: (12, 57), RIGHT_OUT: (12, 57), HANDS: (25, 85)}
leaf_timing = {CENTER_FILLS: (55, [37.95, 27.26]), LEFT_FILLS: (65, [29.51, 37.4]), RIGHT_FILLS: (65, [46.24, 37.4])}

outline_strokes = [
    group(f"trace_{idx}", [sh(sp) for sp in shapes[idx][0]] + [trim(*draw_timing[idx]), stroke(STROKE_COLOR, 0.5)])
    for idx in (CENTER_OUT, LEFT_OUT, RIGHT_OUT, HANDS)
]

outline_fills = [
    group(f"outline_fill_{idx}", [sh(sp) for sp in shapes[idx][0]] + [
        fill(shapes[idx][1], anim([(draw_timing[idx][1] - 10, 0), (draw_timing[idx][1] + 10, 100)]))
    ])
    for idx in (CENTER_OUT, LEFT_OUT, RIGHT_OUT, HANDS)
]

leaf_fills = [
    group(
        f"leaf_{pair[0]}",
        [group(f"half_{idx}", [sh(sp) for sp in shapes[idx][0]] + [fill(shapes[idx][1])]) for idx in pair],
        transform(p=base, a=base, s=anim([(t0, [0, 0]), (t0 + 25, [100, 100])], OVERSHOOT)),
    )
    for pair, (t0, base) in leaf_timing.items()
]

text_group = group(
    "text",
    [group(f"glyph_{idx}", [sh(sp) for sp in shapes[idx][0]] + [fill(shapes[idx][1])]) for idx in TEXT],
    transform(
        p=anim([(85, [0, 5]), (110, [0, 0])]),
        o=anim([(85, 0), (110, 100)]),
    ),
)

logo_layer = {
    "ddd": 0, "ind": 2, "ty": 4, "nm": "logo", "sr": 1,
    "ks": {
        "o": static(100), "r": static(0),
        "p": static(LOGO_POS + [0]), "a": static([0, 0, 0]),
        "s": static([LOGO_SCALE, LOGO_SCALE, 100]),
    },
    "ao": 0,
    "shapes": outline_strokes + outline_fills + leaf_fills + [text_group],
    "ip": 0, "op": TOTAL, "st": 0, "bm": 0,
}

DOT_COLORS = ["#12F4A9", "#18AA95", "#147484"]
DOT_Y = 228
REST, UP = DOT_Y, DOT_Y - 12


def dot(n):
    x = 76 + n * 24
    off = n * 10
    pos_keys = [(0, [x, REST])]
    scale_keys = [(0, [100, 100])]
    for p in range(TOTAL // 60):
        b = 60 * p + off
        pos_keys += [(b, [x, REST]), (b + 15, [x, UP]), (b + 30, [x, REST])]
        scale_keys += [(b, [100, 100]), (b + 15, [125, 125]), (b + 30, [100, 100])]
    pos_keys.append((TOTAL, [x, REST]))
    scale_keys.append((TOTAL, [100, 100]))
    return group(
        f"dot_{n}",
        [{"ty": "el", "p": static([0, 0]), "s": static([11, 11])}, fill(DOT_COLORS[n])],
        transform(p=anim(pos_keys, EASE_IO), s=anim(scale_keys, EASE_IO)),
    )


dots_layer = {
    "ddd": 0, "ind": 1, "ty": 4, "nm": "dots", "sr": 1,
    "ks": {
        "o": anim([(95, 0), (115, 100)]), "r": static(0),
        "p": static([0, 0, 0]), "a": static([0, 0, 0]), "s": static([100, 100, 100]),
    },
    "ao": 0,
    "shapes": [dot(n) for n in range(3)],
    "ip": 0, "op": TOTAL, "st": 0, "bm": 0,
}

lottie = {
    "v": "5.7.4", "fr": FPS, "ip": 0, "op": TOTAL, "w": W, "h": H,
    "nm": "plant_match_loader", "ddd": 0, "assets": [],
    "markers": [{"tm": 0, "cm": "intro", "dr": 120}, {"tm": 120, "cm": "loop", "dr": 120}],
    "layers": [dots_layer, logo_layer],
}

with open(OUT, "w") as f:
    json.dump(lottie, f, separators=(",", ":"))
print("ok", len(shapes), "paths")
