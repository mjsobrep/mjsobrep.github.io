"""Encode the actual browser recordings with captions, for inline PR review."""
from pathlib import Path
import hashlib
import json
import subprocess

root = Path("/workspace/pr-review-evidence")
manifest = json.loads((root / "manifest.json").read_text())
font = "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf"

for name, demo in manifest["demos"].items():
    filters = ["pad=iw:ih+80:0:0:color=black"]
    for index, step in enumerate(demo["steps"]):
        step["caption"] = step["caption"].replace("guide card", "guide link")
        textfile = Path("/tmp/pr-review-captures") / f"{name}-caption-{index}.txt"
        textfile.write_text(step["caption"])
        end = demo["steps"][index + 1]["seconds"] if index + 1 < len(demo["steps"]) else demo["seconds"] + 3
        filters.append(
            f"drawtext=fontfile={font}:textfile={textfile}:fontsize=18:fontcolor=white:"
            f"x=16:y=h-64:enable='between(t,{step['seconds']:.3f},{end:.3f})'"
        )
    provenance = Path("/tmp/pr-review-captures") / f"{name}-provenance.txt"
    provenance.write_text(
        f"PR #{name[2:]} / {demo['commit'][:7]} / Chromium / external embeds blocked; PDF viewer untested"
    )
    filters.append(
        f"drawtext=fontfile={font}:textfile={provenance}:fontsize=14:fontcolor=0xaaaaaa:x=16:y=h-30"
    )
    mp4 = root / name / "demo.mp4"
    subprocess.run([
        "ffmpeg", "-hide_banner", "-loglevel", "error", "-y",
        "-i", str(root / name / "demo.webm"), "-vf", ",".join(filters),
        "-an", "-c:v", "libx264", "-crf", "23", "-preset", "fast",
        "-pix_fmt", "yuv420p", "-movflags", "+faststart", str(mp4),
    ], check=True)
    gif = root / name / "demo.gif"
    subprocess.run([
        "ffmpeg", "-hide_banner", "-loglevel", "error", "-y", "-i", str(mp4),
        "-filter_complex",
        "fps=5,scale=960:-2:flags=lanczos,split[s0][s1];"
        "[s0]palettegen=max_colors=96:stats_mode=diff[p];"
        "[s1][p]paletteuse=dither=bayer:bayer_scale=3",
        "-loop", "0", str(gif),
    ], check=True)
    demo["media"] = []
    for file in [mp4, gif]:
        demo["media"].append({
            "file": str(file.relative_to(root)),
            "bytes": file.stat().st_size,
            "sha256": hashlib.sha256(file.read_bytes()).hexdigest(),
        })
    print(f"{name}: MP4 {mp4.stat().st_size:,} bytes; GIF {gif.stat().st_size:,} bytes", flush=True)

(root / "manifest.json").write_text(json.dumps(manifest, indent=2) + "\n")
