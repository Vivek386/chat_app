import 'package:chat_app/pages/Calls.dart';
import 'package:chat_app/pages/Camera.dart';
import 'dart:io';
import 'package:chat_app/pages/HomePage.dart';
import 'package:chat_app/pages/SendOtp.dart';
import 'package:chat_app/pages/Status.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/usermodel.dart';
import 'package:camera_with_files/camera_with_files.dart';
//import 'package:camera/camera.dart';

class Tabs extends StatefulWidget {
  final UserModel userModel;
  final User firebaseuser;
 // List<CameraDescription>? cameras;
 
   Tabs({Key? key, required this.userModel, required this.firebaseuser,
   //  this.cameras
   }) : super(key: key);

  @override
  State<Tabs> createState() => _TabsState();
}

class _TabsState extends State<Tabs> with SingleTickerProviderStateMixin {

  TabController? _tabController;
  int _activeTabIndex = 0;
  List<File> files = [];
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _setActiveTabIndex();
  }


  void _setActiveTabIndex() {
    _activeTabIndex = _tabController!.index;
    print("current tab index: "+_activeTabIndex.toString());
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gapshap'),
        actions: [
          InkWell(
            onTap: ()async{
              await FirebaseAuth.instance.signOut();
              Navigator.push(context, MaterialPageRoute(builder: (context) =>SendOtp()));
            },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.logout,),
              ))
        ],
        bottom: TabBar(
          // onTap: (_) async{
          //   if (_tabController!.index == 0) {
          //       // Navigator.push(
          //       //   context,
          //       //   MaterialPageRoute(
          //       //     builder: (context) => SendOtp(title: getTranslated(context, 'SEND_OTP_TITLE')),
          //       //   ),
          //       // );
          //
          //       var data = await Navigator.of(context).push(
          //         MaterialPageRoute<List<File>>(
          //           builder: (BuildContext context) => CameraApp(
          //               isMultiple: true,
          //               isSimpleUI: true,
          //               compressedSize: 100000),
          //         ),
          //       );
          //       if (data != null) {
          //         setState(() {
          //           files = data;
          //         });
          //       }
          //   }
          //
          //
          // },
          controller: _tabController,
          tabs: const <Widget>[
            Tab(
                icon: Icon(Icons.camera_alt)
            ),
            Tab(
              text: "CHATS",
            ),
            Tab(
              text: "STATUS",
            ),
            Tab(
              text: "CALLS",
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          CameraScreen(),
          HomePage(userModel: widget.userModel, firebaseuser: widget.firebaseuser),
          Status(),
          Calls()

        ],
      ),
    );
  }
}
