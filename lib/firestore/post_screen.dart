import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:role_based_app/firestore/add_firestore_post.dart';
import 'package:role_based_app/screens/auth/login.dart';

import '../utils/utilitiy.dart';

class FirestorePostScreen extends StatefulWidget {
  const FirestorePostScreen({Key? key}) : super(key: key);

  @override
  State<FirestorePostScreen> createState() => _FirestorePostScreenState();
}

class _FirestorePostScreenState extends State<FirestorePostScreen> {
  final fireStore = FirebaseFirestore.instance.collection('users').snapshots();
  CollectionReference ref1 = FirebaseFirestore.instance.collection('users');
  FirebaseAuth auth = FirebaseAuth.instance;
  final postController = TextEditingController();
  final searchController = TextEditingController();
  final editController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  auth.signOut().then((value) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                  }).onError((error, stackTrace) {
                    Utils().onError(error.toString());
                  });
                },
                icon: const Icon(Icons.logout_outlined))
          ],
          title: Text('Firestore Posts'),
          automaticallyImplyLeading: false,
        ),
        body: Column(children: [
          SizedBox(
            height: 20,
          ),
          Image(
            image: AssetImage('assets/post.png'),
            height: 200,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 18.0),
            child: Text(
              'FIRESTORE DATABASE',
              style: TextStyle(
                fontSize: 16,
                letterSpacing: 3,
                color: Colors.deepPurple,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              onChanged: (String value) {
                setState(() {});
              },
              controller: searchController,
              decoration: const InputDecoration(
                hintText: 'Search',
                border: OutlineInputBorder(),
              ),
            ),
          ),


//////////////////// Firebase Animated List////////////////////////
          StreamBuilder<QuerySnapshot>(
              stream: fireStore,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(child: CircularProgressIndicator());

                if (snapshot.hasError) return Text('Something Wrong');

                return Expanded(
                  child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final title =
                            snapshot.data!.docs[index]['message'].toString();
                        final id = snapshot.data!.docs[index].id.toString();
                        if (searchController.text.isEmpty) {
                          return ListTile(
                              title: Text(snapshot.data!.docs[index]['message']
                                  .toString()),
                              trailing: PopupMenuButton(
                                  icon: Icon(Icons.more_vert),
                                  itemBuilder: (context) => [
                                        PopupMenuItem(
                                          child: ListTile(
                                            leading: Icon(Icons.edit),
                                            title: Text('Edit'),
                                            onTap: () {
                                              Navigator.pop(context);
                                              showMyDialogue(title, id);

                                            },
                                          ),
                                        ),
                                        PopupMenuItem(
                                          child: ListTile(
                                            leading: Icon(Icons.edit),
                                            title: Text('Delete'),
                                            onTap: () {
                                              Navigator.pop(context);
                                              ref1.doc(id).delete();
                                            },
                                          ),
                                        ),
                                      ]));
                        } else if (title
                            .toLowerCase()
                            .contains(searchController.text.toLowerCase())) {
                          return ListTile(
                              title: Text(snapshot.data!.docs[index]['message']
                                  .toString()),
                              trailing: PopupMenuButton(
                                  icon: Icon(Icons.more_vert),
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      child: ListTile(
                                        leading: Icon(Icons.edit),
                                        title: Text('Edit'),
                                        onTap: () {},
                                      ),
                                    ),
                                    PopupMenuItem(
                                      child: ListTile(
                                        leading: Icon(Icons.edit),
                                        title: Text('Delete'),
                                        onTap: () {},
                                      ),
                                    ),
                                  ]));
                        } else {
                          return Container();
                        }
                      }),
                );


              }),
        ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () => {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AddPostFS()))
          },


          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Future<void> showMyDialogue(String msg, String postId) async {
    editController.text = msg;
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Edit'),
              content: Container(
                child: TextField(
                  controller: editController,
                  decoration: const InputDecoration(
                    hintText: 'Write Something!',
                  ),
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                   ref1.doc(postId).update({
                     'message': editController.text
                   });
                    },
                    child: const Text('update')),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('cancel'))
              ],
            ));
  }
}
