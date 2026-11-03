#!/usr/bin/env python3
"""Generate 15 offline 1AP maths lesson videos (5 topics x 3 languages)."""
from pathlib import Path
import subprocess, shutil, asyncio
import edge_tts
from PIL import Image, ImageDraw, ImageFont

OUT = Path("assets/videos")
OUT.mkdir(parents=True, exist_ok=True)
W, H = 1280, 720
VOICE = {"fr":"fr-FR-DeniseNeural", "ar":"ar-DZ-AminaNeural", "en":"en-US-JennyNeural"}
# Each lesson has its own language-specific scenes and narration.
LESSONS = {
 "1ap-math-nombres-1-5": {
  "fr":[("MISSION 1","Les nombres de 1 à 5","Compte les cristaux avec Nibras."),("1","Un objet","Une collection peut contenir un objet."),("2 et 3","Deux puis trois","Pointe chaque objet une seule fois."),("4 et 5","Jusqu'à cinq","Le dernier nombre donne la quantité.")],
  "ar":[("المهمة 1","الأعداد من 1 إلى 5","عد البلورات مع نبراس."),("1","عنصر واحد","قد تحتوي المجموعة على عنصر واحد."),("2 و 3","اثنان ثم ثلاثة","أشر إلى كل عنصر مرة واحدة."),("4 و 5","حتى خمسة","العدد الأخير يبين الكمية كلها.")],
  "en":[("MISSION 1","Numbers from 1 to 5","Count the crystals with Nibras."),("1","One object","A group can contain one object."),("2 and 3","Two then three","Point to each object once."),("4 and 5","Up to five","The last number tells the total.")],
 },
 "1ap-math-espace": {
  "fr":[("MISSION 2","Se repérer dans l'espace","Aide Nibras à retrouver le trésor."),("SUR","Le livre est sur la table","Il touche le dessus de la table."),("SOUS","Le chat est sous la chaise","Il se trouve plus bas que la chaise."),("DEVANT / DERRIÈRE","Observe la position","Compare les objets avant de répondre.")],
  "ar":[("المهمة 2","تحديد الموقع في الفضاء","ساعد نبراس في العثور على الكنز."),("فوق","الكتاب فوق الطاولة","يلامس سطح الطاولة."),("تحت","القطة تحت الكرسي","تقع أسفل الكرسي."),("أمام / خلف","لاحظ الموقع","قارن الأشياء قبل الإجابة.")],
  "en":[("MISSION 2","Position in space","Help Nibras find the treasure."),("ON","The book is on the table","It touches the top of the table."),("UNDER","The cat is under the chair","It is lower than the chair."),("IN FRONT / BEHIND","Look at the position","Compare objects before answering.")],
 },
 "1ap-math-nombres-6-9": {
  "fr":[("MISSION 3","Les nombres de 6 à 9","Continue la collection de cristaux."),("6","Six objets","Après cinq vient six."),("7 et 8","Sept puis huit","Compte sans oublier aucun objet."),("9","Neuf objets","Après huit vient neuf.")],
  "ar":[("المهمة 3","الأعداد من 6 إلى 9","واصل جمع البلورات."),("6","ستة عناصر","بعد خمسة يأتي ستة."),("7 و 8","سبعة ثم ثمانية","عد دون نسيان أي عنصر."),("9","تسعة عناصر","بعد ثمانية يأتي تسعة.")],
  "en":[("MISSION 3","Numbers from 6 to 9","Continue the crystal collection."),("6","Six objects","Six comes after five."),("7 and 8","Seven then eight","Count without missing an object."),("9","Nine objects","Nine comes after eight.")],
 },
 "1ap-math-zero": {
  "fr":[("MISSION 4","Le nombre zéro","Découvre ce que signifie une boîte vide."),("0","Aucun objet","Une boîte vide contient zéro objet."),("COMPARER","Zéro ou un ?","Zéro signifie qu'il n'y a rien."),("À RETENIR","Le symbole 0","Le zéro représente une quantité nulle.")],
  "ar":[("المهمة 4","العدد صفر","اكتشف معنى الصندوق الفارغ."),("0","لا شيء","الصندوق الفارغ يحتوي على صفر من العناصر."),("قارن","صفر أم واحد؟","الصفر يعني عدم وجود أي شيء."),("للتذكر","الرمز 0","يمثل الصفر كمية منعدمة.")],
  "en":[("MISSION 4","The number zero","Discover what an empty box means."),("0","No objects","An empty box contains zero objects."),("COMPARE","Zero or one?","Zero means there is nothing."),("REMEMBER","The symbol 0","Zero represents no quantity.")],
 },
 "1ap-math-nombre-10": {
  "fr":[("MISSION 5","Le nombre 10","Rassemble dix objets pour ouvrir le coffre."),("9","Neuf objets","Compte les neuf premiers objets."),("10","Dix objets","Dix vient juste après neuf."),("À RETENIR","Une dizaine","Une collection de dix objets contient 10 éléments.")],
  "ar":[("المهمة 5","العدد 10","اجمع عشرة عناصر لفتح الصندوق."),("9","تسعة عناصر","عد العناصر التسعة الأولى."),("10","عشرة عناصر","يأتي عشرة مباشرة بعد تسعة."),("للتذكر","عشرة عناصر","تحتوي المجموعة على 10 عناصر.")],
  "en":[("MISSION 5","The number 10","Collect ten objects to open the chest."),("9","Nine objects","Count the first nine objects."),("10","Ten objects","Ten comes just after nine."),("REMEMBER","A group of ten","A group of ten contains 10 objects.")],
 },
}
BG=(7,29,80); GOLD=(255,214,107); WHITE=(255,255,255)
def font(size, arabic=False):
    paths=(["/usr/share/fonts/truetype/noto/NotoNaskhArabic-Regular.ttf","/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf"] if arabic else ["/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf","/usr/share/fonts/truetype/liberation2/LiberationSans-Bold.ttf"])
    for p in paths:
        if Path(p).exists(): return ImageFont.truetype(p,size)
    return ImageFont.load_default()
