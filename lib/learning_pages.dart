import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '1ap_math_curriculum.dart';
import '1ap_math_assessment.dart';
import '1ap_math_adventure_course.dart';
import 'lesson_pdf_service.dart';

bool _isAp1Math(String level, String subject) {
  final l = level.toLowerCase().replaceAll(' ', '');
  final s = subject.toLowerCase();
  final firstPrimary = l == '1ap' || l.contains('1ap') ||
      l.contains('الأولى ابتدائي') || l.contains('السنة الأولى ابتدائي');
  return firstPrimary && (s.contains('math') || s.contains('رياضيات'));
}

String nibrasPilotProgressKey(String level, String lessonId) =>
    'lesson_done_${level}_$lessonId';

class ChaptersPage extends StatelessWidget {
  const ChaptersPage({super.key, required this.level, required this.subject, required this.locale});
  final String level;
  final String subject;
  final Locale locale;

  String t(String fr, String ar, String en) =>
      locale.languageCode == 'ar' ? ar : locale.languageCode == 'en' ? en : fr;

  @override
  Widget build(BuildContext context) {
    final pilot = _isAp1Math(level, subject);
    final chapters = pilot
        ? nibras1ApMathLessons.map((lesson) => lesson.title(locale.languageCode)).toList()
        : [t('Découvrir les notions', 'اكتشاف المفاهيم', 'Discover the concepts'),
           t('Comprendre et appliquer', 'الفهم والتطبيق', 'Understand and apply'),
           t('S’entraîner et réviser', 'التدرب والمراجعة', 'Practice and review')];
    return Directionality(
      textDirection: locale.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(title: Text(subject)),
        body: ListView(padding: const EdgeInsets.all(18), children: [
          Text('$level • $subject', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(pilot
              ? t('Parcours pilote 1AP : cinq leçons. La première ouvre une aventure complète avec animation interactive, vidéos, quiz et fiche PDF.', 'مسار تجريبي للسنة الأولى: خمسة دروس. يبدأ الدرس الأول بمغامرة تفاعلية وفيديوهات واختبار وورقة PDF.', '1AP pilot: five lessons. The first opens a complete adventure with interactive animation, videos, quiz and PDF sheet.')
              : t('Parcours pédagogique de démonstration. Les contenus seront ajoutés après vérification du programme.', 'مسار تعليمي تجريبي. ستُضاف الدروس بعد التحقق من البرنامج.', 'Learning path preview. Lessons will be added after curriculum verification.')),
          const SizedBox(height: 16),
          if (pilot) Card(
            color: const Color(0xffe7f0ff),
            child: ListTile(
              leading: const Icon(Icons.quiz_rounded, color: Color(0xff0756c8), size: 30),
              title: Text(t('Évaluation générale', 'التقييم العام', 'Final assessment'), style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(t('10 questions • Résultat immédiat', '10 أسئلة • نتيجة فورية', '10 questions • Instant results')),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => OneApMathAssessmentPage(language: locale.languageCode))),
            ),
          ),
          const SizedBox(height: 8),
          ...chapters.asMap().entries.map((entry) {
            final adventure = pilot && entry.key == 0;
            return Card(child: ListTile(
              leading: CircleAvatar(
                backgroundColor: const Color(0xffe7f0ff),
                child: Text((entry.key + 1).toString(), style: const TextStyle(color: Color(0xff0756c8), fontWeight: FontWeight.bold)),
              ),
              title: Text(entry.value, style: const TextStyle(fontWeight: FontWeight.w700)),
              subtitle: Text(adventure
                  ? t('Aventure interactive • vidéos • défis • quiz • PDF', 'مغامرة تفاعلية • فيديوهات • تحديات • اختبار • PDF', 'Interactive adventure • videos • challenges • quiz • PDF')
                  : pilot ? t('Cours • exemple • exercice corrigé', 'درس • مثال • تمرين مصحح', 'Lesson • example • corrected exercise')
                  : t('Leçons en préparation', 'الدروس قيد الإعداد', 'Lessons being prepared')),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => adventure
                  ? OneApNumbersAdventurePage(languageCode: locale.languageCode)
                  : LessonPage(level: level, subject: subject, chapter: entry.value, locale: locale))),
            ));
          }),
        ]),
      ),
    );
  }
}

class LessonPage extends StatefulWidget {
  const LessonPage({super.key, required this.level, required this.subject, required this.chapter, required this.locale});
  final String level, subject, chapter;
  final Locale locale;
  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  bool completed = false, printingPdf = false;
  String get legacyProgressKey => 'lesson_done_${widget.level}_${widget.subject}_${widget.chapter}';
  NibrasLessonContent? get pilotLesson {
    if (!_isAp1Math(widget.level, widget.subject)) return null;
    for (final lesson in nibras1ApMathLessons) {
      if (lesson.title(widget.locale.languageCode) == widget.chapter) return lesson;
    }
    return null;
  }
  String get progressKey => pilotLesson == null ? legacyProgressKey : nibrasPilotProgressKey(widget.level, pilotLesson!.id);
  List<String> get legacyKeys => pilotLesson == null ? [legacyProgressKey] : [
    for (final language in ['fr', 'ar', 'en'])
      'lesson_done_${widget.level}_${widget.subject}_${pilotLesson!.title(language)}',
  ];
  String t(String fr, String ar, String en) =>
      widget.locale.languageCode == 'ar' ? ar : widget.locale.languageCode == 'en' ? en : fr;

