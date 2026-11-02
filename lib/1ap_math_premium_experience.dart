import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart' as yt;
import '1ap_math_curriculum.dart';
import 'lesson_pdf_service.dart';

class NibrasPremiumMathLessonPage extends StatefulWidget {
  const NibrasPremiumMathLessonPage({super.key, required this.lesson, required this.languageCode});
  final NibrasLessonContent lesson;
  final String languageCode;
  @override
  State<NibrasPremiumMathLessonPage> createState() => _NibrasPremiumMathLessonPageState();
}

class _NibrasPremiumMathLessonPageState extends State<NibrasPremiumMathLessonPage> {
  int quantity = 0, index = 0, score = 0, attempts = 0;
  int? choice;
  bool checked = false, finished = false, printing = false;
  yt.YoutubePlayerController? youtube;
  String get lang => widget.languageCode.toLowerCase().startsWith('ar') ? 'ar' : widget.languageCode.toLowerCase().startsWith('en') ? 'en' : 'fr';
  bool get rtl => lang == 'ar';
  String tr(String fr, String ar, String en) => rtl ? ar : lang == 'en' ? en : fr;
  String get progressKey => 'nibras_mastery_v1_' + widget.lesson.id;
  String get attemptsKey => 'nibras_attempts_v1_' + widget.lesson.id;
  int get target => widget.lesson.id == '1ap-math-zero' ? 0 : widget.lesson.id == '1ap-math-nombres-6-9' ? 8 : widget.lesson.id == '1ap-math-nombre-10' ? 10 : widget.lesson.id == '1ap-math-espace' ? 3 : 5;

