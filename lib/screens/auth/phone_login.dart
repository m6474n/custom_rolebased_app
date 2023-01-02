import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:role_based_app/screens/auth/verify.dart';

import '../../utils/utilitiy.dart';
import '../widgets/round_button.dart';

class PhoneLogin extends StatefulWidget {
  const PhoneLogin({Key? key}) : super(key: key);

  @override
  State<PhoneLogin> createState() => _PhoneLoginState();
}

class _PhoneLoginState extends State<PhoneLogin> {
  bool loading = false;
  final phoneController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              keyboardType: TextInputType.number,
              controller: phoneController,
              decoration: const InputDecoration(
                  hintText: '+1 123 3456 6789'
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            RoundButton(title: 'Continue with phone',loading: loading, onTap: () {
              setState(() {
                loading = true;
              });
              auth.verifyPhoneNumber(
                phoneNumber: phoneController.text,
                  verificationCompleted: (_){
                    setState(() {
                      loading = false;
                    });
                  },
                  verificationFailed: (e){
                    setState(() {
                      loading = false;
                    });
                  Utils().onError(e.toString());
                  },
                  codeSent: (String verificationId , int? token){
                    setState(() {
                      loading = false;
                    });
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> VerificationPage(vertficationId: verificationId,)));
                  },
                  codeAutoRetrievalTimeout: (e){
                    setState(() {
                      loading = false;
                    });
                    Utils().onError(e.toString());
                  },);
            })

          ],
        ),
      ),
    );
  }
}
