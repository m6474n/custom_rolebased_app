// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:async';

// import 'dart:html';
// import 'dart:js';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:role_based_app/firestore/post_screen.dart';
import 'package:role_based_app/firestore/upload_image.dart';
import 'package:role_based_app/screens/admin.dart';
import 'package:role_based_app/screens/auth/login.dart';
import 'package:role_based_app/screens/student.dart';

class SplashServices {
  void isLogin(BuildContext context) {
    FirebaseAuth _auth = FirebaseAuth.instance;
    final user = _auth.currentUser;
    if (user != null) {
      Timer(
          const Duration(seconds: 3),
          () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AdminScreen()))
              });
    } else {
      Timer(
          const Duration(seconds: 3),
          () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()))
              });
    }
  }
}
