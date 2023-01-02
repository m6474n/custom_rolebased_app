import 'dart:async';

// import 'dart:html';
// import 'dart:js';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
                        builder: (context) => const StudentScreen()))
              });
    }else{
      Timer(
          const Duration(seconds: 3),
              () => {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const LoginScreen()))
          });
    }


  }
}
