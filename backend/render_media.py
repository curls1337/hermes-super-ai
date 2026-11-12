#!/usr/bin/env python3
import argparse
import asyncio
import json
import os
import subprocess
import sys
import textwrap
import urllib.parse
import urllib.request
from pathlib import Path

import edge_tts

FFMPEG_BIN = "/home/devcurl/.local/bin/ffmpeg"
if not os.path.exists(FFMPEG_BIN):
    FFMPEG_BIN = "ffmpeg"


async def synth_tts(text: str, voice: str, out_mp3: str):
    comm = edge_tts.Communicate(text, voice)
    await comm.save(out_mp3)


def get_audio_duration(audio_path: str) -> float:
    try:
        out = subprocess.check_output(
            [
                "ffprobe",
                "-v",
                "error",
                "-show_entries",
                "format=duration",
                "-of",
                "default=noprint_wrappers=1:nokey=1",
                audio_path,
            ],
            stderr=subprocess.DEVNULL,
        )
        return max(3.0, float(out.decode().strip()))
    except Exception:
        return 8.0


def render_video_job(job_id: str, title: str, script_text: str, voice: str, out_dir: str):
    os.makedirs(out_dir, exist_ok=True)
    mp3_path = os.path.join(out_dir, f"{job_id}.mp3")
    mp4_path = os.path.join(out_dir, f"{job_id}.mp4")

    clean_script = (script_text or title or "Hermes Super AI Video Studio").strip()
    selected_voice = voice if "Neural" in str(voice) else "id-ID-GadisNeural"

    asyncio.run(synth_tts(clean_script, selected_voice, mp3_path))
    dur = get_audio_duration(mp3_path)

    # Create a clean VisionOS background frame using PIL
    bg_png = os.path.join(out_dir, f"{job_id}_bg.png")
    try:
        from PIL import Image, ImageDraw, ImageFont

        W, H = 720, 1280
        img = Image.new("RGB", (W, H), (10, 15, 30))
        draw = ImageDraw.Draw(img)

        # Subtle VisionOS Graphite Frost vertical gradient
        for y in range(H):
            r = int(10 + 18 * (y / H))
            g = int(16 + 24 * (y / H))
            b = int(32 + 40 * (y / H))
            draw.line([(0, y), (W, y)], fill=(r, g, b))

        # Glowing spatial orb accent
        draw.ellipse([160, 220, 560, 620], outline=(56, 189, 248), width=4)
        draw.ellipse([200, 260, 520, 580], outline=(129, 140, 248), width=2)

        # Glassmorphic card at bottom half
        draw.rounded_rectangle(
            [48, 680, W - 48, 1140],
            radius=32,
            fill=(22, 30, 52),
            outline=(148, 163, 184),
            width=2,
        )

        try:
            font_title = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf", 34)
            font_body = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf", 26)
            font_badge = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf", 20)
        except Exception:
            font_title = ImageFont.load_default()
            font_body = ImageFont.load_default()
            font_badge = ImageFont.load_default()

        draw.text((84, 100), "HERMES SUPER AI  •  VIDEO LAB", fill=(56, 189, 248), font=font_badge)
        wrapped_title = textwrap.wrap(title[:70], width=28)[:2]
        ty = 720
        for line in wrapped_title:
            draw.text((84, ty), line, fill=(248, 250, 252), font=font_title)
            ty += 44

        wrapped_script = textwrap.wrap(clean_script[:260], width=38)[:6]
        sy = ty + 20
        for line in wrapped_script:
            draw.text((84, sy), line, fill=(203, 213, 225), font=font_body)
            sy += 36

        img.save(bg_png)
    except Exception as e:
        print("PIL fallback:", e, file=sys.stderr)
        bg_png = None

    if bg_png and os.path.exists(bg_png):
        cmd = [
            FFMPEG_BIN, "-y",
            "-loop", "1", "-i", bg_png,
            "-i", mp3_path,
            "-filter_complex",
            "[1:a]showwaves=s=600x90:mode=cline:colors=#38bdf8|#818cf8[waves];[0:v][waves]overlay=60:420[outv]",
            "-map", "[outv]", "-map", "1:a",
            "-c:v", "libx264", "-tune", "stillimage", "-pix_fmt", "yuv420p", "-r", "24",
            "-c:a", "aac", "-b:a", "128k",
            "-t", f"{dur:.2f}",
            mp4_path,
        ]
    else:
        cmd = [
            FFMPEG_BIN, "-y",
            "-f", "lavfi", "-i", f"color=c=#0f172a:s=720x1280:d={dur:.2f}",
            "-i", mp3_path,
            "-c:v", "libx264", "-pix_fmt", "yuv420p", "-r", "24",
            "-c:a", "aac", "-shortest",
            mp4_path,
        ]

    subprocess.run(cmd, check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    if bg_png and os.path.exists(bg_png):
        os.remove(bg_png)
    print(json.dumps({"ok": True, "mp4": mp4_path, "mp3": mp3_path, "durationSec": round(dur, 1)}))


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--mode", required=True, choices=["video", "voice"])
    parser.add_argument("--id", required=True)
    parser.add_argument("--title", default="Hermes Super AI")
    parser.add_argument("--text", required=True)
    parser.add_argument("--voice", default="id-ID-GadisNeural")
    parser.add_argument("--out-dir", required=True)
    args = parser.parse_args()

    if args.mode == "video":
        render_video_job(args.id, args.title, args.text, args.voice, args.out_dir)
    else:
        os.makedirs(args.out_dir, exist_ok=True)
        mp3_path = os.path.join(args.out_dir, f"{args.id}.mp3")
        asyncio.run(synth_tts(args.text, args.voice, mp3_path))
        print(json.dumps({"ok": True, "mp3": mp3_path}))


if __name__ == "__main__":
    main()
