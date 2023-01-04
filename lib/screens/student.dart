import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:role_based_app/screens/add_post.dart';
import 'package:role_based_app/screens/auth/login.dart';

import '../utils/utilitiy.dart';

class StudentScreen extends StatefulWidget {
  const StudentScreen({Key? key}) : super(key: key);

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  final ref = FirebaseDatabase.instance.ref('Post');
  FirebaseAuth auth = FirebaseAuth.instance;
  final postController = TextEditingController();
final searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
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
          title: const Text('Student'),
          automaticallyImplyLeading: false,
        ),
        body: Column(children: [

          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              onChanged: (String value){
                setState(() {

                });
              },
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search',
                    border: OutlineInputBorder(),
              ),
            ),
          ),

/////////////////////// Stream Builder /////////////////////
          // Expanded(
          //   child: Container(
          //     child: StreamBuilder(
          //       stream: ref.onValue,
          //       builder:(context, snapshot){
          //
          //         if(!snapshot.hasData){
          //           return CircularProgressIndicator();
          //         }else{
          //           Map<dynamic , dynamic> map = snapshot.data!.snapshot.value as dynamic;
          //           List<dynamic> list = [];
          //           list.clear();
          //           list = map.values.toList();
          //           return ListView.builder(
          //               itemCount: snapshot.data!.snapshot.children.length,
          //               itemBuilder: (context, index){
          //
          //                 return  ListTile(
          //                   title: Text(list[index]['message']),
          //                 );
          //               });
          //         }
          //
          //
          //
          //       },
          //     ),
          //   ),
          // ),
          //

//////////////////// Firebase Animated List////////////////////////
          Expanded(
            child: FirebaseAnimatedList(
                query: ref,
                itemBuilder: (context, snapshot, animation, index) {

//////////////////// Filter List  Using Search Bar /////////////////////
                  final title = snapshot.child('message').value.toString();
                    if(searchController.text.isEmpty){
                      return ListTile(
                        title: Text(snapshot.child('message').value.toString()),
                      );

                    }else if(title.toLowerCase().contains(searchController.text.toLowerCase())){

                      return ListTile(
                        title: Text(snapshot.child('message').value.toString()),
                      );
                    }else{

                      return Container(

                      );
                    }



                }),
          )
        ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: const Text('Add Post'),
                    content: TextFormField(
                      controller: postController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "What's in your mind?"),
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            addPost();
                            ref
                                .child(DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString())
                                .set({
                              'id': DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString(),
                              'message': postController.text.toString(),
                            }).then((value) {
                              postController.clear();
                              Utils().onSuccess('Post Added!');
                            }).onError((error, stackTrace) {
                              Utils().onError(error.toString());
                            });
                          },
                          child: const Text('Add'))
                    ],
                  )),

          // {
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (context) => AddPost()));

          // },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void addPost() {
    Navigator.of(context).pop();
  }
}
