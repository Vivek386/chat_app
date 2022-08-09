import 'dart:io';

import 'package:chat_app/models/usermodel.dart';
import 'package:chat_app/pages/CompleteProfilePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  TextEditingController emailController =  TextEditingController();
  TextEditingController passwordController =  TextEditingController();
  TextEditingController confirmpasswordController =  TextEditingController();



  void checkValues(){
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmpassword = confirmpasswordController.text.trim();

    if(email==""||password==""||confirmpassword==""){
      print("field values are empty");
    }else if(password!=confirmpassword){
      print("password does not match");
    }else{
      signUp(email, password);
    }
  }

  void signUp(String email,String password)async {
    UserCredential? credential;
    try{
      credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    }on FirebaseAuthException catch(e){
      print(e.message.toString());
    }
    if(credential!=null){
      String uid = credential.user!.uid;

      UserModel newUser = UserModel(
        uid: uid,
        mobile: "",
        //email: email,
        fullname: "",
        profilepic: "",
      );
      await FirebaseFirestore.instance.collection("users").doc(uid).set(
          newUser.toMap()).then((value) {
            print("New user created");
            Navigator.popUntil(context, (route) => route.isFirst);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>CompleteProfile(userModel: newUser,
              firebaseUser: credential!.user!,)));


      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  Text(
                    "ChatApp",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10,),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                        hintText: "email"
                    ),
                  ),
                  SizedBox(height: 10,),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                        hintText: "password"
                    ),
                  ),
                  SizedBox(height: 10,),
                  TextField(
                    controller: confirmpasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                        hintText: "confirm password"
                    ),
                  ),
                  SizedBox(height: 20,),
                  CupertinoButton(
                    color: Theme.of(context).colorScheme.secondary,
                    onPressed : (){
                      checkValues();

                    },
                    child: Text("SignUp"),
                  )
                ],
              ),
            ),
          ),
        ),

      ),
      bottomNavigationBar: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Already have an account ?",
              style: TextStyle(fontSize: 16),),
            CupertinoButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: Text("Log In"),
            )
          ],
        ),
      ),
    );
  }
}
