
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '1ap_math_curriculum.dart';
import '1ap_math_assessment.dart';

bool _isAp1Math(String level, String subject) {
  final l = level.toLowerCase().replaceAll(' ', '');
  final s = subject.toLowerCase();

  final firstPrimary = l == '1ap' ||
      l.contains('1ap') ||
      l.contains('الأولى ابتدائي') ||
      l.contains('السنة الأولى ابتدائي');

  final math = s.contains('math') || s.contains('رياضيات');
  return firstPrimary && math;
}

String nibrasPilotProgressKey(String level, String lessonId) {
  return 'lesson_done_${level}_$lessonId';
}

class ChaptersPage extends StatelessWidget {
  const ChaptersPage({
    super.key,
    required this.level,
    required this.subject,
    required this.locale,
  });

  final String level;
  final String subject;
  final Locale locale;

  String t(String fr, String ar, String en) {
    if (locale.languageCode == 'ar') return ar;
    if (locale.languageCode == 'en') return en;
    return fr;
  }

  @override
  Widget build(BuildContext context) {
    final pilot = _isAp1Math(level, subject);

    final chapters = pilot
        ? nibras1ApMathLessons
            .map((lesson) => lesson.title(locale.languageCode))
            .toList()
        : [
            t('Découvrir les notions', 'اكتشاف المفاهيم', 'Discover the concepts'),
            t('Comprendre et appliquer', 'الفهم والتطبيق', 'Understand and apply'),
            t('S’entraîner et réviser', 'التدرب والمراجعة', 'Practice and review'),
          ];

    return Directionality(
      textDirection: locale.languageCode == 'ar'
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(title: Text(subject)),
        body: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            Text(
              '$level • $subject',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              pilot
                  ? t(
                      'Parcours pilote de mathématiques 1AP : cinq leçons avec cours, exemple, exercice corrigé et résumé.',
                      'مسار تجريبي في رياضيات السنة الأولى: خمسة دروس مع شرح ومثال وتمرين مصحح وملخص.',
                      '1AP mathematics pilot: five lessons with explanations, examples, corrected exercises and summaries.',
                    )
                  : t(
                      'Parcours pédagogique de démonstration. Les contenus seront ajoutés après vérification du programme.',
                      'مسار تعليمي تجريبي. ستُضاف الدروس بعد التحقق من البرنامج.',
                      'Learning path preview. Lessons will be added after curriculum verification.',
                    ),
            ),
            const SizedBox(height: 16),

            // Évaluation générale du parcours 1AP Mathématiques.
            if (pilot)
              Card(
                color: const Color(0xffe7f0ff),
                child: ListTile(
                  leading: const Icon(
                    Icons.quiz_rounded,
                    color: Color(0xff0756c8),
                    size: 30,
                  ),
                  title: Text(
                    t(
                      'Évaluation générale',
                      'التقييم العام',
                      'Final assessment',
                    ),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    t(
                      '10 questions • Résultat immédiat',
                      '10 أسئلة • نتيجة فورية',
                      '10 questions • Instant results',
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OneApMathAssessmentPage(
                          language: locale.languageCode,
                        ),
                      ),
                    );
                  },
                ),
              ),

            const SizedBox(height: 8),
            ...chapters.asMap().entries.map((entry) {
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xffe7f0ff),
                    child: Text(
                      '${entry.key + 1}',
                      style: const TextStyle(
                        color: Color(0xff0756c8),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    entry.value,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(
                    pilot
                        ? t(
                            'Cours • exemple • exercice corrigé',
                            'درس • مثال • تمرين مصحح',
                            'Lesson • example • corrected exercise',
                          )
                        : t(
                            'Leçons en préparation',
                            'الدروس قيد الإعداد',
                            'Lessons being prepared',
                          ),
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LessonPage(
                          level: level,
                          subject: subject,
                          chapter: entry.value,
                          locale: locale,
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class LessonPage extends StatefulWidget {
  const LessonPage({
    super.key,
    required this.level,
    required this.subject,
    required this.chapter,
    required this.locale,
  });

  final String level;
  final String subject;
  final String chapter;
  final Locale locale;

  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  bool completed = false;

  String get legacyProgressKey =>
      'lesson_done_${widget.level}_${widget.subject}_${widget.chapter}';

  String get progressKey {
    final lesson = pilotLesson;
    if (lesson == null) return legacyProgressKey;

    return nibrasPilotProgressKey(widget.level, lesson.id);
  }

  List<String> get legacyProgressKeys {
    final lesson = pilotLesson;
    if (lesson == null) return [legacyProgressKey];

    return [
      for (final language in ['fr', 'ar', 'en'])
        'lesson_done_${widget.level}_${widget.subject}_${lesson.title(language)}',
    ];
  }

  String t(String fr, String ar, String en) {
    if (widget.locale.languageCode == 'ar') return ar;
    if (widget.locale.languageCode == 'en') return en;
    return fr;
  }

  NibrasLessonContent? get pilotLesson {
    if (!_isAp1Math(widget.level, widget.subject)) return null;

    for (final lesson in nibras1ApMathLessons) {
      if (lesson.title(widget.locale.languageCode) == widget.chapter) {
        return lesson;
      }
    }

    return null;
  }

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();

    final savedProgress = prefs.getBool(progressKey);
    bool? legacyProgress;

    if (savedProgress == null) {
      for (final key in legacyProgressKeys) {
        legacyProgress = prefs.getBool(key);
        if (legacyProgress != null) break;
      }

      if (legacyProgress != null) {
        await prefs.setBool(progressKey, legacyProgress);
      }
    }

    if (!mounted) return;

    setState(() {
      completed = savedProgress ?? legacyProgress ?? false;
    });
  }

  Future<void> _toggleProgress(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(progressKey, value);

    if (!mounted) return;

    setState(() {
      completed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final lesson = pilotLesson;

    return Directionality(
      textDirection: widget.locale.languageCode == 'ar'
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(t('Espace leçon', 'فضاء الدرس', 'Lesson space')),
        ),
        body: lesson != null
            ? Column(
                children: [
                  Expanded(
                    child: NibrasLessonPreview(
                      lesson: lesson,
                      languageCode: widget.locale.languageCode,
                    ),
                  ),
                  Card(
                    margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: CheckboxListTile(
                      value: completed,
                      onChanged: (value) =>
                          _toggleProgress(value ?? false),
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(
                        t(
                          'Marquer cette leçon comme terminée',
                          'وضع علامة إتمام الدرس',
                          'Mark this lesson as completed',
                        ),
                      ),
                      subtitle: Text(
                        t(
                          'Progression enregistrée sur cet appareil',
                          'يُحفظ التقدم على هذا الجهاز',
                          'Progress saved on this device',
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : ListView(
                padding: const EdgeInsets.all(18),
                children: [
                  Text(
                    widget.level,
                    style: const TextStyle(
                      color: Color(0xffb27a12),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.subject,
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.chapter,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 18),
                  _section(
                    Icons.flag_rounded,
                    t('Objectif', 'الهدف', 'Objective'),
                    t(
                      'Comprendre les notions de ce chapitre et savoir les réutiliser.',
                      'فهم مفاهيم هذا الفصل والقدرة على استعمالها.',
                      'Understand the chapter concepts and learn how to use them.',
                    ),
                  ),
                  _section(
                    Icons.menu_book_rounded,
                    t('Cours', 'الدرس', 'Lesson'),
                    t(
                      'Le contenu pédagogique détaillé sera intégré ici après validation des références officielles.',
                      'سيُضاف المحتوى التعليمي المفصل هنا بعد التحقق من المراجع الرسمية.',
                      'Detailed learning content will be added here after official references are verified.',
                    ),
                  ),
                  _section(
                    Icons.lightbulb_rounded,
                    t('Exemple guidé', 'مثال تطبيقي', 'Guided example'),
                    t(
                      'Un exemple progressif adapté au niveau sera présenté dans cette partie.',
                      'سيُعرض مثال تدريجي مناسب للمستوى في هذا القسم.',
                      'A step-by-step example adapted to this grade will appear here.',
                    ),
                  ),
                  _section(
                    Icons.quiz_rounded,
                    t('Exercice', 'تمرين', 'Exercise'),
                    t(
                      'Des exercices avec correction expliquée seront ajoutés à cette leçon.',
                      'ستُضاف تمارين مع تصحيح مشروح إلى هذا الدرس.',
                      'Exercises with explained solutions will be added to this lesson.',
                    ),
                  ),
                  const SizedBox(height: 14),
                  Card(
                    child: CheckboxListTile(
                      value: completed,
                      onChanged: (value) =>
                          _toggleProgress(value ?? false),
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(
                        t(
                          'Marquer cette leçon comme terminée',
                          'وضع علامة إتمام الدرس',
                          'Mark this lesson as completed',
                        ),
                      ),
                      subtitle: Text(
                        t(
                          'Progression enregistrée sur cet appareil',
                          'يُحفظ التقدم على هذا الجهاز',
                          'Progress saved on this device',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _section(IconData icon, String title, String body) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: const Color(0xff0756c8)),
                const SizedBox(width: 9),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(body),
          ],
        ),
      ),
    );
  }
}
