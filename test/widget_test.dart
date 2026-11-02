import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nibras_academy/main.dart';
import 'package:nibras_academy/1ap_math_adventure_course.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('affiche le nom et les trois cycles', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(NibrasApp(prefs: prefs));
    await tester.pumpAndSettle();
    expect(find.text('NIBRAS ACADEMY'), findsOneWidget);
    expect(find.text('École primaire'), findsOneWidget);
    expect(find.text('Collège'), findsOneWidget);
    expect(find.text('Lycée'), findsOneWidget);
  });
}
