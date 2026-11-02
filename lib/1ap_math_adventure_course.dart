import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '1ap_math_curriculum.dart';
import 'lesson_pdf_service.dart';

class OneApNumbersAdventurePage extends StatefulWidget {
  const OneApNumbersAdventurePage({super.key, required this.languageCode});
  final String languageCode;
  @override
  State<OneApNumbersAdventurePage> createState() => _OneApNumbersAdventurePageState();
}

class _OneApNumbersAdventurePageState extends State<OneApNumbersAdventurePage> {
  static const progressKey = 'lesson_done_1AP_1ap-math-nombres-1-5';
  static const bestKey = 'nibras_1ap_numbers_adventure_best';
  int count = 0, stars = 0, qIndex = 0, score = 0, best = 0;
  int? selected, videoChoice;
  bool videoChecked = false;
  late final YoutubePlayerController youtubeController;
  bool answered = false, finished = false, completed = false, printing = false;
  final questions = const [
    ['Combien de soleils ? ☀️ ☀️ ☀️', 'كم شمساً؟ ☀️ ☀️ ☀️', 'How many suns? ☀️ ☀️ ☀️', ['2','3','4'], 1],
    ['Quel nombre vient après 2 ?', 'ما العدد الذي يأتي بعد 2؟', 'Which number comes after 2?', ['1','3','4'], 1],
    ['Quel groupe contient 5 pommes ?', 'أي مجموعة تحتوي على 5 تفاحات؟', 'Which group has 5 apples?', ['🍎🍎🍎','🍎🍎🍎🍎🍎','🍎🍎'], 1],
    ['2 objets et 1 de plus : combien ?', 'شيئان مع عنصر آخر: كم يصبح العدد؟', '2 objects and 1 more: how many?', ['2','3','4'], 1],
    ['Quel chiffre représente quatre objets ?', 'أي رقم يمثل أربعة عناصر؟', 'Which digit represents four objects?', ['3','4','5'], 1],
  ];
  String get lang => widget.languageCode.startsWith('ar') ? 'ar' : widget.languageCode.startsWith('en') ? 'en' : 'fr';
  String t(String fr, String ar, String en) => lang == 'ar' ? ar : lang == 'en' ? en : fr;