  @override
  void initState() { super.initState(); _loadProgress(); }
  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getBool(progressKey);
    bool? legacy;
    if (saved == null) {
      for (final key in legacyKeys) { legacy = prefs.getBool(key); if (legacy != null) break; }
      if (legacy != null) await prefs.setBool(progressKey, legacy);
    }
    if (mounted) setState(() => completed = saved ?? legacy ?? false);
  }
  Future<void> _toggle(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(progressKey, value);
    if (mounted) setState(() => completed = value);
  }
  Future<void> _print(NibrasLessonContent lesson) async {
    final language = widget.locale.languageCode;
    if (language == 'ar') {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('نسخة PDF العربية قيد التحضير.')));
      return;
    }
    if (printingPdf) return;
    setState(() => printingPdf = true);
    try {
      await NibrasLessonPdfService.printLesson(context: context, lesson: lesson, languageCode: language == 'en' ? 'en' : 'fr');
    } finally { if (mounted) setState(() => printingPdf = false); }
  }

  @override
  Widget build(BuildContext context) {
    final lesson = pilotLesson;
    return Directionality(
      textDirection: widget.locale.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(title: Text(t('Espace leçon', 'فضاء الدرس', 'Lesson space'))),
        body: lesson != null ? Column(children: [
          Expanded(child: NibrasLessonPreview(lesson: lesson, languageCode: widget.locale.languageCode)),
          Card(margin: const EdgeInsets.fromLTRB(16, 0, 16, 12), child: ListTile(
            leading: const Icon(Icons.picture_as_pdf_rounded, color: Color(0xff0756c8), size: 30),
            title: Text(t('Imprimer la fiche PDF', 'طباعة ورقة الدرس PDF', 'Print lesson PDF'), style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(t('Fiche A4 • Cours • Exemple • À retenir', 'ورقة A4 • الدرس • مثال • للحفظ', 'A4 sheet • Lesson • Example • Key points')),
            trailing: printingPdf ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.print_rounded),
            onTap: printingPdf ? null : () => _print(lesson),
          )),
          Card(margin: const EdgeInsets.fromLTRB(16, 0, 16, 12), child: CheckboxListTile(
            value: completed, onChanged: (v) => _toggle(v ?? false),
            controlAffinity: ListTileControlAffinity.leading,
            title: Text(t('Marquer cette leçon comme terminée', 'وضع علامة إتمام الدرس', 'Mark this lesson as completed')),
            subtitle: Text(t('Progression enregistrée sur cet appareil', 'يُحفظ التقدم على هذا الجهاز', 'Progress saved on this device')),
          )),
        ]) : ListView(padding: const EdgeInsets.all(18), children: [
          Text(widget.level, style: const TextStyle(color: Color(0xffb27a12), fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(widget.subject, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text(widget.chapter, style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 18),
          _section(Icons.flag_rounded, t('Objectif', 'الهدف', 'Objective'), t('Comprendre les notions de ce chapitre et savoir les réutiliser.', 'فهم مفاهيم هذا الفصل والقدرة على استعمالها.', 'Understand the chapter concepts and learn how to use them.')),
          _section(Icons.menu_book_rounded, t('Cours', 'الدرس', 'Lesson'), t('Le contenu pédagogique détaillé sera intégré après validation des références officielles.', 'سيُضاف المحتوى التعليمي المفصل هنا بعد التحقق من المراجع الرسمية.', 'Detailed learning content will be added here after official references are verified.')),
          _section(Icons.lightbulb_rounded, t('Exemple guidé', 'مثال تطبيقي', 'Guided example'), t('Un exemple progressif adapté au niveau sera présenté dans cette partie.', 'سيُعرض مثال تدريجي مناسب للمستوى في هذا القسم.', 'A step-by-step example adapted to this grade will appear here.')),
          _section(Icons.quiz_rounded, t('Exercice', 'تمرين', 'Exercise'), t('Des exercices avec correction expliquée seront ajoutés à cette leçon.', 'ستُضاف تمارين مع تصحيح مشروح إلى هذا الدرس.', 'Exercises with explained solutions will be added to this lesson.')),
          CheckboxListTile(value: completed, onChanged: (v) => _toggle(v ?? false), title: Text(t('Marquer cette leçon comme terminée', 'وضع علامة إتمام الدرس', 'Mark this lesson as completed'))),
        ]),
      ),
    );
  }
  Widget _section(IconData icon, String title, String body) => Card(
    margin: const EdgeInsets.only(bottom: 12),
    child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [Icon(icon, color: const Color(0xff0756c8)), const SizedBox(width: 9), Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17))]),
      const SizedBox(height: 10), Text(body),
    ])),
  );
}
