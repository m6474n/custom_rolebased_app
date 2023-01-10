import 'package:flutter/material.dart';
import 'package:role_based_app/firestore/upload_image.dart';
import 'package:role_based_app/screens/add_post.dart';
import 'package:role_based_app/screens/auth/register.dart';
import 'package:role_based_app/screens/student.dart';

import '../firestore/post_screen.dart';


class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Admin Dashboard'),
      automaticallyImplyLeading: false,
      actions: [
        IconButton(onPressed: (){}, icon: Icon(Icons.logout))
      ],),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20),
        child: Column(

          children: [
          ListTile(
            leading: Image(image: AssetImage('assets/add_user.png'), ),
            title: Text('Add new user.'),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> const Register()));
            },
          ),
            ListTile(
              leading: Image(image: AssetImage('assets/upload.png'), ),
              title: Text('Upload Image.'),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const UploadImage()));
              },
            ),
            ListTile(
              leading: Image(image: AssetImage('assets/firebase.png'), ),
              title: Text('Firebase Database.'),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const StudentScreen()));
              },
            ),
            ListTile(
              leading: Image(image: AssetImage('assets/firestore.png'), ),
              title: Text('Firestore Database.'),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const FirestorePostScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
