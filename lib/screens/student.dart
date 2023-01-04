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
  final editController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset : false,
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
          title: Text('Posts'),
          automaticallyImplyLeading: false,
        ),
        body: Column(children: [
          SizedBox(height: 20,),
          Image(image: AssetImage('assets/post.png'),height: 200,),
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
                  if (searchController.text.isEmpty) {
                    return ListTile(
                        title: Text(snapshot.child('message').value.toString()),
                        trailing: PopupMenuButton(
                          icon: const Icon(Icons.more_vert),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                                child: ListTile(
                              leading: const Icon(Icons.edit),
                              title: const Text('Edit'),
                              onTap: () {
                                Navigator.pop(context);
                                showMyDialogue(title,
                                    snapshot.child('id').value.toString());
                              },
                            )),
                             PopupMenuItem(
                                child: ListTile(

                              leading: const Icon(Icons.delete),
                              title:const Text('Delete'),
                                  onTap: (){
                                Navigator.pop(context);
                                ref.child(snapshot.child('id').value.toString()).remove();
                                  },
                            )),
                          ],
                        ));
                  } else if (title
                      .toLowerCase()
                      .contains(searchController.text.toLowerCase())) {
                    return ListTile(
                      title: Text(snapshot.child('message').value.toString()),
                    );
                  } else {
                    return Container();
                  }
                }),
          )
        ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () =>
          {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AddPost()))
          },
              // showDialog(
              // context: context,
              // builder: (context) => AlertDialog(
              //       title: const Text('Add Post'),
              //       content: TextFormField(
              //         controller: postController,
              //         maxLines: 4,
              //         decoration: const InputDecoration(
              //             border: OutlineInputBorder(),
              //             hintText: "What's in your mind?"),
              //       ),
              //       actions: [
              //         TextButton(
              //             onPressed: () {
              //               Navigator.of(context).pop();
              //               String id = DateTime.now()
              //                   .millisecondsSinceEpoch
              //                   .toString();
              //               ref.child(id).set({
              //                 'id': id,
              //                 'message': postController.text.toString(),
              //               }).then((value) {
              //                 postController.clear();
              //                 Utils().onSuccess('Post Added!');
              //               }).onError((error, stackTrace) {
              //                 Utils().onError(error.toString());
              //               });
              //             },
              //             child: const Text('Add'))
              //       ],
              //     )),

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
                      ref.child(postId).update({
                        'message': editController.text.toString()
                      }).then((value) {
                        Utils().onSuccess("Post Updated");
                      }).onError((error, stackTrace) {
                        Utils().onError(error.toString());
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
