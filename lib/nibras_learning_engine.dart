import 'package:shared_preferences/shared_preferences.dart';

/// Local-first learning engine. All keys are additive; existing progress keys
/// and lesson data are deliberately left untouched.
class NibrasLearningEngine {
  static int nextIntervalDays({
    required int previousIntervalDays,
    required bool mastered,
  }) {
    if (!mastered) return 1;
    if (previousIntervalDays <= 0) return 1;
    if (previousIntervalDays < 3) return 3;
    if (previousIntervalDays < 7) return 7;
    if (previousIntervalDays < 14) return 14;
    return 30;
  }

  static Future<NibrasLearningRecord> recordAssessment({
    required SharedPreferences preferences,
    required String lessonId,
    required int score,
    required int total,
    DateTime? now,
  }) async {
    if (total <= 0 || score < 0 || score > total) {
      throw ArgumentError('Invalid assessment score.');
    }
    final current = now ?? DateTime.now();
    final previousInterval =
        preferences.getInt('nibras_srs_interval_v1_$lessonId') ?? 0;
    final mastered = score / total >= 0.85;
    final interval = nextIntervalDays(
      previousIntervalDays: previousInterval,
      mastered: mastered,
    );
    final due = DateTime(current.year, current.month, current.day)
        .add(Duration(days: interval));
    final earned = score * 10 + (mastered ? 20 : 0);
    final totalXp =
        (preferences.getInt('nibras_xp_total_v1') ?? 0) + earned;

    final today = _dayKey(current);
    final previousDay = preferences.getString('nibras_activity_day_v1');
    var streak = preferences.getInt('nibras_activity_streak_v1') ?? 0;
    if (previousDay != today) {
      final yesterday = _dayKey(current.subtract(const Duration(days: 1)));
      streak = previousDay == yesterday ? streak + 1 : 1;
      await preferences.setString('nibras_activity_day_v1', today);
      await preferences.setInt('nibras_activity_streak_v1', streak);
    }

    await preferences.setInt('nibras_srs_interval_v1_$lessonId', interval);
    await preferences.setString(
      'nibras_srs_due_v1_$lessonId',
      due.toIso8601String(),
    );
    await preferences.setInt('nibras_xp_total_v1', totalXp);
    await preferences.setInt('nibras_xp_last_award_v1_$lessonId', earned);

    return NibrasLearningRecord(
      intervalDays: interval,
      dueDate: due,
      earnedXp: earned,
      totalXp: totalXp,
      streakDays: streak,
      mastered: mastered,
    );
  }

  static String _dayKey(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}

class NibrasLearningRecord {
  const NibrasLearningRecord({
    required this.intervalDays,
    required this.dueDate,
    required this.earnedXp,
    required this.totalXp,
    required this.streakDays,
    required this.mastered,
  });

  final int intervalDays;
  final DateTime dueDate;
  final int earnedXp;
  final int totalXp;
  final int streakDays;
  final bool mastered;
}
