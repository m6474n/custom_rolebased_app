import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:role_based_app/screens/widgets/round_button.dart';
import 'package:role_based_app/utils/utilitiy.dart';

class AddPostFS extends StatefulWidget {
  const AddPostFS({Key? key}) : super(key: key);

  @override
  State<AddPostFS> createState() => _AddPostFSState();
}

class _AddPostFSState extends State<AddPostFS> {
  TextEditingController fireStoreController = TextEditingController();
  bool loading = false;
  final fireStore = FirebaseFirestore.instance.collection('users');


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('Add Firestore Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              maxLines: 8,
              controller: fireStoreController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),

                  hintText: "What's in your mind?"),
            ),
            const  SizedBox(
              height: 20,
            ),
            RoundButton(
                title: 'Add',
                loading: loading,
                onTap: () {
                  setState(() {
                    loading = true;
                  });

                  String id = DateTime.now().millisecondsSinceEpoch.toString();
                  fireStore.doc(id).set({
                    'id' : id,
                    'message': fireStoreController.text.toString()
                  }).then((value){

                    Utils().onSuccess("Post Added!");
                    setState(() {
                      fireStoreController.clear();
                      loading = false;
                    });
                  }).onError((error, stackTrace){
                    Utils().onError(error.toString());
                    setState(() {
                      loading = false;
                    });
                  });
                })
          ],
        ),
      ),
    );
  }
}
