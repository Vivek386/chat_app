import 'dart:developer';
import 'dart:io';

import 'package:chat_app/models/usermodel.dart';
import 'package:chat_app/pages/HomePage.dart';
import 'package:chat_app/pages/tabs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class CompleteProfile extends StatefulWidget {

  final UserModel userModel;
  final User firebaseUser;
   CompleteProfile({Key? key,required this.userModel,required this.firebaseUser}) : super(key: key);

  @override
  _CompleteProfileState createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {



   File? imagePicker;
  TextEditingController fullNameController = TextEditingController();

  void selectImage(ImageSource source)async{
   XFile? pickedImage = await ImagePicker().pickImage(source: source);

   if(pickedImage!=null){
     cropImage(pickedImage);
   }
  }

  void cropImage(XFile pickedImage)async{
   final croppedImage = await ImageCropper().cropImage(
       sourcePath: pickedImage.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
     compressQuality: 30
   );

   setState(() {
   if(croppedImage!=null) {
     var imageFile = File(croppedImage.path);
        imagePicker = imageFile;
   }
   });

  }


  //TextEditingController nameController =  TextEditingController();

  void checkValues(){
    String fullName = fullNameController.text.trim();

    if(fullName == ""||imagePicker==null){
      print("Please fill all the fields");
    }else{
      log("data uploading");
     uploadData();
    }
  }

  List indexList= [];

   uploadDataa(String name) async {
     List<String> splitList = name.split(' ');
     for (int i = 0; i < splitList.length; i++) {
       for (int j = 0; j < splitList[i].length + i; j++) {
         indexList.add(splitList[i].substring(0, j).toLowerCase());
       }
     }
   }

   void uploadData() async {


     UploadTask uploadTask = FirebaseStorage.instance.ref("profilepictures").child(widget.userModel.uid.toString()).putFile(imagePicker!);

     TaskSnapshot snapshot = await uploadTask;

     String? imageUrl = await snapshot.ref.getDownloadURL();
     String? fullname = fullNameController.text.trim();



     uploadDataa(fullname);

     widget.userModel.fullname = fullname;
     widget.userModel.profilepic = imageUrl;
     widget.userModel.indexList = indexList;
     await FirebaseFirestore.instance.collection("users").doc(widget.userModel.uid).set(widget.userModel.toMap()).then((value) {
       log("Data uploaded!");
       Navigator.popUntil(context, (route) => route.isFirst);
       Navigator.pushReplacement(
         context,
         MaterialPageRoute(builder: (context) {
           return Tabs(userModel: widget.userModel, firebaseuser: widget.firebaseUser);
         }),
       );
     });
   }

  // void uploadUserData()async{
  //    UploadTask uploadTask =
  //     FirebaseStorage.instance.ref("profilepictures").child(widget.userModel.uid!.toString())
  //        .putFile(imagePicker!);
  //    TaskSnapshot snapshot = await uploadTask;
  //    String? imageUrl = await snapshot.ref.getDownloadURL();
  //    String? fullname = fullNameController.text.trim();
  //
  //    widget.userModel.profilepic = imageUrl;
  //    widget.userModel.fullname = fullname;
  //
  //
  //    await FirebaseFirestore.instance.collection("users")
  //        .doc(widget.userModel.uid).set(widget.userModel.toMap()).then((value){
  //      log("data uploaded");
  //          //print("Data Uploaded");
  //          Navigator.push(context, MaterialPageRoute(builder: (context)
  //          => HomePage(userModel: widget.userModel, firebaseuser: widget.firebaseUser)));
  //
  //    });
  // }

  void showPhotoOptions(){
    showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text("Upload Profile Picture"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              onTap: (){
                Navigator.pop(context);
                selectImage(ImageSource.gallery);
              },
              leading: Icon(Icons.photo),
              title: Text("Select a Photo from Gallery"),
            ),
            ListTile(
              onTap: (){
                Navigator.pop(context);
                selectImage(ImageSource.camera);
              },
              leading: Icon(Icons.camera),
              title: Text("Take a Photo"),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Complete Profile",style: TextStyle(fontSize: 25),),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: ListView(
            children: [
              SizedBox(height: 60,),
              CupertinoButton(
                onPressed: (){
                  showPhotoOptions();
                },
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: imagePicker!=null?FileImage(imagePicker!):null,
                  // child: Icon(
                  //   Icons.person,
                  //   size: 60,
                  // ),
                ),
              ),
              SizedBox(height: 15,),
              TextField(
                controller: fullNameController,
                decoration: InputDecoration(
                    hintText: "Full Name"
                ),
              ),
              SizedBox(height: 25,),
              CupertinoButton(
                color: Theme.of(context).colorScheme.secondary,
                onPressed : (){
                   checkValues();
                },
                child: Text("Submit"),
              )
            ],
          ),
        ),

      ),
    );
  }
}
