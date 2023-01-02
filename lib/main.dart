import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:role_based_app/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:role_based_app/screens/splash_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Role Base App',
        theme: ThemeData(
          //
          // font-weight: ,
          primarySwatch: Colors.deepPurple,
        ),
        home: const SplashScreen());
  }
}
