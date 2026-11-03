import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nibras_academy/nibras_learning_engine.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('NibrasLearningEngine spaced repetition', () {
    test('uses a short first review and progressively widens intervals', () {
      expect(NibrasLearningEngine.nextIntervalDays(
        previousIntervalDays: 0, mastered: true), 1);
      expect(NibrasLearningEngine.nextIntervalDays(
        previousIntervalDays: 1, mastered: true), 3);
      expect(NibrasLearningEngine.nextIntervalDays(
        previousIntervalDays: 3, mastered: true), 7);
      expect(NibrasLearningEngine.nextIntervalDays(
        previousIntervalDays: 7, mastered: true), 14);
      expect(NibrasLearningEngine.nextIntervalDays(
        previousIntervalDays: 14, mastered: true), 30);
    });

    test('schedules a next-day review when mastery threshold is not met', () {
      expect(NibrasLearningEngine.nextIntervalDays(
        previousIntervalDays: 14, mastered: false), 1);
    });

    test('stores review date, XP and consecutive-day streak locally', () async {
      SharedPreferences.setMockInitialValues({
        'nibras_srs_interval_v1_lesson-a': 1,
        'nibras_activity_day_v1': '2026-11-02',
        'nibras_activity_streak_v1': 2,
      });
      final prefs = await SharedPreferences.getInstance();
      final result = await NibrasLearningEngine.recordAssessment(
        preferences: prefs,
        lessonId: 'lesson-a',
        score: 8,
        total: 8,
        now: DateTime(2026, 11, 3, 10),
      );

      expect(result.intervalDays, 3);
      expect(result.dueDate, DateTime(2026, 11, 6));
      expect(result.earnedXp, 100);
      expect(result.totalXp, 100);
      expect(result.streakDays, 3);
      expect(prefs.getString('nibras_srs_due_v1_lesson-a'),
          DateTime(2026, 11, 6).toIso8601String());
      expect(prefs.getInt('nibras_xp_total_v1'), 100);
    });
  });
}
