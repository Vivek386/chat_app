import 'package:flutter/material.dart';
import 'package:colorful_background/colorful_background.dart';
import 'package:chat_app/Provider/StatusProvider.dart';
import 'package:provider/provider.dart';

class StatusText extends StatefulWidget {

  @override
  State<StatusText> createState() => _StatusTextState();
}

class _StatusTextState extends State<StatusText> {
  int _index = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(context.read<StatusProvider>().currentIndex != null && context.read<StatusProvider>().currentIndex != 0) {
      _index = (context.read<StatusProvider>().currentIndex + 1);
      context.read<StatusProvider>().setCurrentIndex(_index);
    }
    else if(context.read<StatusProvider>().currentIndex == (ColorCodes.length-1)){
      _index = 0;
      context.read<StatusProvider>().setCurrentIndex(_index);
    }
    else{
      _index = 0;
    }
  }

  List<int>ColorCodes = [0XFF5d8aa8,0XFFe32636,0XFFe52b50,0XFFffbf00,0XFF9966cc,
    0XFFa4c639 ,0XFFcd9575,0XFF915c83,0XFF8db600,0XFF4b5320,0XFFe9d66b,0XFFff9966,
    0XFF6e7f80,0XFF007fff,0XFFffe135,0XFFfe6f5e,0XFF0d98ba,0XFFde5d83,0XFF79443b,0XFF006a4e,
    0XFF873260,0XFFff007f,0XFFc32148,0XFF004225,0XFFcd7f32,0XFFa52a2a,0XFFcc5500,0XFFed872d];

  void _changeBackGroundColors(){
    setState(() {
      _index++;
      if(_index < (ColorCodes.length-1)){
        context.read<StatusProvider>().setCurrentIndex(_index);
      }else{
        _index = 0;
        context.read<StatusProvider>().setCurrentIndex(_index);
      }

    });
    //_index++;
  }

  @override
  Widget build(BuildContext context) {

   double deviceHeight = MediaQuery.of(context).size.height/100;
   double deviceWidth = MediaQuery.of(context).size.width/100;


    return Scaffold(
      backgroundColor: Color(ColorCodes[_index]),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text(
            //     context.read<StatusProvider>().currentIndex!=null
            //         ?context.read<StatusProvider>().currentIndex.toString()
            //         :"1"
            // ),
            TextField(
              autofocus: true,
              cursorColor: Colors.white,
              cursorHeight: 80,
              maxLines: null,
              style: TextStyle(color: Colors.white, fontSize: deviceHeight!*6, letterSpacing: 2),
              textAlign: TextAlign.center,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Type a status',
                  hintStyle: TextStyle(color: Colors.white54,fontSize: deviceHeight!*6,letterSpacing: 2)
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _changeBackGroundColors,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }




}