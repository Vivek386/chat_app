import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'dart:io';

import 'package:chat_app/models/FirebaseHelper.dart';
import 'package:chat_app/models/SearchModel.dart';
import 'package:chat_app/models/usermodel.dart';
import 'package:chat_app/pages/ChatRoomPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Helper/Session.dart';
import '../models/ChatRoomModel.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/models/ChatRoomModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';



class Contacts extends StatefulWidget {

  final UserModel userModel;
  final User firebaseUser;

  Contacts({required this.userModel, required this.firebaseUser}) ;

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts>{

  List<Contact>? _contacts;
  List<Contact>? contactsFiltered = [];
  bool _permissionDenied = false;
  List allContacts=[];
  List firebasecontacts = [];
  TextEditingController searchC =TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchContacts();

    searchC.addListener(() {
      filterContacts();
    });


  }


 var asciicode;

  filterContacts(){
    List<Contact> contacts = [];
    contacts.addAll(_contacts!);

    asciicode = searchC.text.toLowerCase().codeUnitAt(0);

      if(searchC.text.isNotEmpty) {
        if(asciicode >= 43 && asciicode <= 57){

          contacts.retainWhere((contactno) {
            String searchTerm = searchC.text;

            String contactNumber = contactno.phones.first.number.trim()
                .toString();

            setState(() {
              searchTerm = searchC.text;
            });

            return contactNumber.contains(searchTerm);
          });
        }else if(asciicode >= 97 && asciicode <= 122 ){

          contacts.retainWhere((contactno) {
            String searchTerm = searchC.text.toLowerCase();
            String contactName = contactno.displayName.toLowerCase();

            return contactName.contains(searchTerm);
          });
        }else{

          return _contacts!;
        }

        setState(() {
          contactsFiltered = contacts;
        });
      }
      else{

        return _contacts!;
      }
  }

  Future<ChatRoomModel?> getChatRoom(UserModel targetUser)async{

    ChatRoomModel? chatroom ;
    print("uid of target user::"+targetUser.uid.toString());
    print("uid of self user::"+widget.userModel.uid.toString());
    QuerySnapshot? snapshot = await FirebaseFirestore.instance.collection("chatrooms")

        .where("participants",arrayContainsAny: [targetUser.uid!,widget.userModel.uid!] )
        .where("participantsmap.${targetUser.uid}",isEqualTo: true)
        .where("participantsmap.${widget.userModel.uid}",isEqualTo: true)
        .get();

    if(snapshot.docs.length>0){
      //fetch the existing chatroom
      log("Chatroom already created");
      var docdta = snapshot.docs[0].data();
      ChatRoomModel existingChatRoom = ChatRoomModel.fromMap(docdta as Map<String,dynamic>);
      chatroom = existingChatRoom;
    }else{
      //create a new chatroom
      log("Chatroom not created");

      ChatRoomModel newChatRoom = ChatRoomModel(
        chatRoomId: uuid.v1(),
        lastmsg: "",
        participantsmap: {
          widget.userModel.uid.toString() : true,
          targetUser.uid.toString() : true,
        },
        participants: [
          widget.userModel.uid.toString(),
          targetUser.uid.toString()
        ],
        //   targetUser.uid.toString() ,
        //       //: true,
        //   widget.userModel.uid.toString(),
        //       //: true
        // },
        chatDateTime : DateTime.now(),
        contactNo: '',
      );

      await FirebaseFirestore.instance.collection("chatrooms")
          .doc(newChatRoom.chatRoomId)
          .set(newChatRoom.toMap());
      chatroom = newChatRoom;
    }

    return chatroom;

  }

  Future _fetchContacts() async {
    if (!await FlutterContacts.requestPermission(readonly: true)) {
      setState(() => _permissionDenied = true);
    } else {
      final contacts = await FlutterContacts.getContacts(withProperties: true,withPhoto: true);
      setState(() => _contacts = contacts
      );

      QuerySnapshot? snapshot = await FirebaseFirestore.instance.collection('users').get();

     // print(snapshot.docs[0]["mobile"].toString()+".....................kya aaayaaaaaaaa");

      snapshot.docs.forEach((element) {
        print(element["mobile"].toString()+"oooooooooo");
        firebasecontacts.add(element["mobile"].toString().trim());

      });

      _contacts!.forEach((contacts) {

          allContacts.add(contacts.phones.first.normalizedNumber);
          //allContacts.removeWhere((item) => firebasecontacts.contains(item));
         // log("actuall filtered contacts" + allContacts.toString());

      });
    }
  }





