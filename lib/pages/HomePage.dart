import 'package:chat_app/models/ChatRoomModel.dart';
import 'package:chat_app/models/FirebaseHelper.dart';
import 'package:chat_app/models/usermodel.dart';
import 'package:chat_app/pages/ChatRoomPage.dart';
import 'package:chat_app/pages/ContactsPage.dart';
import 'package:chat_app/pages/LoginPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'SearchPage.dart';


class HomePage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseuser;

  const HomePage({Key? key, required this.userModel, required this.firebaseuser}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

getContacts()async{

}

class _HomePageState extends State<HomePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   title: Text("Chat App"),
      //   actions: [
      //     IconButton(
      //       onPressed: ()async {
      //
      //           await FirebaseAuth.instance.signOut();
      //           Navigator.popUntil(context, (route) => route.isFirst);
      //           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPage()));
      //
      //       },
      //       icon: Icon(Icons.exit_to_app),
      //     ),
      //   ],
      // ),
      body: SafeArea(
        child: Container(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection("chatrooms")
            .where("participants",arrayContains: widget.userModel.uid)
               // .where("participantsmap.${widget.userModel.uid}",isEqualTo: true)
                .orderBy("chatDateTime",descending: true).limit(100)
                .snapshots(),
            builder: (context, datasnapshot){
              if(datasnapshot.connectionState == ConnectionState.active){
                if(datasnapshot.hasData){
                  QuerySnapshot querySnapshot = datasnapshot.data as QuerySnapshot;
                  return ListView.builder(
                      itemCount: querySnapshot.docs.length,
                      itemBuilder: (context,index){


                       ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(querySnapshot.docs[index].data() as Map<String,dynamic>);
                        Map<String,dynamic> participantsmap = chatRoomModel.participantsmap!;
                        print("participantsmap"+participantsmap.toString());
                       List participants = chatRoomModel.participants!;
                       //participants.remove(widget.userModel.uid);
                        List<String>? participantmapKeys =  participantsmap.keys.toList();
                        participantmapKeys.remove(widget.userModel.uid);

                       return FutureBuilder(
                          future: FirebaseHelper.getUserModelbyId(participantmapKeys[0]),
                         //future: FirebaseHelper.getUserModelbyId(participants[0]),
                         builder: (context , userData){
                           if(userData.connectionState == ConnectionState.done){
                             if(userData!=null){
                               UserModel targetUser = userData.data as UserModel;
                               return ListTile(
                                 onTap: (){
                                   Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatRoomPage(
                                       userModel: widget.userModel,
                                       firebaseUser: widget.firebaseuser,
                                       targetUser: targetUser,
                                       chatRoom: chatRoomModel)) );
                                 },
                                 title: Text(targetUser.fullname.toString()),
                                 subtitle: chatRoomModel.lastmsg.toString()!=""
                                     ?Text(chatRoomModel.lastmsg.toString())
                                     :Text("Say hi to your new friend!"),
                                 leading: CircleAvatar(
                                   backgroundColor: Colors.grey[300],
                                   backgroundImage: NetworkImage(
                                       targetUser.profilepic.toString()
                                   ),
                                 ),
                               );
                             }else{
                               return Container();
                             }
                           }else{
                             return Container();
                           }
                         },
                       );
                      }
                  );
                }else if(datasnapshot.hasError){
                  return Center(child: Text(datasnapshot.error.toString()),);
                }else{
                  return Center(child: Text("No Chats Available"));
                }
              }else{
                return Center(child: CircularProgressIndicator());
              }
            },

          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigator.push(context, MaterialPageRoute(builder: (context) {
          //   return SearchPage(userModel: widget.userModel, firebaseUser: widget.firebaseuser);
          // }));
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Contacts(userModel: widget.userModel, firebaseUser: widget.firebaseuser);
          }));
        },
        child: Icon(Icons.person_add),
      ),

    );
  }
}