  @override
  void initState() {
    super.initState();
    youtubeController = YoutubePlayerController.fromVideoId(
      videoId: 'TyKFiA86YrY',
      autoPlay: false,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        enableCaption: true,
        captionLanguage: 'ar',
        interfaceLanguage: 'ar',
        privacyEnhancedMode: true,
      ),
    );
    _load();
  }

  @override
  void dispose() {
    youtubeController.close();
    super.dispose();
  }
  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() { completed = p.getBool(progressKey) ?? false; best = p.getInt(bestKey) ?? 0; });
  }
  Future<void> _complete() async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(progressKey, true);
    if (mounted) setState(() => completed = true);
  }
  Future<void> _video(String url) async {
    final ok = await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    if (!ok && mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t('Impossible d’ouvrir la vidéo.', 'تعذر فتح الفيديو.', 'Could not open video.'))));
  }
  Future<void> _print() async {
    if (lang == 'ar') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('نسخة PDF العربية قيد التحضير.')),
      );
      return;
    }
    if (printing) return;
    setState(() => printing = true);
    try { await NibrasLessonPdfService.printLesson(context: context, lesson: nibras1ApMathLessons.first, languageCode: lang); }
    finally { if (mounted) setState(() => printing = false); }
  }
  void _check() {
    if (selected == null || answered) return;
    setState(() { answered = true; if (selected == questions[qIndex][4]) { score++; stars++; } });
  }
  Future<void> _next() async {
    if (qIndex < questions.length - 1) { setState(() { qIndex++; selected = null; answered = false; }); return; }
    final p = await SharedPreferences.getInstance();
    best = score > best ? score : best;
    await p.setInt(bestKey, best);
    if (!mounted) return;
    setState(() => finished = true);
    if (score >= 4) await _complete();
  }
  void _restart() => setState(() { qIndex = 0; score = 0; selected = null; answered = false; finished = false; });

  @override
  Widget build(BuildContext context) => Directionality(
    textDirection: lang == 'ar' ? TextDirection.rtl : TextDirection.ltr,
    child: Scaffold(
      backgroundColor: const Color(0xfff3f6ff),
      appBar: AppBar(title: Text(t('Mission 01 • Les nombres de 1 à 5', 'المهمة 01 • الأعداد من 1 إلى 5', 'Mission 01 • Numbers 1 to 5')), actions: [Padding(padding: const EdgeInsets.all(12), child: Center(child: Text('⭐ $stars')))]),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Container(padding: const EdgeInsets.all(22), decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xff071d50), Color(0xff1255ba), Color(0xff268ce0)]), borderRadius: BorderRadius.circular(24)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('NIBRAS ADVENTURE • 1AP', style: const TextStyle(color: Color(0xffffd66b), fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          Text(t('La vallée des cinq cristaux', 'وادي البلورات الخمس', 'The Valley of Five Crystals'), style: const TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          Text(t('Aide le robot Nibras à retrouver cinq cristaux en apprenant à compter.', 'ساعد روبوت نبراس في العثور على خمس بلورات وتعلم العد.', 'Help Nibras find five crystals while learning to count.'), style: const TextStyle(color: Colors.white, height: 1.4)),
          const SizedBox(height: 12),
          LinearProgressIndicator(value: completed ? 1 : finished ? .9 : .3, color: const Color(0xffffd66b)),
        ]),
        _heading(t('1. Objectifs de la mission', '1. أهداف المهمة', '1. Mission goals')),
        _card([_line(Icons.flag, t('Réciter les nombres de 1 à 5.', 'ترتيب الأعداد من 1 إلى 5.', 'Say the numbers from 1 to 5.')), _line(Icons.visibility, t('Associer un chiffre à une quantité.', 'ربط الرقم بالكمية.', 'Match a digit to a quantity.')), _line(Icons.touch_app, t('Compter chaque objet une seule fois.', 'عد كل عنصر مرة واحدة فقط.', 'Count each object once.'))]),
        _heading(t('2. Animation interactive : le coffre', '2. نشاط تفاعلي: الصندوق', '2. Interactive animation: the chest')),
        _card([
          Text(t('Cristaux trouvés : $count / 5', 'البلورات التي وجدتها: $count / 5', 'Crystals found: $count / 5'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Wrap(alignment: WrapAlignment.center, spacing: 8, children: List.generate(5, (i) => AnimatedContainer(duration: const Duration(milliseconds: 250), width: 46, height: 52, decoration: BoxDecoration(color: i < count ? const Color(0xffffedb8) : const Color(0xffedf1f8), borderRadius: BorderRadius.circular(12)), child: Icon(Icons.diamond, color: i < count ? Colors.orange : Colors.blueGrey.shade300)))),
          const SizedBox(height: 10),
          Text(t('Ajoute les cristaux un par un et observe la quantité changer.', 'أضف البلورات واحدة تلو الأخرى ولاحظ تغير الكمية.', 'Add crystals one by one and watch the quantity change.'), textAlign: TextAlign.center),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            OutlinedButton(onPressed: count == 0 ? null : () => setState(() => count--), child: Text(t('Retirer', 'احذف', 'Remove'))),
            const SizedBox(width: 8),
            FilledButton.icon(onPressed: count == 5 ? null : () => setState(() { count++; stars++; }), icon: const Icon(Icons.add), label: Text(t('Ajouter', 'أضف', 'Add'))),
            IconButton(onPressed: () => setState(() => count = 0), icon: const Icon(Icons.refresh)),
          ]),
          if (count == 5) Text(t('Bravo ! Tu as retrouvé les cinq cristaux.', 'أحسنت! وجدت البلورات الخمس.', 'Great! You found all five crystals.'), style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
        ]),
        _heading(t('3. Découverte des nombres', '3. اكتشاف الأعداد', '3. Discover the numbers')),
        ..._numberCards(),
        _card([Text(t('À RETENIR PAR CŒUR', 'للحفظ', 'REMEMBER BY HEART'), style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xff9b6500))), Text(t('1 • 2 • 3 • 4 • 5. Compter, c’est dire combien il y a d’objets. Je pointe chaque objet une seule fois. Le dernier nombre prononcé donne la quantité totale.', '1 • 2 • 3 • 4 • 5. العد هو معرفة عدد العناصر. أشير إلى كل عنصر مرة واحدة. العدد الأخير يمثل الكمية كلها.', '1 • 2 • 3 • 4 • 5. Counting tells how many objects there are. Point to each object once. The last number gives the total quantity.'), style: const TextStyle(height: 1.5))], color: const Color(0xfffff5d8)),
        _heading(t('4. Vidéos YouTube', '4. فيديوهات يوتيوب', '4. YouTube videos')),
        _videoTile('Compter de 1 à 5 • Français', t('Recherche ciblée de vidéos éducatives en français.', 'بحث عن فيديوهات تعليمية بالفرنسية.', 'Search French educational videos.'), 'https://www.youtube.com/results?search_query=apprendre+compter+de+1+a+5+enfants'),
        _embeddedVideo(),
        _heading(t('5. Défi : trois cristaux', '5. تحدي: ثلاث بلورات', '5. Challenge: three crystals')),
        _card([Text(t('Sélectionne exactement 3 cristaux.', 'اختر 3 بلورات بالضبط.', 'Select exactly 3 crystals.')), Wrap(spacing: 8, children: [1,2,3,4,5].map((n) => ChoiceChip(label: Text('$n'), selected: count == n, onSelected: (_) => setState(() => count = n))).toList()), Text(count == 3 ? t('Mission réussie !', 'نجحت المهمة!', 'Challenge complete!') : t('Observe et essaie encore.', 'لاحظ وحاول مرة أخرى.', 'Look carefully and try again.'))]),
        _heading(t('6. Quiz de maîtrise', '6. اختبار الإتقان', '6. Mastery quiz')),
        _quiz(),
        _heading(t('7. Fiche PDF imprimable', '7. ورقة PDF للطباعة', '7. Printable PDF sheet')),
        Card(child: ListTile(leading: const Icon(Icons.picture_as_pdf, color: Colors.red, size: 34), title: Text(t('Imprimer la fiche A4 « À retenir »', 'طباعة ورقة A4 للحفظ', 'Print A4 revision sheet')), subtitle: Text(t('Objectif • cours • exemple • essentiel', 'الهدف • الدرس • المثال • الخلاصة', 'Objective • lesson • example • key points')), trailing: printing ? const CircularProgressIndicator() : const Icon(Icons.print), onTap: printing ? null : _print)),
        _card([Row(children: [Icon(completed ? Icons.verified : Icons.flag, color: completed ? Colors.green : Colors.blue), const SizedBox(width: 8), Expanded(child: Text(completed ? t('Leçon validée !', 'تم إكمال الدرس!', 'Lesson completed!') : t('Valider ma leçon', 'تأكيد إكمال الدرس', 'Mark lesson complete'), style: const TextStyle(fontWeight: FontWeight.bold)))]), const SizedBox(height: 8), Text(t('Progression sauvegardée localement. Quatre bonnes réponses au quiz valident automatiquement la leçon.', 'يتم حفظ التقدم محلياً. أربع إجابات صحيحة في الاختبار تكمل الدرس تلقائياً.', 'Progress is saved locally. Four correct quiz answers complete the lesson automatically.')), OutlinedButton(onPressed: completed ? null : _complete, child: Text(t('J’ai terminé', 'أنهيت', 'I finished')))]),
      ]),
    ),
  );

  Widget _heading(String title) => Padding(padding: const EdgeInsets.only(top: 14, bottom: 8), child: Text(title, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900, color: Color(0xff102a5e))));
  Widget _card(List<Widget> children, {Color color = Colors.white}) => Card(color: color, child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children)));
  Widget _line(IconData icon, String label) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Row(children: [Icon(icon, color: Colors.blue), const SizedBox(width: 8), Expanded(child: Text(label))]));
  List<Widget> _numberCards() {
    const fr = ['Un seul objet.', 'Deux objets.', 'Trois objets.', 'Quatre objets.', 'Cinq objets.'];
    const ar = ['عنصر واحد.', 'عنصران.', 'ثلاثة عناصر.', 'أربعة عناصر.', 'خمسة عناصر.'];
    const en = ['One object.', 'Two objects.', 'Three objects.', 'Four objects.', 'Five objects.'];
    const words = ['UN', 'DEUX', 'TROIS', 'QUATRE', 'CINQ'];
    return List.generate(5, (i) => Card(child: ListTile(leading: CircleAvatar(backgroundColor: const Color(0xffffedbd), child: Text((i + 1).toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20))), title: Text(words[i], style: const TextStyle(fontWeight: FontWeight.bold)), subtitle: Text(lang == 'ar' ? ar[i] : lang == 'en' ? en[i] : fr[i]), trailing: IconButton(onPressed: () => setState(() => count = i + 1), icon: const Icon(Icons.touch_app)))));
  }
  Widget _embeddedVideo() => Card(
    clipBehavior: Clip.antiAlias,
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('تعلم الأرقام من ١ إلى ٥ • Youpi Smart World', style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        YoutubePlayer(controller: youtubeController, aspectRatio: 16 / 9),
        const SizedBox(height: 10),
        Text(t('Vidéo YouTube intégrée. Après le visionnage, réponds au mini-défi.', 'فيديو يوتيوب داخل التطبيق. بعد المشاهدة أجب عن التحدي.', 'Embedded YouTube video. After watching, answer the checkpoint.')),
        const SizedBox(height: 8),
        Text(t('Quel nombre vient juste après 4 ?', 'ما العدد الذي يأتي مباشرة بعد 4؟', 'Which number comes immediately after 4?'), style: const TextStyle(fontWeight: FontWeight.bold)),
        Wrap(spacing: 8, children: [3, 5, 6].map((n) => ChoiceChip(label: Text(n.toString()), selected: videoChoice == n, onSelected: (_) => setState(() { videoChoice = n; videoChecked = false; }))).toList()),
        FilledButton(onPressed: videoChoice == null ? null : () => setState(() => videoChecked = true), child: Text(t('Vérifier', 'تحقق', 'Check'))),
        if (videoChecked) Text(videoChoice == 5 ? t('Bravo ! 5 vient après 4.', 'أحسنت! يأتي 5 بعد 4.', 'Well done! 5 comes after 4.') : t('Réessaie : récite 1, 2, 3, 4, 5.', 'حاول مجدداً: 1، 2، 3، 4، 5.', 'Try again: say 1, 2, 3, 4, 5.'), style: const TextStyle(fontWeight: FontWeight.bold)),
      ]),
    ),
  );

  Widget _videoTile(String title, String subtitle, String url) => Card(child: ListTile(leading: const Icon(Icons.play_circle_fill, size: 34, color: Colors.red), title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)), subtitle: Text(subtitle), trailing: const Icon(Icons.open_in_new), onTap: () => _video(url)));
  Widget _quiz() {
    if (finished) return _card([const Icon(Icons.workspace_premium, size: 52, color: Colors.amber), Text(t('Résultat : $score / 5 • Meilleur : $best / 5', 'النتيجة: $score / 5 • الأفضل: $best / 5', 'Score: $score / 5 • Best: $best / 5'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)), FilledButton(onPressed: _restart, child: Text(t('Rejouer', 'إعادة الاختبار', 'Play again')))]);
    final q = questions[qIndex];
    final prompt = q[lang == 'ar' ? 1 : lang == 'en' ? 2 : 0] as String;
    final options = q[3] as List<String>;
    return _card([Text('Question ' + (qIndex + 1).toString() + ' / 5', style: const TextStyle(fontWeight: FontWeight.bold)), LinearProgressIndicator(value: (qIndex + 1) / questions.length), const SizedBox(height: 10), Text(prompt, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), ...List.generate(options.length, (i) => RadioListTile<int>(value: i, groupValue: selected, onChanged: answered ? null : (v) => setState(() => selected = v), title: Text(options[i]), contentPadding: EdgeInsets.zero)), if (answered) Text(selected == q[4] ? t('Bravo ! Bonne réponse.', 'أحسنت! إجابة صحيحة.', 'Well done! Correct.') : t('Recompte les objets et réessaie.', 'أعد عد العناصر وحاول مجدداً.', 'Count the objects again and retry.')), FilledButton(onPressed: selected == null ? null : answered ? _next : _check, child: Text(answered ? t('Suivant', 'التالي', 'Next') : t('Vérifier', 'تحقق', 'Check')))]);
  }
}
