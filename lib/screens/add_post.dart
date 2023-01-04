import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:role_based_app/screens/widgets/round_button.dart';
import 'package:role_based_app/utils/utilitiy.dart';

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  TextEditingController  postController = TextEditingController();
  bool loading = false;

  final databaseRef = FirebaseDatabase.instance.ref('Post');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('Add New Post'),
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
              controller: postController,
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
                  String id =  DateTime.now().millisecondsSinceEpoch.toString();

                  databaseRef.child(id).set({
                    'id': id,
                    'message': postController.text.toString()
                  }).then((value) {
                    setState(() {
                      postController.clear();
                      loading = false;
                    });
                    Utils().onSuccess('Post Added!');
                  }).onError((error, stackTrace) {
                    setState(() {
                      loading = false;
                    });

                    Utils().onError(error.toString());
                  });
                })
          ],
        ),
      ),
    );
  }
}
