import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:role_based_app/screens/widgets/round_button.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebaseStorage;
import 'package:role_based_app/utils/utilitiy.dart';

class UploadImage extends StatefulWidget {
  const UploadImage({Key? key}) : super(key: key);

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  File? _image;
firebaseStorage.FirebaseStorage storage = firebaseStorage.FirebaseStorage.instance;
  bool loading =  false;
  final picker = ImagePicker();
DatabaseReference databaseRef = FirebaseDatabase.instance.ref('Post');
  Future getGalleryImage() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('Please Pick an image!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(child: Text('Upload Image')),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 38.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  getGalleryImage();
                },
                child: Container(
                  width: 150,
                  height: 150,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child:_image != null? Image.file(_image!.absolute) : Icon(
                    Icons.image,
                    size: 80,
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              RoundButton(title: 'Upload', loading: loading, onTap: () async{setState(() {
                loading = true;
              });

           firebaseStorage.Reference ref = firebaseStorage.FirebaseStorage.instance.ref('/images'+ '2244');
                firebaseStorage.UploadTask uploadTask = ref.putFile(_image!.absolute);

                await Future.value(uploadTask);

                var newUrl = await ref.getDownloadURL();
                String id = DateTime.now().millisecondsSinceEpoch.toString();

                databaseRef.child(id).set({
                  'id':  id,
                  'image': newUrl.toString()

                }).then((value){
                  setState(() {
                    loading = false;
                  });
                  Utils().onSuccess("Uploaded");

                }).onError((error, stackTrace){
                  Utils().onError(error.toString());
                });


              })
            ],
          ),
        ),
      ),
    );
  }
}
