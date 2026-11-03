
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OneApMathAssessmentPage extends StatefulWidget {
  final String language;

  const OneApMathAssessmentPage({
    super.key,
    this.language = 'fr',
  });

  @override
  State<OneApMathAssessmentPage> createState() =>
      _OneApMathAssessmentPageState();
}

class _OneApMathAssessmentPageState
    extends State<OneApMathAssessmentPage> {
  int currentQuestion = 0;
  int score = 0;
  int? selectedAnswer;
  bool answered = false;
  bool finished = false;
  bool saving = false;
  int bestScore = 0;
  int attempts = 0;

  final List<_MathQuestion> questions = [
    _MathQuestion(
      fr: 'Combien font 2 + 3 ?',
      ar: 'كم يساوي 2 + 3 ؟',
      en: 'What is 2 + 3?',
      answers: ['4', '5', '6'],
      correct: 1,
    ),
    _MathQuestion(
      fr: 'Quel nombre vient après 7 ?',
      ar: 'ما هو العدد الذي يأتي بعد 7؟',
      en: 'Which number comes after 7?',
      answers: ['6', '8', '9'],
      correct: 1,
    ),
    _MathQuestion(
      fr: 'Une boîte vide contient combien de cubes ?',
      ar: 'كم مكعباً في علبة فارغة؟',
      en: 'How many cubes are in an empty box?',
      answers: ['0', '1', '2'],
      correct: 0,
    ),
    _MathQuestion(
      fr: 'Quel est le plus grand nombre ?',
      ar: 'ما هو العدد الأكبر؟',
      en: 'Which is the largest number?',
      answers: ['3', '9', '5'],
      correct: 1,
    ),
    _MathQuestion(
      fr: 'Combien de côtés a un triangle ?',
      ar: 'كم ضلعاً للمثلث؟',
      en: 'How many sides does a triangle have?',
      answers: ['2', '3', '4'],
      correct: 1,
    ),
    _MathQuestion(
      fr: 'Combien font 9 + 1 ?',
      ar: 'كم يساوي 4 + 4 ؟',
      en: 'What is 4 + 4?',
      answers: ['7', '8', '9'],
      correct: 1,
    ),
    _MathQuestion(
      fr: 'Quel nombre est le plus petit ?',
      ar: 'ما هو العدد الأصغر؟',
      en: 'Which number is the smallest?',
      answers: ['6', '2', '8'],
      correct: 1,
    ),
    _MathQuestion(
      fr: 'Combien font 10 - 5 ?',
      ar: 'كم يساوي 10 - 5 ؟',
      en: 'What is 10 - 5?',
      answers: ['4', '5', '6'],
      correct: 1,
    ),
    _MathQuestion(
      fr: 'Combien de côtés a un carré ?',
      ar: 'كم ضلعاً للمربع؟',
      en: 'How many sides does a square have?',
      answers: ['3', '4', '5'],
      correct: 1,
    ),
    _MathQuestion(
      fr: 'Quel nombre complète : 5, 6, 7, ... ?',
      ar: 'ما العدد الذي يكمل: 5، 6، 7، ...؟',
      en: 'Complete the sequence: 5, 6, 7, ...?',
      answers: ['8', '9', '10'],
      correct: 0,
    ),
  ];

  String get lang {
    final value = widget.language.toLowerCase();
    if (value.startsWith('ar')) return 'ar';
    if (value.startsWith('en')) return 'en';
    return 'fr';
  }

  String tr(String fr, String ar, String en) {
    if (lang == 'ar') return ar;
    if (lang == 'en') return en;
    return fr;
  }

  String questionText(_MathQuestion question) {
    if (lang == 'ar') return question.ar;
    if (lang == 'en') return question.en;
    return question.fr;
  }

  Future<void> loadResults() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;

    setState(() {
      bestScore = prefs.getInt('nibras_1ap_math_best_score') ?? 0;
      attempts = prefs.getInt('nibras_1ap_math_attempts') ?? 0;
    });
  }

  Future<void> saveResult() async {
    if (saving) return;

    setState(() {
      saving = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final previousBest =
          prefs.getInt('nibras_1ap_math_best_score') ?? 0;
      final previousAttempts =
          prefs.getInt('nibras_1ap_math_attempts') ?? 0;

      final newBest = score > previousBest ? score : previousBest;

      await prefs.setInt('nibras_1ap_math_best_score', newBest);
      await prefs.setInt(
        'nibras_1ap_math_attempts',
        previousAttempts + 1,
      );
      await prefs.setInt('nibras_1ap_math_last_score', score);
      await prefs.setString(
        'nibras_1ap_math_last_date',
        DateTime.now().toIso8601String(),
      );

      if (!mounted) return;

      setState(() {
        bestScore = newBest;
        attempts = previousAttempts + 1;
        saving = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        saving = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            tr(
              'Impossible d’enregistrer le résultat.',
              'تعذر حفظ النتيجة.',
              'Could not save the result.',
            ),
          ),
        ),
      );
    }
  }

  void checkAnswer() {
    if (selectedAnswer == null || answered) return;

    setState(() {
      answered = true;
      if (selectedAnswer == questions[currentQuestion].correct) {
        score++;
      }
    });
  }

  Future<void> nextQuestion() async {
    if (currentQuestion < questions.length - 1) {
      setState(() {
        currentQuestion++;
        selectedAnswer = null;
        answered = false;
      });
    } else {
      setState(() {
        finished = true;
      });
      await saveResult();
    }
  }

  void restart() {
    setState(() {
      currentQuestion = 0;
      score = 0;
      selectedAnswer = null;
      answered = false;
      finished = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadResults();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          lang == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F6FC),
        appBar: AppBar(
          title: Text(
            tr(
              'Évaluation de mathématiques',
              'تقييم الرياضيات',
              'Math Assessment',
            ),
          ),
          centerTitle: true,
          backgroundColor: const Color(0xFF3157C8),
          foregroundColor: Colors.white,
        ),
        body: SafeArea(
          child: finished ? _buildResult() : _buildAssessment(),
        ),
      ),
    );
  }

  Widget _buildAssessment() {
    final question = questions[currentQuestion];

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          tr('1ère année primaire', 'السنة الأولى ابتدائي', 'Grade 1'),
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Color(0xFF3157C8),
          ),
        ),
        const SizedBox(height: 14),
        LinearProgressIndicator(
          value: (currentQuestion + 1) / questions.length,
          minHeight: 9,
          borderRadius: BorderRadius.circular(10),
          backgroundColor: Colors.grey.shade300,
          color: const Color(0xFF3157C8),
        ),
        const SizedBox(height: 12),
        Text(
          tr(
            'Question ${currentQuestion + 1} sur ${questions.length}',
            'السؤال ${currentQuestion + 1} من ${questions.length}',
            'Question ${currentQuestion + 1} of ${questions.length}',
          ),
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 24),
        Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              children: [
                const Icon(
                  Icons.calculate_rounded,
                  size: 48,
                  color: Color(0xFF3157C8),
                ),
                const SizedBox(height: 18),
                Text(
                  questionText(question),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 22),
        ...List.generate(question.answers.length, (index) {
          final isCorrect = index == question.correct;
          final isSelected = selectedAnswer == index;

          Color background = Colors.white;
          Color border = Colors.grey.shade300;

          if (answered && isCorrect) {
            background = Colors.green.shade50;
            border = Colors.green;
          } else if (answered && isSelected && !isCorrect) {
            background = Colors.red.shade50;
            border = Colors.red;
          } else if (isSelected) {
            background = Colors.blue.shade50;
            border = const Color(0xFF3157C8);
          }

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: background,
              border: Border.all(color: border, width: 1.5),
              borderRadius: BorderRadius.circular(14),
            ),
            child: RadioListTile<int>(
              value: index,
              groupValue: selectedAnswer,
              onChanged: answered
                  ? null
                  : (value) {
                      setState(() {
                        selectedAnswer = value;
                      });
                    },
              title: Text(
                question.answers[index],
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
              activeColor: const Color(0xFF3157C8),
            ),
          );
        }),
        if (answered) ...[
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: selectedAnswer == question.correct
                  ? Colors.green.shade50
                  : Colors.orange.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              selectedAnswer == question.correct
                  ? tr(
                      'Bravo ! Bonne réponse.',
                      'أحسنت! إجابة صحيحة.',
                      'Well done! Correct answer.',
                    )
                  : tr(
                      'La bonne réponse est : ${question.answers[question.correct]}',
                      'الإجابة الصحيحة هي: ${question.answers[question.correct]}',
                      'The correct answer is: ${question.answers[question.correct]}',
                    ),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
        const SizedBox(height: 22),
        SizedBox(
          height: 52,
          child: ElevatedButton(
            onPressed: answered
                ? nextQuestion
                : selectedAnswer != null
                    ? checkAnswer
                    : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3157C8),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(
              answered
                  ? tr('Question suivante', 'السؤال التالي', 'Next question')
                  : tr(
                      'Vérifier ma réponse',
                      'تحقق من إجابتي',
                      'Check my answer',
                    ),
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResult() {
    final percentage = score * 10;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.emoji_events_rounded,
              size: 100,
              color: Color(0xFFFFB300),
            ),
            const SizedBox(height: 20),
            Text(
              tr(
                'Évaluation terminée !',
                'انتهى التقييم!',
                'Assessment completed!',
              ),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 25),
            Container(
              width: 190,
              height: 190,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(
                  color: const Color(0xFF3157C8),
                  width: 8,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$score / ${questions.length}',
                    style: const TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3157C8),
                    ),
                  ),
                  Text(
                    '$percentage %',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _resultLine(
                      tr('Meilleur score', 'أفضل نتيجة', 'Best score'),
                      '$bestScore / 10',
                    ),
                    const Divider(),
                    _resultLine(
                      tr('Nombre de tentatives', 'عدد المحاولات', 'Attempts'),
                      '$attempts',
                    ),
                    if (saving)
                      const Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: LinearProgressIndicator(),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              score >= 8
                  ? tr('Excellent travail !', 'عمل ممتاز!', 'Excellent work!')
                  : score >= 5
                      ? tr('Bon travail, continue !', 'عمل جيد، واصل!', 'Good work, keep going!')
                      : tr('Continue à t’entraîner !', 'واصل التدريب!', 'Keep practicing!'),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: restart,
                icon: const Icon(Icons.refresh),
                label: Text(
                  tr('Recommencer', 'إعادة المحاولة', 'Try again'),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3157C8),
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  tr('Retour au cours', 'العودة إلى الدرس', 'Back to lessons'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _resultLine(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text(label)),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _MathQuestion {
  final String fr;
  final String ar;
  final String en;
  final List<String> answers;
  final int correct;

  const _MathQuestion({
    required this.fr,
    required this.ar,
    required this.en,
    required this.answers,
    required this.correct,
  });
}
