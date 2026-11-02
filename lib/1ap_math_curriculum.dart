
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// Contenus pilotes originaux pour le parcours 1AP – Mathématiques.
/// À confronter au manuel ONPS de l'année scolaire avant publication
/// comme contenu officiel. Ce fichier ne modifie aucune donnée existante.
class NibrasLessonContent {
  const NibrasLessonContent({
    required this.id,
    required this.titleFr,
    required this.titleAr,
    required this.titleEn,
    required this.objectiveFr,
    required this.objectiveAr,
    required this.objectiveEn,
    required this.courseFr,
    required this.courseAr,
    required this.courseEn,
    required this.exampleFr,
    required this.exampleAr,
    required this.exampleEn,
    required this.questionFr,
    required this.questionAr,
    required this.questionEn,
    required this.options,
    required this.correctIndex,
    required this.correctionFr,
    required this.correctionAr,
    required this.correctionEn,
    required this.rememberFr,
    required this.rememberAr,
    required this.rememberEn,
  });

  final String id;
  final String titleFr, titleAr, titleEn;
  final String objectiveFr, objectiveAr, objectiveEn;
  final String courseFr, courseAr, courseEn;
  final String exampleFr, exampleAr, exampleEn;
  final String questionFr, questionAr, questionEn;
  final List<String> options;
  final int correctIndex;
  final String correctionFr, correctionAr, correctionEn;
  final String rememberFr, rememberAr, rememberEn;

  String title(String language) => _pick(language, titleFr, titleAr, titleEn);
  String objective(String language) => _pick(language, objectiveFr, objectiveAr, objectiveEn);
  String course(String language) => _pick(language, courseFr, courseAr, courseEn);
  String example(String language) => _pick(language, exampleFr, exampleAr, exampleEn);
  String question(String language) => _pick(language, questionFr, questionAr, questionEn);
  String correction(String language) => _pick(language, correctionFr, correctionAr, correctionEn);
  String remember(String language) => _pick(language, rememberFr, rememberAr, rememberEn);
}

String _pick(String language, String fr, String ar, String en) {
  if (language == 'ar') return ar;
  if (language == 'en') return en;
  return fr;
}

