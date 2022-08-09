import 'package:chat_app/models/usermodel.dart';
import 'package:chat_app/pages/tabs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'HomePage.dart';
import 'SignUpPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController =  TextEditingController();
  TextEditingController passwordController =  TextEditingController();

  void checkValues(){
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if(email==""||password==""){
      print("field values are empty");
    }else{
      signIn(email, password);
    }
  }

  void signIn(String email,String password)async {
    UserCredential? credential;
    try{
      credential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    }on FirebaseAuthException catch(e){
      print(e.message.toString());
    }
    if(credential!=null){
      String uid = credential.user!.uid;

      DocumentSnapshot userData =
      await FirebaseFirestore.instance.collection("users").doc(uid).get();
      UserModel userModel = UserModel.fromMap(userData.data() as Map<String,dynamic>);
       print("Login Successful");
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)
      => Tabs(userModel: userModel, firebaseuser: credential!.user!)));
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
                  SizedBox(height: 20,),
                  CupertinoButton(
                    color: Theme.of(context).colorScheme.secondary,
                      onPressed : (){
                          checkValues();
                      },
                    child: Text("Log In"),
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
            Text("Don't have an account ?",
            style: TextStyle(fontSize: 16),),
            CupertinoButton(
              onPressed: (){
                 Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUpPage()));
              },
              child: Text("SignUp"),
            )
          ],
        ),
      ),
    );
  }
}
