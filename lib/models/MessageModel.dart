import 'package:flutter/material.dart';

class MessageModel{
  String? messageid;
  String? sender;
  String? text;
  bool? seen;
  DateTime? createdon;

  MessageModel({required this.messageid,required this.text,required this.sender,
    required this.createdon,required this.seen});

  MessageModel.fromMap(Map<String,dynamic>data){
    messageid = data["messageid"];
    sender = data["sender"];
    text = data["text"];
    seen = data["seen"];
    createdon = data["createdon"].toDate();
  }

  Map<String,dynamic> toMap(){
    return {
      "messageid": messageid,
      "sender" : sender,
      "text" : text,
      "seen" : seen,
      "createdon" : createdon
    };
  }
}