def scene(lang, lesson_id, idx, data):
    top,title,subtitle=data; ar=lang=="ar"
    im=Image.new("RGB",(W,H),BG); d=ImageDraw.Draw(im)
    for x in range(0,W,80): d.ellipse((x,45+(x%3)*28,x+5,50+(x%3)*28),fill=(90,145,220))
    d.rounded_rectangle((70,55,W-70,H-55),radius=38,outline=(50,130,220),width=5)
    d.text((W//2,125),top,font=font(58,ar),fill=GOLD,anchor="mm",direction="rtl" if ar else None)
    d.text((W//2,260),title,font=font(58,ar),fill=WHITE,anchor="mm",direction="rtl" if ar else None)
    # Lesson-specific visual motifs
    if "espace" in lesson_id:
        d.rectangle((470,420,810,455),fill=(190,130,75)); d.rectangle((500,455,525,540),fill=(190,130,75)); d.rectangle((755,455,780,540),fill=(190,130,75))
        d.ellipse((610,320,670,380),fill=(255,190,90),outline=GOLD,width=5)
    else:
        if "nombres-1-5" in lesson_id: n=[0,1,3,5][idx]
        elif "nombres-6-9" in lesson_id: n=[0,6,8,9][idx]
        elif "zero" in lesson_id: n=[0,0,1,0][idx]
        else: n=[0,9,10,10][idx]
        step=92 if n>5 else 140
        for j in range(n):
            cx=W//2-(min(n,5)-1)*step//2+(j%5)*step
            cy=390+(j//5)*105
            d.polygon([(cx,cy-34),(cx+26,cy),(cx,cy+34),(cx-26,cy)],fill=(65,205,245),outline=GOLD)
            d.ellipse((cx-8,cy-18,cx+8,cy+18),fill=(220,250,255))
    d.text((W//2,590),subtitle,font=font(29,ar),fill=(225,237,255),anchor="mm",direction="rtl" if ar else None)
    return im
def run(cmd): subprocess.run(cmd,check=True,stdout=subprocess.DEVNULL,stderr=subprocess.PIPE)
def main():
    if not shutil.which("ffmpeg"): raise SystemExit("ffmpeg is required")
    count=0
    for lesson_id, translations in LESSONS.items():
      for lang, scenes in translations.items():
        work=OUT/f"work_{lesson_id}_{lang}"; work.mkdir(parents=True,exist_ok=True)
        frames=[]
        for i,data in enumerate(scenes):
          p=work/f"scene_{i:02d}.png"; scene(lang,lesson_id,i,data).save(p); frames.append(p)
        narration=" ".join(s[2] for s in scenes); audio=work/"narration.mp3"
        # Microsoft Edge neural TTS: natural prosody, language-specific pronunciation.
        # Audio is generated during CI and embedded in the MP4, so playback is offline.
        async def make_voice():
          communicator = edge_tts.Communicate(narration, VOICE[lang], rate="+0%", volume="+0%", pitch="+0Hz")
          await communicator.save(str(audio))
        asyncio.run(make_voice())
        concat=work/"frames.txt"
        concat.write_text("".join(f"file '{p.resolve()}'\nduration 6\n" for p in frames)+f"file '{frames[-1].resolve()}'\n",encoding="utf-8")
        out=OUT/f"{lesson_id}_{lang}.mp4"
        run(["ffmpeg","-y","-f","concat","-safe","0","-i",str(concat),"-i",str(audio),"-vf","fps=30,format=yuv420p","-c:v","libx264","-preset","ultrafast","-crf","25","-c:a","aac","-b:a","96k","-af","apad","-t","24","-movflags","+faststart",str(out)])
        shutil.rmtree(work); count+=1; print(f"Generated {out}")
    print(f"Generated {count} localized offline videos")
if __name__=="__main__": main()
