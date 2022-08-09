import 'package:flutter/material.dart';

class ContactsSearch{
  String? contactNo;
  String? contactName;

  ContactsSearch({@required this.contactNo,@required this.contactName});

  factory ContactsSearch.fromJson(Map<String, dynamic> json) {
       return ContactsSearch(
         contactNo: json["contactNo"],
         contactName: json["contactName"]
       );
  }


  Map<String,dynamic> toJson(){
    return {
      "contactNo": contactNo,
      "contactName" : contactName
    };
  }
}


