import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(NibrasApp(prefs: prefs));
}

class NibrasApp extends StatefulWidget {
  const NibrasApp({super.key, required this.prefs});
  final SharedPreferences prefs;
  @override
  State<NibrasApp> createState() => _NibrasAppState();
}

class _NibrasAppState extends State<NibrasApp> {
  Locale locale = const Locale('fr');
  @override
  void initState() {
    super.initState();
    locale = Locale(widget.prefs.getString('locale') ?? 'fr');
  }
  Future<void> setLanguage(String code) async {
    await widget.prefs.setString('locale', code);
    setState(() => locale = Locale(code));
  }
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'NIBRAS ACADEMY',
    locale: locale,
    supportedLocales: const [Locale('fr'), Locale('ar'), Locale('en')],
    localizationsDelegates: const [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff0756c8)),
      scaffoldBackgroundColor: const Color(0xfff4f7fc),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xff061d55), foregroundColor: Colors.white),
      cardTheme: CardThemeData(
        elevation: 2, color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
    ),
    home: HomePage(locale: locale, onLanguage: setLanguage),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.locale, required this.onLanguage});
  final Locale locale;
  final Future<void> Function(String) onLanguage;
  String t(String fr, String ar, String en) =>
      locale.languageCode == 'ar' ? ar : locale.languageCode == 'en' ? en : fr;

  @override
  Widget build(BuildContext context) {
    final rtl = locale.languageCode == 'ar';
    final cycles = [
      ('primaire', t('École primaire', 'المرحلة الابتدائية', 'Primary school'),
        '1AP – 5AP', Icons.auto_stories_rounded, const Color(0xff0878d1)),
      ('moyen', t('Collège', 'التعليم المتوسط', 'Middle school'),
        '1AM – 4AM', Icons.school_rounded, const Color(0xff7652c8)),
      ('secondaire', t('Lycée', 'التعليم الثانوي', 'High school'),
        t('1AS – 3AS • Toutes filières', '1AS – 3AS • كل الشعب', '1AS – 3AS • All streams'),
        Icons.workspace_premium_rounded, const Color(0xffb27a12)),
    ];
    return Directionality(
      textDirection: rtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('NIBRAS ACADEMY',
            style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: .4)),
          actions: [
            PopupMenuButton<String>(
              onSelected: onLanguage,
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'fr', child: Text('Français')),
                PopupMenuItem(value: 'ar', child: Text('العربية')),
                PopupMenuItem(value: 'en', child: Text('English')),
              ],
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.language_rounded)),
            )
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xff061d55), Color(0xff0756c8), Color(0xff1688e8)]),
                borderRadius: BorderRadius.circular(26)),
              child: Row(children: [
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(t('Bienvenue !', 'مرحباً بك!', 'Welcome!'),
                      style: const TextStyle(color: Colors.white,
                        fontSize: 25, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(t('Apprendre • Réussir • Exceller',
                      'تعلّم • انجح • تميّز', 'Learn • Succeed • Excel'),
                      style: const TextStyle(color: Color(0xffffd36a),
                        fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Text(t('Ton parcours scolaire commence ici.',
                      'مسارك الدراسي يبدأ من هنا.',
                      'Your learning journey starts here.'),
                      style: const TextStyle(color: Colors.white70)),
                  ])),
                const SizedBox(width: 10),
                ClipRRect(borderRadius: BorderRadius.circular(16),
                  child: Image.asset('assets/branding/nibras_launcher.png',
                    width: 88, height: 88, fit: BoxFit.cover)),
              ]),
            ),
            const SizedBox(height: 24),
            Text(t('Choisis ton cycle', 'اختر الطور الدراسي',
              'Choose your school cycle'),
              style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w800,
                color: Color(0xff10264f))),
            const SizedBox(height: 12),
            ...cycles.map((c) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Card(child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => Navigator.push(context, MaterialPageRoute(
                  builder: (_) => LevelsPage(cycle: c.$1, title: c.$2,
                    locale: locale))),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Row(children: [
                    Container(width: 54, height: 54,
                      decoration: BoxDecoration(
                        color: c.$5.withOpacity(.12),
                        borderRadius: BorderRadius.circular(16)),
                      child: Icon(c.$4, color: c.$5, size: 29)),
                    const SizedBox(width: 14),
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(c.$2, style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(c.$3, style: TextStyle(color: Colors.blueGrey.shade600)),
                      ])),
                    const Icon(Icons.chevron_right_rounded,
                      color: Color(0xff0756c8)),
                  ]),
                ),
              )),
            )),
            const SizedBox(height: 10),
            Center(child: Text(t('Une plateforme pour progresser à ton rythme.',
              'منصة للتقدم حسب وتيرتك.',
              'A platform to learn at your own pace.'),
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.blueGrey.shade600))),
            const SizedBox(height: 20),
            const Center(child: Text('Version initiale • 1.0.0',
              style: TextStyle(color: Colors.blueGrey, fontSize: 12))),
          ],
        ),
      ),
    );
  }
}

