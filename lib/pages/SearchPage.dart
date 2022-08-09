import 'dart:developer';
import 'package:chat_app/main.dart';
import 'package:chat_app/models/ChatRoomModel.dart';
import 'package:chat_app/models/FirebaseHelper.dart';
import 'package:chat_app/models/usermodel.dart';
import 'package:chat_app/pages/ChatRoomPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const SearchPage({Key? key, required this.userModel, required this.firebaseUser}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  TextEditingController searchController = TextEditingController();

  Future<ChatRoomModel?> getChatRoom(UserModel targetUser)async{

    ChatRoomModel? chatroom ;
    print("uid of target user::"+targetUser.uid.toString());
    print("uid of self user::"+widget.userModel.uid.toString());
    QuerySnapshot? snapshot = await FirebaseFirestore.instance.collection("chatrooms")
       //.where("participants",arrayContains: widget.userModel.uid)
    .where("participants",arrayContainsAny: [targetUser.uid!,widget.userModel.uid!] )
    .where("participantsmap.${targetUser.uid}",isEqualTo: true)
    .where("participantsmap.${widget.userModel.uid}",isEqualTo: true)
        .get();
        //.where("participantsmap.${targetUser.uid}",isEqualTo: true)
        //.where("participantsmap.${widget.userModel.uid}",isEqualTo: true).get();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search"),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: Column(
            children: [

              TextField(
                onChanged: (value) {
                  setState(() {
                    print("9999999"+searchController.text.toString());
                  });
                },
                controller: searchController,

                decoration: InputDecoration(
                    labelText: "Name"
                ),
              ),

              SizedBox(height: 20,),

              CupertinoButton(
                onPressed: () {
                    setState(() {

                    });
                },
                color: Theme.of(context).colorScheme.secondary,
                child: Text("Search"),
              ),

              SizedBox(height: 20,),
              StreamBuilder(
                  stream: FirebaseFirestore.instance.collection("users")
                      .where("indexList", arrayContains: searchController.text.toString() )
                      .where("fullname",isNotEqualTo: widget.userModel.fullname)
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
                                    UserModel? searchedUser = await FirebaseHelper.getUserModelbyId(document['uid']);
                                    print(searchedUser!.fullname.toString()+"uuuunduuu");
                                    ChatRoomModel? chatroommodel = await getChatRoom(searchedUser);
                                    if(chatroommodel!=null){
                                      Navigator.pop(context);
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                          ChatRoomPage(
                                            targetUser: searchedUser,
                                            userModel: widget.userModel,
                                            firebaseUser: widget.firebaseUser,
                                            chatRoom: chatroommodel,
                                          )));
                                   }

                                  },
                                  title: Text(document['fullname'].toString()),
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

            ],
          ),
        ),
      ),
    );
  }
}
