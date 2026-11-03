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
  int quantity = 0, index = 0, score = 0, attempts = 0, bestScore = 0, spatialPosition = 0;
  int? choice;
  bool checked = false, finished = false, printing = false;
  yt.YoutubePlayerController? youtube;
  String get lang => widget.languageCode.toLowerCase().startsWith('ar') ? 'ar' : widget.languageCode.toLowerCase().startsWith('en') ? 'en' : 'fr';
  bool get rtl => lang == 'ar';
  String tr(String fr, String ar, String en) => rtl ? ar : lang == 'en' ? en : fr;
  String get progressKey => 'nibras_mastery_v1_' + widget.lesson.id;
  String get attemptsKey => 'nibras_attempts_v1_' + widget.lesson.id;
  int get target => widget.lesson.id == '1ap-math-zero' ? 0 : widget.lesson.id == '1ap-math-nombres-6-9' ? 8 : widget.lesson.id == '1ap-math-nombre-10' ? 10 : widget.lesson.id == '1ap-math-espace' ? 3 : 5;
  int get quantityLimit => widget.lesson.id == '1ap-math-nombres-1-5' ? 5 : widget.lesson.id == '1ap-math-nombres-6-9' ? 9 : 10;

  @override
  void initState() {
    super.initState();
    if (widget.lesson.id == '1ap-math-zero') quantity = 3;
    final id = widget.lesson.youtubeVideoId;
    if (id != null) youtube = yt.YoutubePlayerController.fromVideoId(videoId: id, autoPlay: false,
      params: const yt.YoutubePlayerParams(showFullscreenButton: true, showControls: true, strictRelatedVideos: true));
    _load();
  }
  @override
  void dispose() { youtube?.close(); super.dispose(); }
  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    if (mounted) setState(() { attempts = p.getInt(attemptsKey) ?? 0; bestScore = p.getInt(progressKey) ?? 0; });
  }

  List<_Q> get qs {
    final id = widget.lesson.id;
    if (id == '1ap-math-espace') return [
      _Q(tr('Le livre est posé sur la table. Où est-il ?', 'الكتاب فوق الطاولة. أين يوجد؟', 'The book is on the table. Where is it?'), [tr('Sous','تحت','Under'),tr('Sur','فوق','On'),tr('Dans','داخل','Inside')], 1, tr('Le livre touche le dessus de la table : il est SUR la table.', 'الكتاب فوق سطح الطاولة: هو فوق الطاولة.', 'The book rests on the top of the table: it is ON the table.')),
      _Q(tr('Le ballon est sous la chaise. Où est-il ?', 'الكرة تحت الكرسي. أين هي؟', 'The ball is under the chair. Where is it?'), [tr('Devant','أمام','In front'),tr('Sous','تحت','Under'),tr('Sur','فوق','On')], 1, tr('Le ballon est plus bas que la chaise : il est SOUS la chaise.', 'الكرة أسفل الكرسي: هي تحت الكرسي.', 'The ball is lower than the chair: it is UNDER the chair.')),
      _Q(tr('Quel est le contraire de « devant » ?', 'ما عكس كلمة «أمام»؟', 'What is the opposite of “in front”?'), [tr('Derrière','خلف','Behind'),tr('Près','قريب','Near'),tr('Sur','فوق','On')], 0, tr('Devant et derrière indiquent deux positions opposées.', 'أمام وخلف يدلان على موقعين متعاكسين.', 'In front and behind describe opposite positions.')),
      _Q(tr('Le jouet est dans la boîte. Est-il dedans ou dehors ?', 'اللعبة داخل الصندوق. هل هي داخله أم خارجه؟', 'The toy is in the box. Is it inside or outside?'), [tr('Dehors','خارج','Outside'),tr('Dedans','داخل','Inside'),tr('Loin','بعيد','Far')], 1, tr('Le jouet se trouve à l’intérieur de la boîte : dedans.', 'اللعبة داخل الصندوق: داخل.', 'The toy is inside the box.')),
      _Q(tr('La maison est près de l’école. Est-elle loin ?', 'المنزل قريب من المدرسة. هل هو بعيد؟', 'The house is near the school. Is it far?'), [tr('Oui','نعم','Yes'),tr('Non, elle est près','لا، هي قريبة','No, it is near'),tr('Dessous','تحت','Under')], 1, tr('Près signifie à une petite distance.', 'قريب يعني على مسافة قصيرة.', 'Near means a short distance away.')),
      _Q(tr('Un oiseau vole au-dessus de l’arbre. Où est-il ?', 'طائر يطير فوق الشجرة. أين هو؟', 'A bird flies above the tree. Where is it?'), [tr('Au-dessus','فوق','Above'),tr('En dessous','أسفل','Below'),tr('Dedans','داخل','Inside')], 0, tr('Au-dessus signifie plus haut que l’arbre.', 'فوق تعني أعلى من الشجرة.', 'Above means higher than the tree.')),
      _Q(tr('Le sac est derrière la porte. Où chercher le sac ?', 'الحقيبة خلف الباب. أين نبحث عنها؟', 'The bag is behind the door. Where should you look?'), [tr('Devant la porte','أمام الباب','In front of the door'),tr('Derrière la porte','خلف الباب','Behind the door'),tr('Sur la porte','فوق الباب','On the door')], 1, tr('Derrière signifie de l’autre côté, à l’arrière.', 'خلف تعني في الجهة الخلفية.', 'Behind means at the back of the door.')),
      _Q(tr('Le crayon est entre deux livres. Combien de livres l’encadrent ?', 'القلم بين كتابين. كم كتاباً يحيط به؟', 'The pencil is between two books. How many books are beside it?'), ['1','2','3'], 1, tr('Entre deux objets signifie qu’un objet se trouve au milieu de deux autres.', 'بين شيئين يعني أن الشيء يوجد في الوسط بينهما.', 'Between two objects means one object is in the middle of the two.')),
    ];
    if (id == '1ap-math-zero') return [
      _Q(tr('Une boîte vide contient combien de cubes ?', 'كم مكعباً في علبة فارغة؟', 'How many cubes are in an empty box?'), ['0','1','2'], 0, tr('Vide signifie aucun objet : zéro.', 'فارغة تعني لا شيء: صفر.', 'Empty means no objects: zero.')),
      _Q(tr('Quel symbole représente zéro ?', 'ما الرمز الذي يمثل الصفر؟', 'Which symbol represents zero?'), ['6','0','9'], 1, tr('Le symbole du zéro est 0.', 'رمز الصفر هو 0.', 'The symbol for zero is 0.')),
      _Q(tr('Tu as 2 billes et tu les donnes toutes. Combien reste-t-il ?', 'لديك كرتان وأعطيتهما كلتيهما. كم بقي؟', 'You have 2 marbles and give both away. How many remain?'), ['1','0','2'], 1, tr('Les deux billes sont parties : il n’en reste aucune, donc 0.', 'غادرت الكرتان ولم تبق أي واحدة: النتيجة 0.', 'Both marbles are gone, so none remain: 0.')),
      _Q(tr('Quel groupe contient zéro étoile ?', 'أي مجموعة لا تحتوي على أي نجمة؟', 'Which group has zero stars?'), ['★★','—','★'], 1, tr('Le tiret représente ici une collection vide.', 'الشرطة هنا تمثل مجموعة فارغة.', 'The dash represents an empty group here.')),
      _Q(tr('Que devient 0 si on ajoute un objet ?', 'ماذا يصبح 0 إذا أضفنا عنصراً؟', 'What does 0 become when one object is added?'), ['0','1','2'], 1, tr('Un objet ajouté à rien donne une quantité de 1.', 'إضافة عنصر واحد إلى لا شيء تعطينا 1.', 'One object added to none makes 1.')),
      _Q(tr('Quel nombre signifie « aucun » ?', 'أي عدد يعني «لا شيء»؟', 'Which number means “none”?'), ['3','0','5'], 1, tr('Zéro signifie aucun.', 'الصفر يعني لا شيء.', 'Zero means none.')),
    ];
    if (id == '1ap-math-nombres-6-9') return [
      _Q(tr('Quel nombre vient après 6 ?', 'ما العدد الذي يأتي بعد 6؟', 'Which number comes after 6?'), ['5','7','8'], 1, tr('Après 6 vient 7.', 'بعد 6 يأتي 7.', '7 comes after 6.')),
      _Q(tr('Compte les étoiles : ★ ★ ★ ★ ★ ★ ★ ★', 'عد النجوم: ★ ★ ★ ★ ★ ★ ★ ★', 'Count the stars: ★ ★ ★ ★ ★ ★ ★ ★'), ['7','8','9'], 1, tr('Il y a huit étoiles. Chaque étoile est comptée une fois.', 'هناك ثماني نجمات. نعد كل نجمة مرة واحدة.', 'There are eight stars. Count each star once.')),
      _Q(tr('Quel nombre se trouve entre 7 et 9 ?', 'ما العدد بين 7 و9؟', 'Which number is between 7 and 9?'), ['6','8','10'], 1, tr('La suite est 7, 8, 9.', 'الترتيب هو 7، 8، 9.', 'The sequence is 7, 8, 9.')),
      _Q(tr('Quel nombre est le plus grand ?', 'أي عدد هو الأكبر؟', 'Which number is greatest?'), ['6','9','7'], 1, tr('9 vient après 6 et 7 : il est plus grand.', '9 يأتي بعد 6 و7، لذلك هو الأكبر.', '9 comes after 6 and 7, so it is greater.')),
      _Q(tr('Complète : 6, 7, __, 9.', 'أكمل: 6، 7، __، 9.', 'Complete: 6, 7, __, 9.'), ['8','5','10'], 0, tr('Le nombre manquant est 8.', 'العدد الناقص هو 8.', 'The missing number is 8.')),
      _Q(tr('Combien manque-t-il à 8 pour faire 9 ?', 'كم نضيف إلى 8 لنحصل على 9؟', 'How many more than 8 make 9?'), ['2','1','3'], 1, tr('8 et encore 1 font 9.', '8 ومعه 1 يساوي 9.', '8 and 1 more make 9.')),
      _Q(tr('Quel groupe contient 6 objets ?', 'أي مجموعة فيها 6 عناصر؟', 'Which group has 6 objects?'), ['●●●●●','●●●●●●','●●●●'], 1, tr('Compte les six points sans en oublier.', 'عد النقاط الست دون نسيان أي واحدة.', 'Count all six dots.')),
      _Q(tr('Quel nombre vient juste avant 9 ?', 'ما العدد الذي يسبق 9 مباشرة؟', 'Which number comes just before 9?'), ['8','7','6'], 0, tr('8 vient juste avant 9.', '8 يسبق 9 مباشرة.', '8 comes just before 9.')),
    ];
    if (id == '1ap-math-nombre-10') return [
      _Q(tr('Quel nombre vient après 9 ?', 'ما العدد الذي يأتي بعد 9؟', 'Which number comes after 9?'), ['8','10','11'], 1, tr('10 vient après 9.', 'يأتي 10 بعد 9.', '10 comes after 9.')),
      _Q(tr('9 + combien = 10 ?', '9 + كم = 10؟', '9 + how many = 10?'), ['1','2','0'], 0, tr('9 et encore 1 font 10.', '9 ومعه 1 يساوي 10.', '9 and 1 more make 10.')),
      _Q(tr('Compte les points : ● ● ● ● ● ● ● ● ● ●', 'عد النقاط: ● ● ● ● ● ● ● ● ● ●', 'Count the dots: ● ● ● ● ● ● ● ● ● ●'), ['9','10','8'], 1, tr('Il y a dix points.', 'هناك عشر نقاط.', 'There are ten dots.')),
      _Q(tr('Quel nombre est composé de deux chiffres et désigne dix ?', 'أي عدد يتكون من رقمين ويمثل عشرة؟', 'Which two-digit number represents ten?'), ['1','10','9'], 1, tr('Dix s’écrit 10 : le chiffre 1 puis le chiffre 0.', 'نكتب عشرة 10: الرقم 1 ثم الرقم 0.', 'Ten is written 10: digit 1 followed by digit 0.')),
      _Q(tr('Complète : 7, 8, 9, __.', 'أكمل: 7، 8، 9، __.', 'Complete: 7, 8, 9, __.'), ['10','6','8'], 0, tr('Après 9 vient 10.', 'بعد 9 يأتي 10.', '10 follows 9.')),
      _Q(tr('Deux groupes de cinq objets font combien ?', 'مجموعتان من خمسة عناصر تساويان كم؟', 'Two groups of five objects make how many?'), ['9','10','8'], 1, tr('5 et 5 font 10.', '5 و5 تساوي 10.', '5 and 5 make 10.')),
      _Q(tr('Combien manque-t-il à 9 pour arriver à 10 ?', 'كم ينقص 9 ليصل إلى 10؟', 'How many more does 9 need to reach 10?'), ['1','2','3'], 0, tr('Il manque un seul objet.', 'ينقص عنصر واحد فقط.', 'One more is needed.')),
      _Q(tr('Quel groupe contient exactement dix objets ?', 'أي مجموعة تحتوي على عشرة عناصر بالضبط؟', 'Which group contains exactly ten objects?'), ['●●●●●●●●●','●●●●●●●●●●','●●●●●●●●'], 1, tr('Le deuxième groupe contient dix points.', 'المجموعة الثانية تحتوي على عشر نقاط.', 'The second group has ten dots.')),
    ];
    return [
      _Q(tr('Compte les objets : ● ● ●', 'عد العناصر: ● ● ●', 'Count the objects: ● ● ●'), ['2','3','4'], 1, tr('Pointe chaque objet une seule fois : il y en a 3.', 'أشر إلى كل عنصر مرة واحدة: عددها 3.', 'Point to each object once: there are 3.')),
      _Q(tr('Quel nombre vient après 4 ?', 'ما العدد الذي يأتي بعد 4؟', 'Which number comes after 4?'), ['3','5','6'], 1, tr('La suite est 1, 2, 3, 4, 5.', 'الترتيب هو 1، 2، 3، 4، 5.', 'The sequence is 1, 2, 3, 4, 5.')),
      _Q(tr('2 objets et 2 autres font combien ?', 'عنصران وعنصران آخران يساويان كم؟', '2 objects and 2 more make how many?'), ['3','4','5'], 1, tr('2 + 2 = 4.', '2 + 2 = 4.', '2 + 2 = 4.')),
      _Q(tr('Quel groupe contient 5 objets ?', 'أي مجموعة فيها 5 عناصر؟', 'Which group has 5 objects?'), ['●●●','●●●●●','●●'], 1, tr('Compte les cinq objets.', 'عد العناصر الخمسة.', 'Count all five objects.')),
      _Q(tr('Quel nombre vient juste avant 3 ?', 'ما العدد الذي يسبق 3 مباشرة؟', 'Which number comes just before 3?'), ['2','4','5'], 0, tr('2 vient avant 3.', '2 يأتي قبل 3.', '2 comes before 3.')),
      _Q(tr('Combien font 1 et encore 3 ?', 'كم يساوي 1 وثلاثة أخرى؟', 'How many are 1 and 3 more?'), ['3','4','5'], 1, tr('1 + 3 = 4.', '1 + 3 = 4.', '1 + 3 = 4.')),
      _Q(tr('Quel groupe est le plus grand : 2 objets ou 4 objets ?', 'أي مجموعة أكبر: عنصران أم أربعة؟', 'Which group is larger: 2 objects or 4 objects?'), [tr('2 objets','عنصران','2 objects'),tr('4 objets','أربعة عناصر','4 objects'),tr('Même quantité','نفس الكمية','Same amount')], 1, tr('Quatre est plus grand que deux.', 'أربعة أكبر من اثنين.', 'Four is greater than two.')),
      _Q(tr('Combien faut-il ajouter à 3 pour obtenir 5 ?', 'كم نضيف إلى 3 لنحصل على 5؟', 'How many must be added to 3 to make 5?'), ['1','2','3'], 1, tr('3 puis 4 puis 5 : il faut ajouter 2.', '3 ثم 4 ثم 5: نضيف 2.', '3, then 4, then 5: add 2.')),
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
    if (mounted) setState(() => bestScore = score > old ? score : old);
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
        _section(tr('4. À toi d’essayer','4. جرّب بنفسك','4. Try it yourself'), _practicePrompt, Icons.edit_note),
        _lab(),
        if (youtube != null) Card(clipBehavior: Clip.antiAlias, child: Column(children: [
          ListTile(title: Text(tr('Vidéo pédagogique complémentaire','فيديو تعليمي تكميلي','Supplementary lesson video'))),
          AspectRatio(aspectRatio: 16/9, child: yt.YoutubePlayer(controller: youtube!)),
          Padding(padding: const EdgeInsets.all(12), child: Text(tr('Internet requis pour la vidéo. Le cours et les exercices restent disponibles hors ligne.', 'يتطلب الفيديو الإنترنت. يبقى الدرس والتمارين متاحة دون اتصال.', 'Video requires internet. Lessons and exercises remain available offline.'))),
        ])),
        _section(tr('Avant de répondre','قبل الإجابة','Before you answer'), _commonMistake, Icons.warning_amber_rounded),
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

  String get _practicePrompt {
    switch (widget.lesson.id) {
      case '1ap-math-espace':
        return tr('Place un crayon sur ton cahier, puis sous le cahier. Mets ensuite une gomme dans ta trousse et devant la trousse. Décris chaque position avec une phrase complète.', 'ضع قلماً فوق كراسك ثم تحته. ضع ممحاة داخل المقلمة ثم أمامها. صف كل موقع بجملة كاملة.', 'Put a pencil on your notebook, then under it. Put an eraser inside your pencil case, then in front of it. Describe each position in a full sentence.');
      case '1ap-math-zero':
        return tr('Pose 3 petits objets sur la table. Retire-les un par un en comptant à rebours : 3, 2, 1, 0. Montre la table vide et explique pourquoi on écrit 0.', 'ضع 3 أشياء صغيرة على الطاولة. أزلها واحداً تلو الآخر مع العد: 3، 2، 1، 0. أشر إلى الطاولة الفارغة واشرح لماذا نكتب 0.', 'Place 3 small objects on a table. Remove them one by one while counting down: 3, 2, 1, 0. Show the empty table and explain why we write 0.');
      case '1ap-math-nombres-6-9':
        return tr('Rassemble 6 à 9 objets sûrs (bouchons ou crayons). Fais une rangée, compte-les en les touchant une seule fois, puis forme deux groupes et recompte.', 'اجمع من 6 إلى 9 أشياء آمنة. رتبها في صف، وعدها بلمس كل عنصر مرة واحدة، ثم كوّن مجموعتين وأعد العد.', 'Gather 6 to 9 safe objects. Make a row, count by touching each once, then split them into two groups and count again.');
      case '1ap-math-nombre-10':
        return tr('Prends 10 objets. Fais deux rangées de 5. Compte chaque rangée, puis les deux rangées ensemble. Enlève un objet : combien en reste-t-il ?', 'خذ 10 أشياء. كوّن صفين، في كل صف 5. عد كل صف ثم الصفين معاً. أزل شيئاً واحداً: كم بقي؟', 'Take 10 objects. Make two rows of 5. Count each row, then both rows together. Remove one object: how many remain?');
      default:
        return tr('Prends 1 à 5 objets. Fais une collection, compte chaque objet en le touchant une seule fois, puis montre la même quantité avec tes doigts. Recommence avec une autre collection.', 'خذ من 1 إلى 5 أشياء. كوّن مجموعة وعد كل عنصر بلمسه مرة واحدة، ثم مثّل الكمية نفسها بأصابعك. أعد النشاط بمجموعة أخرى.', 'Take 1 to 5 objects. Make a group, count each object by touching it once, then show the same quantity with your fingers. Repeat with a different group.');
    }
  }

  String get _commonMistake {
    switch (widget.lesson.id) {
      case '1ap-math-espace':
        return tr('Ne confonds pas « sur » et « au-dessus » : « sur » indique généralement un contact avec le support. Observe aussi le point de vue avant de dire devant ou derrière.', 'لا تخلط بين «فوق» و«على»: كلمة «على» تدل غالباً على التلامس مع السطح. وانتبه إلى جهة النظر عند استعمال أمام أو خلف.', 'Do not confuse “on” with “above”: “on” usually means touching the support. Also check the viewpoint before using in front or behind.');
      case '1ap-math-zero':
        return tr('Zéro ne signifie pas « un petit objet ». Il signifie qu’il n’y a aucun objet dans la collection.', 'الصفر لا يعني شيئاً صغيراً، بل يعني عدم وجود أي عنصر في المجموعة.', 'Zero does not mean a tiny object. It means there are no objects in the group.');
      case '1ap-math-nombres-6-9':
        return tr('Ne commence pas à recompter une collection déjà comptée sans repère. Déplace chaque objet compté ou sépare-le pour éviter les oublis et les doubles comptages.', 'لا تعدّ المجموعة من جديد دون علامة. انقل كل عنصر تم عده أو افصله لتجنب النسيان والعد مرتين.', 'Do not recount without a marker. Move or separate each counted object to avoid skipping or counting twice.');
      case '1ap-math-nombre-10':
        return tr('10 n’est pas un seul chiffre : il s’écrit avec deux chiffres, 1 puis 0. Dix objets restent dix même s’ils sont rangés autrement.', '10 ليس رقماً واحداً، بل يكتب برقمين: 1 ثم 0. تبقى عشرة أشياء عشرة حتى إذا غيرنا ترتيبها.', '10 is not a single digit: it is written with two digits, 1 then 0. Ten objects remain ten even when rearranged.');
      default:
        return tr('Ne récite pas les nombres trop vite. Touche chaque objet une seule fois et garde le même ordre de comptage.', 'لا تردد الأعداد بسرعة. المس كل عنصر مرة واحدة وحافظ على ترتيب العد.', 'Do not rush through the number names. Touch each object once and keep a consistent counting order.');
    }
  }

  Widget _section(String title, String body, IconData icon) => Card(child: Padding(padding: const EdgeInsets.all(16),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [Icon(icon, color: const Color(0xff1456b8)), const SizedBox(width: 8), Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17)))]),
      const SizedBox(height: 10), Text(body, style: const TextStyle(height: 1.5, fontSize: 15)),
    ])));

  Widget _lab() {
    if (widget.lesson.id == '1ap-math-espace') {
      final labels = [tr('SUR','فوق','ON'), tr('SOUS','تحت','UNDER'), tr('DANS','داخل','INSIDE'), tr('DEVANT','أمام','IN FRONT'), tr('DERRIÈRE','خلف','BEHIND')];
      final descriptions = [
        tr('Le jouet est posé au-dessus de la boîte.', 'اللعبة فوق الصندوق.', 'The toy is on top of the box.'),
        tr('Le jouet est placé plus bas que la boîte.', 'اللعبة أسفل الصندوق.', 'The toy is below the box.'),
        tr('Le jouet est à l’intérieur de la boîte.', 'اللعبة داخل الصندوق.', 'The toy is inside the box.'),
        tr('Le jouet est placé devant la boîte.', 'اللعبة أمام الصندوق.', 'The toy is in front of the box.'),
        tr('Le jouet est caché derrière la boîte.', 'اللعبة خلف الصندوق.', 'The toy is behind the box.'),
      ];
      return Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text(tr('4. Atelier des positions', '4. ورشة تحديد المواقع', '4. Position workshop'), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17)),
        const SizedBox(height: 8),
        Text(tr('Choisis une position et observe la scène. Dis ensuite une phrase complète.', 'اختر موقعاً ولاحظ المشهد، ثم قل جملة كاملة.', 'Choose a position, observe the scene, then say a complete sentence.')),
        const SizedBox(height: 14),
        Container(height: 150, decoration: BoxDecoration(color: const Color(0xffeaf3ff), borderRadius: BorderRadius.circular(16)),
          child: Stack(alignment: Alignment.center, children: [
            Positioned(bottom: 12, child: Container(width: 120, height: 62, alignment: Alignment.center, decoration: BoxDecoration(color: const Color(0xffd99b54), border: Border.all(color: const Color(0xff80501f), width: 3), borderRadius: BorderRadius.circular(8)), child: Text(tr('BOÎTE','صندوق','BOX'), style: const TextStyle(fontWeight: FontWeight.w900, color: Colors.black)))),
            Positioned(
              bottom: spatialPosition == 0 ? 82 : spatialPosition == 1 ? 0 : 18,
              left: spatialPosition == 3 ? 22 : null,
              right: spatialPosition == 4 ? 22 : null,
              child: Text('🧸', style: TextStyle(fontSize: spatialPosition == 2 ? 30 : 36)),
            ),
          ])),
        const SizedBox(height: 10),
        Wrap(spacing: 6, runSpacing: 6, alignment: WrapAlignment.center, children: List.generate(labels.length, (i) => ChoiceChip(label: Text(labels[i]), selected: spatialPosition == i, onSelected: (_) => setState(() => spatialPosition = i)))),
        const SizedBox(height: 8),
        Text(descriptions[spatialPosition], textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w700)),
        Text(tr('Défi oral : remplace « le jouet » par « le ballon », puis répète la phrase.', 'تحدٍّ شفهي: استبدل «اللعبة» بـ«الكرة» ثم أعد الجملة.', 'Speaking challenge: replace “the toy” with “the ball”, then repeat the sentence.'), textAlign: TextAlign.center),
      ])));
    }
    return Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
    Align(alignment: AlignmentDirectional.centerStart, child: Text(tr('4. Laboratoire interactif','4. المختبر التفاعلي','4. Interactive maths lab'), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17))),
    Text(tr('Ajoute ou retire des objets et observe la quantité.', 'أضف العناصر أو احذفها ولاحظ الكمية.', 'Add or remove objects and observe the quantity.')),
    Wrap(alignment: WrapAlignment.center, children: List.generate(quantityLimit, (i) => Padding(padding: const EdgeInsets.all(4), child: Container(width: 34, height: 34, alignment: Alignment.center, decoration: BoxDecoration(shape: BoxShape.circle, color: i < quantity ? const Color(0xffffd45c) : Colors.transparent, border: Border.all(color: const Color(0xff7a8798), width: 1.5)), child: i < quantity ? const Text('●', style: TextStyle(fontSize: 19, color: Color(0xff805000))) : const SizedBox.shrink())))),
    Text('$quantity', style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w900)),
    Text(tr('Chaque cercle représente une unité. Compte les cercles remplis.', 'كل دائرة تمثل وحدة واحدة. عد الدوائر الممتلئة.', 'Each circle represents one unit. Count the filled circles.'), textAlign: TextAlign.center),
    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      IconButton(onPressed: quantity == 0 ? null : () => setState(() => quantity--), icon: const Icon(Icons.remove_circle_outline)),
      FilledButton.icon(onPressed: quantity >= quantityLimit ? null : () => setState(() => quantity++), icon: const Icon(Icons.add), label: Text(tr('Ajouter','أضف','Add'))),
      IconButton(onPressed: () => setState(() => quantity = 0), icon: const Icon(Icons.refresh)),
    ]),
    Text(tr('Défi : construis une collection de $target.', 'التحدي: كوّن مجموعة من $target.', 'Challenge: build a group of $target.')),
    if (quantity == target) Text(tr('Mission réussie !','نجحت المهمة!','Mission accomplished!'), style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
  ])));
  }

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