  @override
  void initState() {
    super.initState();
    final id = widget.lesson.youtubeVideoId;
    if (id != null) youtube = yt.YoutubePlayerController.fromVideoId(videoId: id, autoPlay: false,
      params: const yt.YoutubePlayerParams(showFullscreenButton: true, showControls: true, strictRelatedVideos: true));
    _load();
  }
  @override
  void dispose() { youtube?.close(); super.dispose(); }
  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    if (mounted) setState(() => attempts = p.getInt(attemptsKey) ?? 0);
  }

  List<_Q> get qs {
    final id = widget.lesson.id;
    if (id == '1ap-math-espace') return [
      _Q(tr('Le livre est sur la table. Où est-il ?', 'الكتاب فوق الطاولة. أين يوجد؟', 'The book is on the table. Where is it?'), [tr('Sous','تحت','Under'),tr('Sur','فوق','On'),tr('Dans','داخل','Inside')], 1, tr('Sur indique une position au-dessus.', 'فوق تدل على موقع أعلى.', 'On indicates a position above.')),
      _Q(tr('Le ballon est sous la chaise. Où est-il ?', 'الكرة تحت الكرسي. أين هي؟', 'The ball is under the chair. Where is it?'), [tr('Devant','أمام','In front'),tr('Sous','تحت','Under'),tr('Sur','فوق','On')], 1, tr('Sous indique une position plus basse.', 'تحت تدل على موقع أسفل.', 'Under indicates a lower position.')),
      _Q(tr('Le contraire de devant ?', 'ما عكس أمام؟', 'Opposite of in front?'), [tr('Derrière','خلف','Behind'),tr('Près','قريب','Near'),tr('Sur','فوق','On')], 0, tr('Devant et derrière sont opposés.', 'أمام وخلف متعاكسان.', 'In front and behind are opposites.')),
    ];
    if (id == '1ap-math-zero') return [
      _Q(tr('Une boîte vide contient combien ?', 'كم تحتوي علبة فارغة؟', 'How many are in an empty box?'), ['0','1','2'], 0, tr('Vide signifie aucun objet : zéro.', 'فارغة تعني لا شيء: صفر.', 'Empty means no objects: zero.')),
      _Q(tr('Quel symbole représente zéro ?', 'ما رمز الصفر؟', 'Which symbol means zero?'), ['6','0','9'], 1, tr('Le symbole est 0.', 'رمز الصفر هو 0.', 'The symbol is 0.')),
      _Q(tr('2 objets moins 2 objets ?', 'عنصران ناقص عنصرين؟', '2 objects minus 2?'), ['1','0','2'], 1, '2 - 2 = 0.'),
    ];
    if (id == '1ap-math-nombres-6-9') return [
      _Q(tr('Après 6 ?', 'ما بعد 6؟', 'After 6?'), ['5','7','8'], 1, tr('Après 6 vient 7.', 'بعد 6 يأتي 7.', '7 comes after 6.')),
      _Q(tr('Combien ? ★ ★ ★ ★ ★ ★ ★ ★', 'كم؟ ★ ★ ★ ★ ★ ★ ★ ★', 'How many? ★ ★ ★ ★ ★ ★ ★ ★'), ['7','8','9'], 1, tr('Il y a huit étoiles.', 'هناك ثماني نجمات.', 'There are eight stars.')),
      _Q(tr('Entre 7 et 9 ?', 'بين 7 و9؟', 'Between 7 and 9?'), ['6','8','10'], 1, tr('La suite est 7, 8, 9.', 'الترتيب 7، 8، 9.', 'The sequence is 7, 8, 9.')),
    ];
    if (id == '1ap-math-nombre-10') return [
      _Q(tr('Après 9 ?', 'ما بعد 9؟', 'After 9?'), ['8','10','11'], 1, tr('10 vient après 9.', 'يأتي 10 بعد 9.', '10 comes after 9.')),
      _Q(tr('9 + combien = 10 ?', '9 + كم = 10؟', '9 + how many = 10?'), ['1','2','0'], 0, '9 + 1 = 10.'),
      _Q(tr('Combien de points ? ● ● ● ● ● ● ● ● ● ●', 'كم نقطة؟ ● ● ● ● ● ● ● ● ● ●', 'How many dots? ● ● ● ● ● ● ● ● ● ●'), ['9','10','8'], 1, tr('Il y a dix points.', 'هناك عشر نقاط.', 'There are ten dots.')),
    ];
    return [
      _Q(tr('Compte : ● ● ●', 'عد: ● ● ●', 'Count: ● ● ●'), ['2','3','4'], 1, tr('Pointe chaque objet une fois.', 'أشر إلى كل عنصر مرة واحدة.', 'Point to each object once.')),
      _Q(tr('Après 4 ?', 'ما بعد 4؟', 'After 4?'), ['3','5','6'], 1, tr('La suite est 1, 2, 3, 4, 5.', 'الترتيب 1، 2، 3، 4، 5.', 'The sequence is 1, 2, 3, 4, 5.')),
      _Q(tr('2 objets et 2 autres font…', 'عنصران وعنصران آخران…', '2 objects and 2 more make…'), ['3','4','5'], 1, '2 + 2 = 4.'),
      _Q(tr('Quel groupe contient 5 objets ?', 'أي مجموعة فيها 5 عناصر؟', 'Which group has 5 objects?'), ['●●●','●●●●●','●●'], 1, tr('Compte les cinq objets.', 'عد العناصر الخمسة.', 'Count all five objects.')),
    ];
  }

  Future<void> _check() async {
    if (choice == null || checked) return;
    setState(() { checked = true; if (choice == qs[index].answer) score++; });
  }
  Future<void> _next() async {
    if (index < qs.length - 1) { setState(() { index++; choice = null; checked = false; }); return; }
    setState(() => finished = true);
    final p = await SharedPreferences.getInstance();
    final old = p.getInt(progressKey) ?? 0;
    if (score > old) await p.setInt(progressKey, score);
    await p.setInt(attemptsKey, (p.getInt(attemptsKey) ?? 0) + 1);
    if (mounted) setState(() => attempts = p.getInt(attemptsKey) ?? 0);
  }
  void _restart() => setState(() { index = 0; score = 0; choice = null; checked = false; finished = false; });
  Future<void> _print() async {
    if (printing || rtl) return;
    setState(() => printing = true);
    try { await NibrasLessonPdfService.printLesson(context: context, lesson: widget.lesson, languageCode: lang); }
    finally { if (mounted) setState(() => printing = false); }
  }

  @override
  Widget build(BuildContext context) => Directionality(
    textDirection: rtl ? TextDirection.rtl : TextDirection.ltr,
    child: Scaffold(appBar: AppBar(title: Text(widget.lesson.title(lang))),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xff071d50), Color(0xff1264c5), Color(0xff28a0e8)]), borderRadius: BorderRadius.circular(22)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('NIBRAS ADVENTURE • 1AP', style: TextStyle(color: Color(0xffffdc78), fontWeight: FontWeight.w900)),
            const SizedBox(height: 8), Text(widget.lesson.title(lang), style: const TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.w900)),
            Text(tr('Apprends, manipule, entraîne-toi et maîtrise.', 'تعلم وجرّب وتدرب وأتقن.', 'Learn, explore, practise and master.'), style: const TextStyle(color: Colors.white)),
          ])),
        _section(tr('1. Objectif','1. الهدف','1. Objective'), widget.lesson.objective(lang), Icons.flag),
        _section(tr('2. Comprendre','2. افهم','2. Understand'), widget.lesson.course(lang), Icons.lightbulb),
        _section(tr('3. Exemple guidé','3. مثال موجه','3. Guided example'), widget.lesson.example(lang), Icons.auto_awesome),
        _lab(),
        if (youtube != null) Card(clipBehavior: Clip.antiAlias, child: Column(children: [
          ListTile(title: Text(tr('Vidéo pédagogique complémentaire','فيديو تعليمي تكميلي','Supplementary lesson video'))),
          AspectRatio(aspectRatio: 16/9, child: yt.YoutubePlayer(controller: youtube!)),
          Padding(padding: const EdgeInsets.all(12), child: Text(tr('Internet requis pour la vidéo. Le cours et les exercices restent disponibles hors ligne.', 'يتطلب الفيديو الإنترنت. يبقى الدرس والتمارين متاحة دون اتصال.', 'Video requires internet. Lessons and exercises remain available offline.'))),
        ])),
        _quiz(),
        _section(tr('À retenir par cœur','للحفظ','Remember by heart'), widget.lesson.remember(lang), Icons.menu_book),
        Card(child: ListTile(leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
          title: Text(tr('Fiche PDF A4','ورقة PDF A4','A4 PDF sheet')),
          subtitle: Text(rtl ? tr('Mise en page arabe RTL à finaliser.', 'تنسيق PDF العربي قيد التطوير.', 'Arabic RTL PDF layout is still in development.') : tr('Imprimer ou enregistrer','اطبع أو احفظ','Print or save')),
          trailing: printing ? const CircularProgressIndicator() : const Icon(Icons.print), onTap: rtl || printing ? null : _print)),
        FutureBuilder<SharedPreferences>(future: SharedPreferences.getInstance(), builder: (context, snap) {
          final best = snap.data?.getInt(progressKey) ?? 0;
          return Card(child: ListTile(leading: const Icon(Icons.insights, color: Colors.blue),
            title: Text(tr('Progression locale','التقدم المحلي','Local progress')),
            subtitle: Text(tr('Meilleur résultat : $best • Tentatives : $attempts', 'أفضل نتيجة: $best • المحاولات: $attempts', 'Best score: $best • Attempts: $attempts'))));
        }),
      ])));

  Widget _section(String title, String body, IconData icon) => Card(child: Padding(padding: const EdgeInsets.all(16),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [Icon(icon, color: const Color(0xff1456b8)), const SizedBox(width: 8), Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17)))]),
      const SizedBox(height: 10), Text(body, style: const TextStyle(height: 1.5, fontSize: 15)),
    ])));

  Widget _lab() => Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
    Align(alignment: AlignmentDirectional.centerStart, child: Text(tr('4. Laboratoire interactif','4. المختبر التفاعلي','4. Interactive maths lab'), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17))),
    Text(tr('Ajoute ou retire des objets et observe la quantité.', 'أضف العناصر أو احذفها ولاحظ الكمية.', 'Add or remove objects and observe the quantity.')),
    Wrap(alignment: WrapAlignment.center, children: List.generate(quantity, (_) => const Padding(padding: EdgeInsets.all(4), child: Text('🟡', style: TextStyle(fontSize: 26))))),
    Text('$quantity', style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w900)),
    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      IconButton(onPressed: quantity == 0 ? null : () => setState(() => quantity--), icon: const Icon(Icons.remove_circle_outline)),
      FilledButton.icon(onPressed: quantity >= 10 ? null : () => setState(() => quantity++), icon: const Icon(Icons.add), label: Text(tr('Ajouter','أضف','Add'))),
      IconButton(onPressed: () => setState(() => quantity = 0), icon: const Icon(Icons.refresh)),
    ]),
    Text(tr('Défi : construis une collection de $target.', 'التحدي: كوّن مجموعة من $target.', 'Challenge: build a group of $target.')),
    if (quantity == target) Text(tr('Mission réussie !','نجحت المهمة!','Mission accomplished!'), style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
  ])));

  Widget _quiz() {
    final items = qs;
    if (finished) {
      final mastered = score * 100 / items.length >= 85;
      return Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
        Icon(mastered ? Icons.workspace_premium : Icons.school, size: 52, color: mastered ? Colors.amber : Colors.blue),
        Text(tr('Résultat : $score/' + items.length.toString(), 'النتيجة: $score/' + items.length.toString(), 'Result: $score/' + items.length.toString()), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 19)),
        Text(mastered ? tr('Compétence maîtrisée !','أتقنت المهارة!','Skill mastered!') : tr('Révise la correction puis recommence.','راجع التصحيح ثم أعد المحاولة.','Review the explanation and try again.')),
        FilledButton(onPressed: _restart, child: Text(tr('Recommencer','إعادة المحاولة','Try again'))),
      ])));
    }
    final q = items[index];
    return Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text(tr('5. Défi de maîtrise','5. تحدي الإتقان','5. Mastery challenge'), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17)),
      LinearProgressIndicator(value: (index + 1) / items.length),
      Text(tr('Question ' + (index + 1).toString() + '/' + items.length.toString(), 'السؤال ' + (index + 1).toString() + '/' + items.length.toString(), 'Question ' + (index + 1).toString() + '/' + items.length.toString())),
      Text(q.prompt, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
      ...List.generate(q.options.length, (i) => RadioListTile<int>(value: i, groupValue: choice,
        onChanged: checked ? null : (v) => setState(() => choice = v), title: Text(q.options[i]), contentPadding: EdgeInsets.zero)),
      if (checked) Text(q.explanation, style: const TextStyle(fontWeight: FontWeight.w600)),
      FilledButton(onPressed: choice == null ? null : checked ? _next : _check, child: Text(checked ? tr('Continuer','متابعة','Continue') : tr('Vérifier','تحقق','Check'))),
    ])));
  }
}
class _Q {
  const _Q(this.prompt, this.options, this.answer, this.explanation);
  final String prompt;
  final List<String> options;
  final int answer;
  final String explanation;
}