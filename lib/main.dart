import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/view/main_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        textTheme: TextTheme(
          headline4: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, ),
          bodyText1: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, ),
          bodyText2: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, ),
        )
      ),
      home: MainScreen(),
    ),
  );
}
