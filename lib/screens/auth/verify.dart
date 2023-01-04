import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:role_based_app/screens/student.dart';
import 'package:role_based_app/utils/utilitiy.dart';

import '../widgets/round_button.dart';

class VerificationPage extends StatefulWidget {
  final String verifyId;

  const VerificationPage({Key? key, required this.verifyId}) : super(key: key);

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final auth = FirebaseAuth.instance;
  final verifyController = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset : false,
      appBar: AppBar(title:const Center(child:   Text('Verify OTP')),
      automaticallyImplyLeading: false),
        body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          Image(image: AssetImage('assets/auth.png') ,height: 200,),
          const SizedBox(
            height: 30,
          ),
          TextFormField(
            controller: verifyController,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), hintText: 'Enter 6 digit code'),
          ),
          const  SizedBox(
            height: 30,
          ),
          RoundButton(
              title: 'Verify',
              onTap: () async {
                setState(() {
                  loading = true;
                });
                final authCredentials = PhoneAuthProvider.credential(
                    verificationId: widget.verifyId,
                    smsCode: verifyController.text.toString());
                try {
                  await auth.signInWithCredential(authCredentials);
                  Utils().onSuccess('Verification Successful!');
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const StudentScreen()));
                } catch (e) {
                  setState(() {
                    loading = false;
                  });
                  Utils().onError(e.toString());
                }
              })
        ],
      ),
    ));
  }
}
