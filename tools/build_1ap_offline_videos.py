#!/usr/bin/env python3
"""Build three offline, language-specific 1AP counting videos for the APK."""
from pathlib import Path
import subprocess, shutil
from PIL import Image, ImageDraw, ImageFont

OUT = Path("assets/videos")
OUT.mkdir(parents=True, exist_ok=True)
W, H = 1280, 720
SCENES = {
 "fr": [
  ("MISSION 1", "Apprenons à compter", "Regarde les cristaux et compte avec Nibras."),
  ("1", "Un cristal", "Il y a un cristal."),
  ("2", "Deux cristaux", "Un, deux : il y a deux cristaux."),
  ("3", "Trois cristaux", "Un, deux, trois : trois cristaux."),
  ("4 et 5", "Quatre puis cinq", "Quatre, cinq : nous avons cinq cristaux !"),
 ],
 "ar": [
  ("المهمة 1", "هيا نتعلم العد", "شاهد البلورات وعدّها مع نبراس."),
  ("1", "بلورة واحدة", "لدينا بلورة واحدة."),
  ("2", "بلورتان", "واحد، اثنان: لدينا بلورتان."),
  ("3", "ثلاث بلورات", "واحد، اثنان، ثلاثة: لدينا ثلاث بلورات."),
  ("4 و 5", "أربع ثم خمس", "أربع، خمس: وجدنا خمس بلورات!"),
 ],
 "en": [
  ("MISSION 1", "Let's learn to count", "Watch the crystals and count with Nibras."),
  ("1", "One crystal", "There is one crystal."),
  ("2", "Two crystals", "One, two: there are two crystals."),
  ("3", "Three crystals", "One, two, three: there are three crystals."),
  ("4 and 5", "Four then five", "Four, five: we found five crystals!"),
 ],
}
VOICE = {"fr":"fr", "ar":"ar", "en":"en"}
BG = (7, 29, 80)
GOLD = (255, 214, 107)
WHITE = (255,255,255)

def font(size, arabic=False):
    candidates = ([
      "/usr/share/fonts/truetype/noto/NotoNaskhArabic-Regular.ttf",
      "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf"
    ] if arabic else [
      "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf",
      "/usr/share/fonts/truetype/liberation2/LiberationSans-Bold.ttf"
    ])
    for p in candidates:
        if Path(p).exists():
            return ImageFont.truetype(p, size)
    return ImageFont.load_default()

def make_scene(lang, idx, data):
    top, title, subtitle = data
    im = Image.new("RGB", (W,H), BG)
    d = ImageDraw.Draw(im)
    # Adventure sky and glowing crystal trail
    for x in range(0,W,80):
        d.ellipse((x, 45+(x%3)*28, x+5, 50+(x%3)*28), fill=(90,145,220))
    d.rounded_rectangle((70,55,W-70,H-55), radius=38, outline=(50,130,220), width=5)
    ar = lang == "ar"
    d.text((W//2,125), top, font=font(58,ar), fill=GOLD, anchor="mm", direction="rtl" if ar else None)
    d.text((W//2,250), title, font=font(66,ar), fill=WHITE, anchor="mm", direction="rtl" if ar else None)
    n = min(idx,5)
    for j in range(n):
        cx = W//2 - (n-1)*76 + j*152
        cy = 410
        d.polygon([(cx,cy-65),(cx+48,cy),(cx,cy+65),(cx-48,cy)], fill=(65,205,245), outline=GOLD)
        d.ellipse((cx-13,cy-35,cx+13,cy+35), fill=(220,250,255))
    d.text((W//2,585), subtitle, font=font(30,ar), fill=(225,237,255), anchor="mm", direction="rtl" if ar else None)
    return im

def run(cmd):
    subprocess.run(cmd, check=True, stdout=subprocess.DEVNULL, stderr=subprocess.PIPE)

def main():
    if not shutil.which("ffmpeg") or not shutil.which("espeak-ng"):
        raise SystemExit("ffmpeg and espeak-ng are required to build offline lesson videos")
    for lang, scenes in SCENES.items():
        work = OUT / lang
        work.mkdir(parents=True, exist_ok=True)
        frames=[]
        for i, data in enumerate(scenes):
            p=work / f"scene_{i:02d}.png"
            make_scene(lang, i, data).save(p)
            frames.append(p)
        narration = " ".join(s[2] for s in scenes)
        wav=work/"narration.wav"
        run(["espeak-ng","-v",VOICE[lang],"-s","138","-w",str(wav),narration])
        concat=work/"frames.txt"
        concat.write_text("".join(f"file '{p.resolve()}'\nduration 5\n" for p in frames)+f"file '{frames[-1].resolve()}'\n", encoding="utf-8")
        out=OUT/f"1ap_numbers_{lang}.mp4"
        run(["ffmpeg","-y","-f","concat","-safe","0","-i",str(concat),"-i",str(wav),
             "-vf","fps=30,format=yuv420p","-c:v","libx264","-preset","ultrafast","-crf","25",
             "-c:a","aac","-b:a","96k","-shortest","-movflags","+faststart",str(out)])
        shutil.rmtree(work)
        print(f"Generated {out}")
if __name__ == "__main__":
    main()