/// Cinq leçons pilotes originales, non reproduites du manuel scolaire.
const List<NibrasLessonContent> nibras1ApMathLessons = [
  NibrasLessonContent(
    id: '1ap-math-nombres-1-5',
    titleFr: 'Les nombres de 1 à 5',
    titleAr: 'الأعداد من 1 إلى 5',
    titleEn: 'Numbers from 1 to 5',
    objectiveFr: 'Compter une petite collection et associer sa quantité à un nombre de 1 à 5.',
    objectiveAr: 'عد مجموعة صغيرة وربط كميتها بعدد من 1 إلى 5.',
    objectiveEn: 'Count a small group and match its quantity to a number from 1 to 5.',
    courseFr: 'Un nombre indique combien d’objets il y a. Pour compter, montre chaque objet une seule fois. Le dernier nombre prononcé donne la quantité totale.',
    courseAr: 'يدل العدد على كمية الأشياء. عند العد، أشر إلى كل عنصر مرة واحدة. العدد الأخير الذي تنطقه يمثل الكمية كلها.',
    courseEn: 'A number tells how many objects there are. Point to each object once. The last number you say is the total quantity.',
    exampleFr: '🍎 🍎 🍎 : il y a 3 pommes. On associe cette collection au nombre 3.',
    exampleAr: '🍎 🍎 🍎 : لدينا 3 تفاحات. نربط هذه المجموعة بالعدد 3.',
    exampleEn: '🍎 🍎 🍎: there are 3 apples. Match this group with number 3.',
    questionFr: 'Combien de ballons vois-tu ? ⚽ ⚽ ⚽ ⚽',
    questionAr: 'كم كرة ترى؟ ⚽ ⚽ ⚽ ⚽',
    questionEn: 'How many balls can you see? ⚽ ⚽ ⚽ ⚽',
    options: ['2', '3', '4', '5'],
    correctIndex: 2,
    correctionFr: 'Il y a 4 ballons. Compte-les une seule fois : 1, 2, 3, 4.',
    correctionAr: 'هناك 4 كرات. نعدها مرة واحدة: 1، 2، 3، 4.',
    correctionEn: 'There are 4 balls. Count each once: 1, 2, 3, 4.',
    rememberFr: 'À retenir : compte chaque objet une seule fois. Le dernier nombre prononcé représente toute la quantité.',
    rememberAr: 'للتذكر: عد كل عنصر مرة واحدة. العدد الأخير يمثل الكمية كلها.',
    rememberEn: 'Remember: count each object once. The last number represents the whole quantity.',
  ),
  NibrasLessonContent(
    id: '1ap-math-espace',
    titleFr: 'Se repérer dans l’espace',
    titleAr: 'تحديد الموقع في الفضاء',
    titleEn: 'Position in space',
    objectiveFr: 'Décrire la position d’un objet avec des mots simples.',
    objectiveAr: 'وصف موقع شيء باستعمال كلمات بسيطة.',
    objectiveEn: 'Describe an object’s position using simple words.',
    courseFr: 'On peut décrire une position avec : sur / sous, devant / derrière, dedans / dehors, près / loin. Observe bien la scène avant de répondre.',
    courseAr: 'نصف الموقع بكلمات مثل: فوق / تحت، أمام / خلف، داخل / خارج، قريب / بعيد. لاحظ الوضعية جيداً قبل الإجابة.',
    courseEn: 'We describe positions with: on / under, in front / behind, inside / outside, near / far. Observe carefully before answering.',
    exampleFr: 'Si le livre est posé sur la table, le livre est SUR la table.',
    exampleAr: 'إذا كان الكتاب فوق الطاولة، نقول إن الكتاب فوق الطاولة.',
    exampleEn: 'If the book rests on the table, it is ON the table.',
    questionFr: 'Le chat est sous la chaise. Quel mot décrit sa position ?',
    questionAr: 'القط تحت الكرسي. ما الكلمة التي تصف موقعه؟',
    questionEn: 'The cat is under the chair. Which word describes its position?',
    options: ['Sur', 'Sous', 'Devant'],
    correctIndex: 1,
    correctionFr: '« Sous » décrit un objet placé plus bas que l’objet de référence.',
    correctionAr: 'كلمة «تحت» تصف شيئاً يقع أسفل الشيء المرجعي.',
    correctionEn: '“Under” describes an object positioned below the reference object.',
    rememberFr: 'À retenir : sur n’est pas sous ; devant n’est pas derrière. Choisis le mot qui correspond à la position observée.',
    rememberAr: 'للتذكر: فوق عكس تحت، وأمام عكس خلف. اختر الكلمة التي توافق الموقع.',
    rememberEn: 'Remember: on is not under; in front is not behind. Choose the word matching the position.',
  ),
  NibrasLessonContent(
    id: '1ap-math-nombres-6-9',
    titleFr: 'Les nombres de 6 à 9',
    titleAr: 'الأعداد من 6 إلى 9',
    titleEn: 'Numbers from 6 to 9',
    objectiveFr: 'Dénombrer une collection et associer sa quantité aux nombres de 6 à 9.',
    objectiveAr: 'عد مجموعة وربط كميتها بالأعداد من 6 إلى 9.',
    objectiveEn: 'Count a group and match its quantity to numbers 6 to 9.',
    courseFr: 'Après 5 viennent 6, 7, 8 et 9. Pour ne rien oublier, pointe chaque objet au moment où tu prononces le nombre.',
    courseAr: 'بعد 5 تأتي 6 و7 و8 و9. حتى لا تنسى أي عنصر، أشر إليه عند نطق العدد.',
    courseEn: 'After 5 come 6, 7, 8 and 9. Point to each object as you say its number.',
    exampleFr: '⭐ ⭐ ⭐ ⭐ ⭐ ⭐ ⭐ : cette collection contient 7 étoiles.',
    exampleAr: '⭐ ⭐ ⭐ ⭐ ⭐ ⭐ ⭐ : تحتوي هذه المجموعة على 7 نجوم.',
    exampleEn: '⭐ ⭐ ⭐ ⭐ ⭐ ⭐ ⭐: this group contains 7 stars.',
    questionFr: 'Combien de fleurs vois-tu ? 🌼 🌼 🌼 🌼 🌼 🌼 🌼 🌼',
    questionAr: 'كم زهرة ترى؟ 🌼 🌼 🌼 🌼 🌼 🌼 🌼 🌼',
    questionEn: 'How many flowers can you see? 🌼 🌼 🌼 🌼 🌼 🌼 🌼 🌼',
    options: ['6', '7', '8', '9'],
    correctIndex: 2,
    correctionFr: 'Il y a 8 fleurs. Compte-les dans l’ordre : 1 à 8.',
    correctionAr: 'هناك 8 زهرات. نعدها بالترتيب من 1 إلى 8.',
    correctionEn: 'There are 8 flowers. Count them in order from 1 to 8.',
    rememberFr: 'À retenir : après 5 viennent 6, 7, 8 et 9. Ne saute aucun objet et ne le compte pas deux fois.',
    rememberAr: 'للتذكر: بعد 5 تأتي 6 و7 و8 و9. لا تتجاوز أي عنصر ولا تعده مرتين.',
    rememberEn: 'Remember: 6, 7, 8 and 9 follow 5. Do not skip or count an object twice.',
  ),
  NibrasLessonContent(
    id: '1ap-math-zero',
    titleFr: 'Le nombre zéro',
    titleAr: 'العدد صفر',
    titleEn: 'The number zero',
    objectiveFr: 'Comprendre que zéro représente une quantité nulle.',
    objectiveAr: 'فهم أن الصفر يمثل كمية منعدمة.',
    objectiveEn: 'Understand that zero represents no objects.',
    courseFr: 'Quand une collection ne contient aucun objet, sa quantité est zéro. Le symbole du zéro est 0.',
    courseAr: 'عندما لا تحتوي المجموعة على أي عنصر، تكون كميتها صفراً. رمز الصفر هو 0.',
    courseEn: 'When a group contains no objects, its quantity is zero. The symbol for zero is 0.',
    exampleFr: 'Une assiette vide ne contient aucune pomme : 0 pomme.',
    exampleAr: 'الصحن الفارغ لا يحتوي على أي تفاحة: 0 تفاحة.',
    exampleEn: 'An empty plate has no apples: 0 apples.',
    questionFr: 'Dans une boîte vide, combien de cubes y a-t-il ?',
    questionAr: 'كم مكعباً يوجد في علبة فارغة؟',
    questionEn: 'How many cubes are in an empty box?',
    options: ['0', '1', '2'],
    correctIndex: 0,
    correctionFr: 'La boîte est vide : il n’y a aucun cube. La quantité est zéro.',
    correctionAr: 'العلبة فارغة: لا يوجد أي مكعب. الكمية تساوي صفراً.',
    correctionEn: 'The box is empty: there are no cubes. The quantity is zero.',
    rememberFr: 'À retenir : 0 signifie « aucun ». Une collection vide contient zéro objet.',
    rememberAr: 'للتذكر: 0 تعني «لا شيء». المجموعة الفارغة تحتوي على صفر من العناصر.',
    rememberEn: 'Remember: 0 means “none”. An empty group contains zero objects.',
  ),
  NibrasLessonContent(
    id: '1ap-math-nombre-10',
    titleFr: 'Le nombre 10',
    titleAr: 'العدد 10',
    titleEn: 'The number 10',
    objectiveFr: 'Reconnaître le nombre 10 et constituer une collection de dix objets.',
    objectiveAr: 'التعرف على العدد 10 وتكوين مجموعة من عشرة عناصر.',
    objectiveEn: 'Recognize 10 and make a group of ten objects.',
    courseFr: 'Après 9 vient 10. Pour vérifier une collection, compte chaque objet une seule fois et dans l’ordre.',
    courseAr: 'يأتي 10 بعد 9. للتحقق من المجموعة، عد كل عنصر مرة واحدة وبالترتيب.',
    courseEn: '10 comes after 9. To check a group, count each object once and in order.',
    exampleFr: '🍊 🍊 🍊 🍊 🍊 🍊 🍊 🍊 🍊 🍊 : dix oranges.',
    exampleAr: '🍊 🍊 🍊 🍊 🍊 🍊 🍊 🍊 🍊 🍊 : عشر برتقالات.',
    exampleEn: '🍊 🍊 🍊 🍊 🍊 🍊 🍊 🍊 🍊 🍊: ten oranges.',
    questionFr: 'Combien de points vois-tu ? ● ● ● ● ● ● ● ● ● ●',
    questionAr: 'كم نقطة ترى؟ ● ● ● ● ● ● ● ● ● ●',
    questionEn: 'How many dots can you see? ● ● ● ● ● ● ● ● ● ●',
    options: ['8', '9', '10'],
    correctIndex: 2,
    correctionFr: 'Il y a 10 points. Le nombre 10 vient juste après 9.',
    correctionAr: 'هناك 10 نقاط. يأتي العدد 10 مباشرة بعد 9.',
    correctionEn: 'There are 10 dots. The number 10 comes just after 9.',
    rememberFr: 'À retenir : 10 vient après 9. Une collection de dix objets contient 10 éléments.',
    rememberAr: 'للتذكر: يأتي 10 بعد 9. مجموعة من عشرة عناصر تحتوي على 10 عناصر.',
    rememberEn: 'Remember: 10 comes after 9. A group of ten objects has 10 items.',
  ),
];