class LevelsPage extends StatelessWidget {
  const LevelsPage({super.key, required this.cycle, required this.title,
    required this.locale});
  final String cycle, title;
  final Locale locale;
  @override
  Widget build(BuildContext context) {
    final levels = cycle == 'primaire'
      ? ['1AP', '2AP', '3AP', '4AP', '5AP']
      : cycle == 'moyen'
        ? ['1AM', '2AM', '3AM', '4AM'] : ['1AS', '2AS', '3AS'];
    final rtl = locale.languageCode == 'ar';
    return Directionality(
      textDirection: rtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(title: Text(title)),
        body: ListView(padding: const EdgeInsets.all(18), children: [
          Text(rtl ? 'اختر المستوى' :
            locale.languageCode == 'en' ? 'Choose your grade' : 'Choisis ton niveau',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ...levels.map((level) => Card(child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Color(0xffe7f0ff),
              child: Icon(Icons.menu_book_rounded, color: Color(0xff0756c8))),
            title: Text(level, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(rtl ? 'المواد والدروس قريباً' :
              locale.languageCode == 'en' ? 'Subjects and lessons coming next' :
              'Matières et leçons à venir'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => Navigator.push(context, MaterialPageRoute(
              builder: (_) => SubjectsPage(level: level, locale: locale))),
          ))),
        ]),
      ),
    );
  }
}

class SubjectsPage extends StatelessWidget {
  const SubjectsPage({super.key, required this.level, required this.locale});
  final String level;
  final Locale locale;
  @override
  Widget build(BuildContext context) {
    final subjects = locale.languageCode == 'ar'
      ? ['الرياضيات', 'اللغة العربية', 'اللغة الفرنسية', 'اللغة الإنجليزية',
         'العلوم', 'التاريخ والجغرافيا']
      : locale.languageCode == 'en'
        ? ['Mathematics', 'Arabic', 'French', 'English', 'Sciences',
           'History & Geography']
        : ['Mathématiques', 'Arabe', 'Français', 'Anglais', 'Sciences',
           'Histoire-Géographie'];
    return Directionality(
      textDirection: locale.languageCode == 'ar'
        ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(title: Text(level)),
        body: ListView(padding: const EdgeInsets.all(18), children: [
          Text(locale.languageCode == 'ar' ? 'اختر المادة' :
            locale.languageCode == 'en' ? 'Choose a subject' :
            'Choisis une matière',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ...subjects.map((subject) => Card(child: ListTile(
            leading: const Icon(Icons.auto_stories_rounded,
              color: Color(0xff0756c8)),
            title: Text(subject),
            subtitle: Text(locale.languageCode == 'ar'
              ? 'المحتوى التعليمي قيد الإعداد'
              : locale.languageCode == 'en'
                ? 'Learning content is being prepared'
                : 'Contenus pédagogiques en préparation'),
          ))),
        ]),
      ),
    );
  }
}
