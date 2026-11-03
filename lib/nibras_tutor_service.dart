import 'dart:convert';
import 'package:http/http.dart' as http;

/// The API key stays on the server. Configure the public HTTPS endpoint at
/// build time with --dart-define=NIBRAS_TUTOR_URL=https://your-domain/api/tutor.
class NibrasTutorService {
  NibrasTutorService({http.Client? client}) : _client = client ?? http.Client();
  final http.Client _client;
  static const endpoint = String.fromEnvironment('NIBRAS_TUTOR_URL');

  bool get isConfigured => endpoint.startsWith('https://');

  Future<String?> ask({
    required String question,
    required String language,
    required String lessonTitle,
    required String lessonContext,
  }) async {
    if (!isConfigured) return null;
    try {
      final response = await _client
          .post(Uri.parse(endpoint),
              headers: const {'Content-Type': 'application/json'},
              body: jsonEncode({
                'question': question,
                'language': language,
                'lesson_title': lessonTitle,
                'lesson_context': lessonContext,
              }))
          .timeout(const Duration(seconds: 25));
      if (response.statusCode != 200) return null;
      final data = jsonDecode(response.body);
      if (data is Map && data['answer'] is String) {
        return (data['answer'] as String).trim();
      }
    } catch (_) {
      return null;
    }
    return null;
  }

  void dispose() => _client.close();
}