/// Composant de prévisualisation d’une leçon avec exercice corrigé.
class NibrasLessonPreview extends StatefulWidget {
  const NibrasLessonPreview({
    super.key,
    required this.lesson,
    required this.languageCode,
  });

  final NibrasLessonContent lesson;
  final String languageCode;

  @override
  State<NibrasLessonPreview> createState() => _NibrasLessonPreviewState();
}

class _NibrasLessonPreviewState extends State<NibrasLessonPreview> {
  int? selected;
  bool checked = false;
  VideoPlayerController? _videoController;
  bool _videoLoading = true;
  bool _videoFailed = false;
  bool _checkpointShown = false;
  bool _checkpointAnswered = false;
  int? _checkpointChoice;
  String _tutorMode = 'welcome';

  String get _lang {
    final code = widget.languageCode.toLowerCase();
    if (code.startsWith('ar')) return 'ar';
    if (code.startsWith('en')) return 'en';
    return 'fr';
  }

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  @override
  void didUpdateWidget(covariant NibrasLessonPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.lesson.id != widget.lesson.id ||
        oldWidget.languageCode != widget.languageCode) {
      _videoController?.dispose();
      _videoLoading = true;
      _videoFailed = false;
      _initVideo();
    }
  }

  Future<void> _initVideo() async {
    final controller = VideoPlayerController.asset(
      'assets/videos/' + widget.lesson.id + '_' + _lang + '.mp4',
    );
    _videoController = controller;
    try {
      await controller.initialize();
      controller.addListener(_watchInteractiveCheckpoint);
      if (!mounted) return;
      setState(() => _videoLoading = false);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _videoLoading = false;
        _videoFailed = true;
      });
    }
  }

  void _watchInteractiveCheckpoint() {
    final controller = _videoController;
    if (!mounted || controller == null || !controller.value.isInitialized ||
        _checkpointShown || controller.value.duration.inMilliseconds == 0) return;
    final trigger = controller.value.duration.inMilliseconds * 0.55;
    if (controller.value.position.inMilliseconds >= trigger) {
      _checkpointShown = true;
      controller.pause();
      setState(() {});
    }
  }

  Future<void> _resumeAfterCheckpoint() async {
    final controller = _videoController;
    if (controller == null || !_checkpointAnswered) return;
    await controller.play();
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = widget.languageCode;
    final rtl = lang == 'ar';
    final lesson = widget.lesson;
    final labels = lang == 'ar'
        ? ('الهدف', 'الدرس', 'مثال تطبيقي', 'تمرين', 'تحقق', 'للحفظ')
        : lang == 'en'
            ? ('Objective', 'Lesson', 'Guided example', 'Exercise', 'Check', 'Remember')
            : ('Objectif', 'Cours', 'Exemple guidé', 'Exercice', 'Vérifier', 'À retenir par cœur');

    return Directionality(
      textDirection: rtl ? TextDirection.rtl : TextDirection.ltr,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            lesson.title(lang),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          _section(labels.$1, lesson.objective(lang)),
          _section(labels.$2, lesson.course(lang)),
          _section(labels.$3, lesson.example(lang)),
          _videoCard(lang),
          _professorPanel(lang),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    labels.$4,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(lesson.question(lang)),
                  const SizedBox(height: 8),
                  ...List.generate(
                    lesson.options.length,
                    (index) => RadioListTile<int>(
                      value: index,
                      groupValue: selected,
                      onChanged: (value) => setState(() {
                        selected = value;
                        checked = false;
                      }),
                      title: Text(lesson.options[index]),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  FilledButton(
                    onPressed: selected == null
                        ? null
                        : () => setState(() => checked = true),
                    child: Text(labels.$5),
                  ),
                  if (checked) ...[
                    const SizedBox(height: 8),
                    Text(
                      selected == lesson.correctIndex
                          ? (lang == 'ar'
                              ? 'أحسنت! إجابة صحيحة.'
                              : lang == 'en'
                                  ? 'Well done! Correct.'
                                  : 'Bravo ! Bonne réponse.')
                          : (lang == 'ar'
                              ? 'حاول مرة أخرى.'
                              : lang == 'en'
                                  ? 'Try again.'
                                  : 'Essaie encore.'),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: selected == lesson.correctIndex
                            ? Colors.green
                            : Colors.deepOrange,
                      ),
                    ),
                    Text(lesson.correction(lang)),
                  ],
                ],
              ),
            ),
          ),
          _section(labels.$6, lesson.remember(lang)),
        ],
      ),
    );
  }

  Widget _videoCard(String language) {
    final controller = _videoController;
    final title = language == 'ar' ? 'فيديو الدرس باللغة العربية' : language == 'en' ? 'Lesson video in English' : 'Vidéo du cours en français';
    final message = language == 'ar' ? 'فيديو مدمج يعمل دون إنترنت' : language == 'en' ? 'Offline video included in the app' : 'Vidéo intégrée, disponible hors connexion';
    return Card(clipBehavior: Clip.antiAlias, child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Padding(padding: const EdgeInsets.all(14), child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold))),
      AspectRatio(aspectRatio: 16 / 9, child: _videoLoading ? const Center(child: CircularProgressIndicator()) : _videoFailed || controller == null || !controller.value.isInitialized ? Center(child: Padding(padding: const EdgeInsets.all(16), child: Text(language == 'ar' ? 'تعذر تحميل فيديو هذا الدرس.' : language == 'en' ? 'This lesson video could not be loaded.' : 'Impossible de charger la vidéo de cette leçon.', textAlign: TextAlign.center))) : VideoPlayer(controller)),
      if (!_videoLoading && !_videoFailed && controller != null && controller.value.isInitialized) VideoProgressIndicator(controller, allowScrubbing: true, padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
      if (_checkpointShown) _checkpointCard(language),
      if (!_videoLoading && !_videoFailed && controller != null && controller.value.isInitialized) Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        IconButton(tooltip: language == 'ar' ? 'إعادة' : language == 'en' ? 'Restart' : 'Recommencer', onPressed: () async { await controller.seekTo(Duration.zero); await controller.play(); if (mounted) setState(() {}); }, icon: const Icon(Icons.replay)),
        FilledButton.icon(onPressed: _checkpointShown && !_checkpointAnswered ? null : () async { if (controller.value.isPlaying) { await controller.pause(); } else { if (controller.value.position >= controller.value.duration) await controller.seekTo(Duration.zero); await controller.play(); } if (mounted) setState(() {}); }, icon: Icon(controller.value.isPlaying ? Icons.pause : Icons.play_arrow), label: Text(controller.value.isPlaying ? (language == 'ar' ? 'إيقاف مؤقت' : 'Pause') : (language == 'ar' ? 'تشغيل الفيديو' : language == 'en' ? 'Play video' : 'Lire la vidéo'))),
      ]),
      Padding(padding: const EdgeInsets.fromLTRB(14, 0, 14, 14), child: Text(message, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12))),
    ]));
  }

  Widget _checkpointCard(String language) {
    final isAr = language == 'ar';
    final isEn = language == 'en';
    final title = isAr ? 'توقف ذكي: أجب قبل متابعة الفيديو' : isEn ? 'Learning checkpoint: answer to continue' : 'Pause pédagogique : réponds pour continuer';
    final prompt = widget.lesson.question(language);
    final correct = _checkpointChoice == widget.lesson.correctIndex;
    return Card(
      color: const Color(0xfffff5d8),
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17)),
          const SizedBox(height: 8),
          Text(prompt),
          ...List.generate(widget.lesson.options.length, (i) => RadioListTile<int>(
            dense: true, contentPadding: EdgeInsets.zero,
            value: i, groupValue: _checkpointChoice,
            onChanged: _checkpointAnswered ? null : (v) => setState(() => _checkpointChoice = v),
            title: Text(widget.lesson.options[i]),
          )),
          if (_checkpointAnswered)
            Text(correct ? (isAr ? 'أحسنت! إجابة صحيحة.' : isEn ? 'Excellent! Correct answer.' : 'Bravo ! Bonne réponse.')
              : widget.lesson.correction(language),
              style: TextStyle(fontWeight: FontWeight.bold, color: correct ? Colors.green : Colors.deepOrange)),
          const SizedBox(height: 8),
          if (!_checkpointAnswered)
            FilledButton(onPressed: _checkpointChoice == null ? null : () => setState(() => _checkpointAnswered = true),
              child: Text(isAr ? 'تحقق من إجابتي' : isEn ? 'Check my answer' : 'Vérifier ma réponse'))
          else if (correct)
            FilledButton.icon(onPressed: _resumeAfterCheckpoint, icon: const Icon(Icons.play_arrow),
              label: Text(isAr ? 'متابعة الفيديو' : isEn ? 'Continue video' : 'Reprendre la vidéo'))
          else
            OutlinedButton(onPressed: () => setState(() { _checkpointChoice = null; _checkpointAnswered = false; }),
              child: Text(isAr ? 'حاول مرة أخرى' : isEn ? 'Try again' : 'Réessayer')),
        ]),
      ),
    );
  }

  Widget _professorPanel(String language) {
    final isAr = language == 'ar';
    final isEn = language == 'en';
    final heading = isAr ? 'الأستاذ نبراس' : isEn ? 'Professor Nibras' : 'Professeur Nibras';
    final intro = isAr ? 'أنا هنا لمساعدتك. اختر نوع المساعدة.' : isEn ? 'I am here to help. Choose the help you need.' : 'Je suis là pour t’aider. Choisis le type d’aide dont tu as besoin.';
    final responses = isAr
      ? {'welcome': intro, 'hint': 'ابدأ بعدّ كل عنصر مرة واحدة، وأشر إليه بإصبعك.', 'explain': 'العدد الأخير الذي تنطقه بعد عد جميع العناصر مرة واحدة يمثل الكمية الكلية.', 'why': widget.lesson.correction(language)}
      : isEn
      ? {'welcome': intro, 'hint': 'Point to each object once. Do not skip an object or count it twice.', 'explain': 'Say the numbers in order. The last number you say is the total amount.', 'why': widget.lesson.correction(language)}
      : {'welcome': intro, 'hint': 'Pointe chaque objet une seule fois. Ne saute aucun objet et ne le compte pas deux fois.', 'explain': 'Compte dans l’ordre. Le dernier nombre prononcé indique la quantité totale.', 'why': widget.lesson.correction(language)};
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [const Icon(Icons.school, color: Colors.indigo), const SizedBox(width: 8),
            Expanded(child: Text(heading, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            const Chip(label: Text('Hors ligne')),
          ]),
          const SizedBox(height: 6),
          Text(responses[_tutorMode] ?? intro),
          const SizedBox(height: 10),
          Wrap(spacing: 8, runSpacing: 8, children: [
            OutlinedButton.icon(onPressed: () => setState(() => _tutorMode = 'hint'), icon: const Icon(Icons.lightbulb_outline),
              label: Text(isAr ? 'تلميح' : isEn ? 'Hint' : 'Indice')),
            OutlinedButton.icon(onPressed: () => setState(() => _tutorMode = 'explain'), icon: const Icon(Icons.menu_book),
              label: Text(isAr ? 'اشرح بطريقة أخرى' : isEn ? 'Explain another way' : 'Explique autrement')),
            OutlinedButton.icon(onPressed: () => setState(() => _tutorMode = 'why'), icon: const Icon(Icons.question_answer),
              label: Text(isAr ? 'لماذا؟' : isEn ? 'Why?' : 'Pourquoi ?')),
          ]),
          const SizedBox(height: 4),
          Text(isAr ? 'مساعدة تربوية مدمجة تعمل دون إنترنت.' : isEn ? 'Built-in guided learning help works offline.' : 'Aide pédagogique guidée intégrée, disponible hors connexion.',
            style: TextStyle(fontSize: 11, color: Colors.grey.shade700)),
        ]),
      ),
    );
  }

  Widget _section(String title, String body) => Card(
        margin: const EdgeInsets.only(bottom: 10),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(body, style: const TextStyle(height: 1.45)),
            ],
          ),
        ),
      );
}
