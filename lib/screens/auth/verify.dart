import 'package:flutter/material.dart';

import '../widgets/round_button.dart';

class VerificationPage extends StatefulWidget {
  final String vertficationId;

  const VerificationPage({Key? key, required this.vertficationId})
      : super(key: key);

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
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
              decoration: const InputDecoration(hintText: '6 digit code'),
            ),
            const SizedBox(
              height: 25,
            ),
            RoundButton(title: 'Verify', onTap: () {})
          ],
        ),
      ),
    );
  }
}
