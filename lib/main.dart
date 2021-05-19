import 'package:avdan/screens/home.dart';
import 'package:flutter/material.dart';
import 'data/store.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialize();
  runApp(Avdan());
}

class Avdan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Avdan',
      theme: ThemeData(
        primaryColor: Colors.white,
        cardTheme: CardTheme(
          shape: BeveledRectangleBorder(),
        ),
      ),
      home: HomeScreen(),
    );
  }
}
