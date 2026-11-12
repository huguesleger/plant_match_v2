import json
import math
import re
import sys

FPS = 60
DURATION_S = 6
FRAMES = FPS * DURATION_S
STEP = 4
GLIDE = 6.0
BOB = 4.0
TILT = 4.0
PHASES = [0.0, 0.35, 0.6, 0.85]


def parse_triangles(svg):
    paths = re.findall(r'<path d="M([^"]+)Z" fill="(#[0-9A-Fa-f]{6})"', svg)
    return [
        ([tuple(map(float, p.split())) for p in d.split("L")], color)
        for d, color in paths
    ]


def hex_to_rgba(color):
    return [int(color[i:i + 2], 16) / 255 for i in (1, 3, 5)] + [1]


def shape_group(points, color):
    return {
        "ty": "gr",
        "it": [
            {
                "ty": "sh",
                "ks": {
                    "a": 0,
                    "k": {
                        "c": True,
                        "v": [list(p) for p in points],
                        "i": [[0, 0]] * len(points),
                        "o": [[0, 0]] * len(points),
                    },
                },
            },
            {"ty": "fl", "c": {"a": 0, "k": hex_to_rgba(color)}, "o": {"a": 0, "k": 100}, "r": 1},
            {
                "ty": "tr",
                "p": {"a": 0, "k": [0, 0]},
                "a": {"a": 0, "k": [0, 0]},
                "s": {"a": 0, "k": [100, 100]},
                "r": {"a": 0, "k": 0},
                "o": {"a": 0, "k": 100},
            },
        ],
    }


def keyframes(values):
    frames = list(range(0, FRAMES + 1, STEP))
    return {
        "a": 1,
        "k": [
            {
                "t": t,
                "s": values(t),
                "i": {"x": [1], "y": [1]},
                "o": {"x": [0], "y": [0]},
            }
            for t in frames
        ],
    }


def plane_layer(index, triangles):
    nose = triangles[0][0][0]
    points = [p for tri, _ in triangles for p in tri]
    center = (
        sum(p[0] for p in points) / len(points),
        sum(p[1] for p in points) / len(points),
    )
    length = math.dist(nose, center)
    heading = ((nose[0] - center[0]) / length, (nose[1] - center[1]) / length)
    normal = (-heading[1], heading[0])
    phase = PHASES[index] * 2 * math.pi

    def angle(t):
        return 2 * math.pi * t / FRAMES + phase

    def position(t):
        glide = GLIDE * math.sin(angle(t))
        bob = BOB * math.sin(2 * angle(t))
        return [
            round(center[0] + heading[0] * glide + normal[0] * bob, 2),
            round(center[1] + heading[1] * glide + normal[1] * bob, 2),
        ]

    def rotation(t):
        return [round(TILT * math.cos(2 * angle(t)), 2)]

    return {
        "ddd": 0,
        "ind": index + 1,
        "ty": 4,
        "nm": f"plane_{index + 1}",
        "sr": 1,
        "ks": {
            "o": {"a": 0, "k": 100},
            "r": keyframes(rotation),
            "p": keyframes(position),
            "a": {"a": 0, "k": [center[0], center[1], 0]},
            "s": {"a": 0, "k": [100, 100, 100]},
        },
        "ao": 0,
        "shapes": [shape_group(tri, color) for tri, color in reversed(triangles)],
        "ip": 0,
        "op": FRAMES,
        "st": 0,
        "bm": 0,
    }


def main(svg_path, out_path):
    svg = open(svg_path).read()
    width, height = (int(v) for v in re.search(r'viewBox="0 0 (\d+) (\d+)"', svg).groups())
    triangles = parse_triangles(svg)
    planes = [triangles[i:i + 3] for i in range(0, len(triangles), 3)]
    lottie = {
        "v": "5.7.4",
        "fr": FPS,
        "ip": 0,
        "op": FRAMES,
        "w": width,
        "h": height,
        "nm": "paper_planes",
        "ddd": 0,
        "assets": [],
        "layers": [plane_layer(i, plane) for i, plane in enumerate(planes)],
    }
    with open(out_path, "w") as f:
        json.dump(lottie, f, separators=(",", ":"))


if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2])
