import 'package:chat_app/pages/SendOtp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Text("Welcome to Gapshap",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.green),),
          ),
          Spacer(),
          CircleAvatar(
            radius: 130,
            backgroundColor: Colors.grey.shade200,
          ),
          Spacer(),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'Read our ',
                    style: TextStyle(fontSize: 15,color: Colors.black87),
                    children:  <TextSpan>[
                      TextSpan(text: 'Privacy Policy.', style: TextStyle(fontWeight: FontWeight.bold,color: Theme.of(context).colorScheme.secondary)),
                      TextSpan(text: 'Tap "Agree and continue" to accept the '),
                      TextSpan(text: 'Terms of Service.')

                    ],
                  ),
                ),
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>SendOtp()));
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.green,
                    ),
                    child: Text("AGREE AND CONTINUE",style: TextStyle(color: Colors.white),),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
