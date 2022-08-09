import 'dart:io';
import 'package:camera_with_files/camera_with_files.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';



class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  List<File> files = [];

  @override
  void initState() {
    super.initState();
     WidgetsBinding.instance.addPostFrameCallback((_) => openCamera());
//openCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (files.isNotEmpty)
                ...files.map<Image>((ele) {
                  if (kIsWeb) {
                    return Image.network(ele.path);
                  }
                  return Image.file(ele);
                }).toList(),
              // TextButton(
              //   onPressed: () async {
              //     var data = await Navigator.of(context).push(
              //       MaterialPageRoute<List<File>>(
              //         builder: (BuildContext context) => CameraApp(
              //             isMultiple: true,
              //             isSimpleUI: true,
              //             compressedSize: 100000),
              //       ),
              //     );
              //     if (data != null) {
              //       setState(() {
              //         files = data;
              //       });
              //     }
              //   },
              //   child: const Text("Click"),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  openCamera()async{
    var data = await Navigator.of(context).push(
      MaterialPageRoute<List<File>>(
        builder: (BuildContext context) => CameraApp(
            isMultiple: true,
            isSimpleUI: true,
            compressedSize: 100000),
      ),
    );
    if (data != null) {
      setState(() {
        files = data;
      });
    }
  }
}