  @override
  Widget build(BuildContext context) {
    bool isSearching = searchC.text.isNotEmpty;
    return Scaffold(
        appBar: AppBar(
          title: Column(
          children: [
            Text("Select Contacts"),
          Text("276 Contacts")
          ],
        ),
          actions: [
            Icon(Icons.search,size: 25,),
            Icon(Icons.more_vert,size: 25,),
          ],
        ),
        body: _contacts == null
            ? shimmer(context)

        :Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: searchC,
            onChanged: (vaklue) {
              setState(() {
              });
            },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    labelText: 'Search',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary
                      )
                    )
                  ),
                ),
              ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance.collection("users")
                      .where("uid",isNotEqualTo: widget.userModel.uid)
                      .snapshots(),
                  builder: (context,snapshot){
                    if(snapshot.connectionState == ConnectionState.active){
                      if(snapshot.hasData){
                        QuerySnapshot snapshotData = snapshot.data as QuerySnapshot;

                        if(snapshotData.docs.length>0){
                          //Map<String,dynamic> userMap = snapshotData.docs[0].data() as Map<String,dynamic>;
                          //UserModel searchedUser = UserModel.fromMap(userMap);
                          return ListView(
                            shrinkWrap: true,
                            children:  snapshotData.docs.map((DocumentSnapshot document) {
                              return ListTile(
                                onTap: ()async{
                                  UserModel? selectedUser = await FirebaseHelper.getUserModelbyId(document['uid']);
                                  print(selectedUser!.fullname.toString()+"uuuunduuu");
                                  ChatRoomModel? chatroommodel = await getChatRoom(selectedUser);
                                  if(chatroommodel!=null){
                                    Navigator.pop(context);
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                        ChatRoomPage(
                                          targetUser: selectedUser,
                                          userModel: widget.userModel,
                                          firebaseUser: widget.firebaseUser,
                                          chatRoom: chatroommodel,
                                        )));
                                  }

                                },
                                leading: CircleAvatar(
                                 backgroundImage: NetworkImage(document['profilepic'].toString()),
                                ),
                                title: Text(document['mobile'].toString()),
                                //subtitle: Text(document['indexList'].toString()),
                                // leading: CircleAvatar(
                                //   radius: 30,
                                //   backgroundImage: NetworkImage(searchedUser.profilepic.toString()),
                                // ),
                              );
                            }).toList(),
                          );
                        }else{
                          return Text("No result found!");
                        }
                      }else if(snapshot.hasError){
                        return Text("An error occured");
                      }else{
                        return Text("No result found!");
                      }
                    }else{
                      return CircularProgressIndicator();
                    }
                  }
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 10),
                child: Text("Invite to Gapshap"),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: isSearching ? contactsFiltered!.length :_contacts!.length,
                    itemBuilder: (context, i) {
                      Contact contact = isSearching  ?contactsFiltered![i] : _contacts![i];
                      Uint8List? image = contact.photo;
                      return
                        ListTile(
                            trailing: firebasecontacts.contains(contact.phones.first.normalizedNumber.toString()) ?  Text("") : Text("INVITE"),
                          leading:
                          image != null
                              ?CircleAvatar(
                            backgroundImage:  MemoryImage(image),
                          ):CircleAvatar(
                            child: Icon(Icons.person),
                          ),
                          title: Text(contact.displayName),
                          subtitle: Text(contact.phones.first.normalizedNumber.toString()),
                          onTap: () async {
                            final fullContact =
                            await FlutterContacts.getContact(contact.id);
                            await Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => ContactPage(fullContact!)));
                          });
                    }),
              ),
            ],
          ),
        ),
    );

  }
}

class ContactPage extends StatelessWidget {
  final Contact contact;
  ContactPage(this.contact);

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: Text(contact.displayName)),
      body: Column(children: [
        Text('First name: ${contact.name.first}'),
        Text('Last name: ${contact.name.last}'),
        Text(
            'Phone number: ${contact.phones.isNotEmpty ? contact.phones.first.number : '(none)'}'),
        Text(
            'Email address: ${contact.emails.isNotEmpty ? contact.emails.first.address : '(none)'}'),
      ]));
}