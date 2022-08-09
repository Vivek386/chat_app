import 'dart:developer';
import 'package:chat_app/Provider/StatusProvider.dart';
import 'package:chat_app/models/FirebaseHelper.dart';
import 'package:chat_app/models/usermodel.dart';
import 'package:chat_app/pages/Splash.dart';
import 'package:chat_app/pages/tabs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  User? currentUser = FirebaseAuth.instance.currentUser;
  if(currentUser!=null){
    UserModel? _userModel = await FirebaseHelper.getUserModelbyId(currentUser.uid);
    if(_userModel!=null){
      runApp( MyAppLoggedIn(userModel: _userModel, firebaseUser: currentUser));
    }else{
      runApp(const MyApp());
    }

  }else{
    runApp(const MyApp());
  }

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Splash(),
    );
  }
}

class MyAppLoggedIn extends StatelessWidget {
  UserModel userModel;
  User firebaseUser;
   MyAppLoggedIn({Key? key,required this.userModel,required this.firebaseUser}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<StatusProvider>(
            create: (context) => StatusProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Tabs(
          userModel: userModel,firebaseuser: firebaseUser,
            //cameras: cameras
        ),
      ),
    );
  }
}

