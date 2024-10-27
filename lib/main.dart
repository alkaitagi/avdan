import 'package:avdan/modules/languages/languages.dart';
import 'package:avdan/modules/updates/services/loader.dart';
import 'package:avdan/shared/contents.dart';
import 'package:avdan/shared/localizations.dart';
import 'package:avdan/shared/prefs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'firebase_options.dart';
import 'theme_set.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  void setup(BuildContext context) async {
    if (intLng.isEmpty || !hasDecks) {
      await FirebaseFirestore.instance.doc('languages/english').get().then(
            (s) => putLocalizations(
              (s.data()!['localizations'] as Map<String, dynamic>)
                  .cast<String, String>(),
            ),
          );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute<void>(
          builder: (context) => const LanguagesScreen(
            isInitial: true,
          ),
        ),
      );
    } else {
      launchHome(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeSet(Theme.of(context).colorScheme);
    return MaterialApp(
      title: 'Avdan',
      theme: theme.light,
      darkTheme: theme.dark,
      home: FutureBuilder(
        future: Future.wait([
          Future<void>.delayed(const Duration(seconds: 2)),
          Hive.initFlutter().then(
            (_) async {
              await initPrefs();
              await initContents();
              await initLocalizations();
            },
          ),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Future.microtask(() => setup(context));
          }
          return Material(
            child: SafeArea(
              child: Center(
                child: SizedBox(
                  height: 500,
                  child: Theme.of(context).brightness == Brightness.dark
                      ? Image.asset('assets/splash_dark.png')
                      : Image.asset('assets/splash_light.png'),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
