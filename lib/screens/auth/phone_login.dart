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
        resizeToAvoidBottomInset : false,
     appBar: AppBar(title: Text('Login with Phone'),),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              SafeArea(child: Image(image: AssetImage('assets/phone_auth.png'),height: 300,)),
              const  SizedBox(height: 30,),
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Enter Phone Number'),
                    hintText: '+1 234 4567 6789'
                ),
              )
              , const SizedBox(height: 30,),
              RoundButton(title: 'Get OTP', loading: loading, onTap: () {
                setState(() {
                  loading = true;
                });

                auth.verifyPhoneNumber(
                    phoneNumber: phoneController.text,
                    verificationCompleted: (_) {
                      setState(() {
                        loading = false;
                      });

                    },
                    verificationFailed: (e) {
                      Utils().onError(e.toString());
                      setState(() {
                        loading = false;
                      });

                    },
                    codeSent: (String verificationId, int? token) {
                      setState(() {
                        loading = false;
                      });

                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) =>
                              VerificationPage(verifyId: verificationId)));
                    },
                    codeAutoRetrievalTimeout: (e) {
                      setState(() {
                        loading = false;
                      });

                      Utils().onError(e.toString());
                    });
              }),

            ],
          ),
        )
    );
  }
}
