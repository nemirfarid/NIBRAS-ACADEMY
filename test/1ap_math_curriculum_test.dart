import 'package:flutter_test/flutter_test.dart';
import 'package:nibras_academy/1ap_math_curriculum.dart';

void main() {
  group('1AP maths curriculum', () {
    test('contains five distinct lessons with complete FR/AR/EN content', () {
      expect(nibras1ApMathLessons, hasLength(5));
      expect(nibras1ApMathLessons.map((lesson) => lesson.id).toSet(), hasLength(5));
      for (final lesson in nibras1ApMathLessons) {
        for (final language in ['fr', 'ar', 'en']) {
          expect(lesson.title(language), isNotEmpty);
          expect(lesson.objective(language), isNotEmpty);
          expect(lesson.course(language), isNotEmpty);
          expect(lesson.example(language), isNotEmpty);
          expect(lesson.question(language), isNotEmpty);
          expect(lesson.correction(language), isNotEmpty);
          expect(lesson.remember(language), isNotEmpty);
        }
      }
    });

    test('uses Western digits only in all three language versions', () {
      final allText = nibras1ApMathLessons.expand((lesson) => [
        lesson.titleFr, lesson.titleAr, lesson.titleEn,
        lesson.objectiveFr, lesson.objectiveAr, lesson.objectiveEn,
        lesson.courseFr, lesson.courseAr, lesson.courseEn,
        lesson.exampleFr, lesson.exampleAr, lesson.exampleEn,
        lesson.questionFr, lesson.questionAr, lesson.questionEn,
        lesson.correctionFr, lesson.correctionAr, lesson.correctionEn,
        lesson.rememberFr, lesson.rememberAr, lesson.rememberEn,
      ]).join(' ');
      expect(RegExp(r'[٠-٩]').hasMatch(allText), isFalse);
    });
  });
}
