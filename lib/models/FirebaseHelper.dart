import 'package:chat_app/models/usermodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

  class FirebaseHelper{

  static Future<UserModel?>getUserModelbyId(String uid)async{
    UserModel? userModel;

    DocumentSnapshot docsnap =
    await FirebaseFirestore.instance.collection("users").doc(uid).get();

    if(docsnap.data() != null){
      userModel = UserModel.fromMap(docsnap.data() as Map<String,dynamic>);
    }

    return userModel;
  }
}