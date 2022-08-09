import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:chat_app/Helper/Session.dart';
import 'package:chat_app/pages/VerifyOtp.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SendOtp extends StatefulWidget {
  String? title;

  SendOtp({Key? key, this.title}) : super(key: key);

  @override
  _SendOtpState createState() => _SendOtpState();
}

class _SendOtpState extends State<SendOtp> with TickerProviderStateMixin {
  bool visible = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final mobileController = TextEditingController();
  final ccodeController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String? mobile, id, countrycode, countryName, mobileno;
  bool _isNetworkAvail = true;
  Animation? buttonSqueezeanimation;
  AnimationController? buttonController;

  void validateAndSubmit() async {
    if (validateAndSave()) {
      _playAnimation();
      checkNetwork();
    }
  }

  Future<void> _playAnimation() async {
    try {
      await buttonController!.forward();
    } on TickerCanceled {}
  }

  Future<void> checkNetwork() async {
    bool avail = await isNetworkAvailable();
    if (avail) {
      //getVerifyUser();
    } else {
      Future.delayed(const Duration(seconds: 2)).then((_) async {
        if (mounted) {
          setState(() {
            _isNetworkAvail = false;
          });
        }
        await buttonController!.reverse();
      });
    }
  }

  bool validateAndSave() {
    final form = _formkey.currentState!;
    form.save();
    if (form.validate()) {
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top]);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    buttonController!.dispose();
    super.dispose();
  }

  setSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        msg,
        textAlign: TextAlign.center,
        style: TextStyle(color: Theme.of(context).colorScheme.secondary),
      ),
      backgroundColor: Colors.white54,
      elevation: 1.0,
    ));
  }

  // Widget noInternet(BuildContext context) {
  //   return Center(
  //     child: SingleChildScrollView(
  //       padding: const EdgeInsets.only(top: kToolbarHeight),
  //       child: Column(mainAxisSize: MainAxisSize.min, children: [
  //         noIntImage(),
  //         noIntText(context),
  //         noIntDec(context),
  //         AppBtn(
  //           title: getTranslated(context, 'TRY_AGAIN_INT_LBL'),
  //           btnAnim: buttonSqueezeanimation,
  //           btnCntrl: buttonController,
  //           onBtnSelected: () async {
  //             _playAnimation();
  //
  //             Future.delayed(const Duration(seconds: 2)).then((_) async {
  //               _isNetworkAvail = await isNetworkAvailable();
  //               if (_isNetworkAvail) {
  //                 Navigator.pushReplacement(
  //                     context,
  //                     CupertinoPageRoute(
  //                         builder: (BuildContext context) => super.widget));
  //               } else {
  //                 await buttonController!.reverse();
  //                 if (mounted) setState(() {});
  //               }
  //             });
  //           },
  //         )
  //       ]),
  //     ),
  //   );
  // }

/// here we are checking if the mobile number already exist in our database

//   Future<void> getVerifyUser() async {
//     try {
//       var data = {MOBILE: mobile};
//       Response response =
//       await post(getVerifyUserApi, body: data, headers: headers)
//           .timeout(const Duration(seconds: timeOut));
//
//       var getdata = json.decode(response.body);
//
//       bool? error = getdata['error'];
//       String? msg = getdata['message'];
//       await buttonController!.reverse();
//
//       SettingProvider settingsProvider =
//       Provider.of<SettingProvider>(context, listen: false);
//
//       if (widget.title == getTranslated(context, 'SEND_OTP_TITLE')) {
//         if (!error!) {
//           setSnackbar(msg!);
//
//           // settingsProvider.setPrefrence(MOBILE, mobile!);
//           // settingsProvider.setPrefrence(COUNTRY_CODE, countrycode!);
//
//           Future.delayed(const Duration(seconds: 1)).then((_) {
//             Navigator.pushReplacement(
//                 context,
//                 CupertinoPageRoute(
//                     builder: (context) => VerifyOtp(
//                       mobileNumber: mobile!,
//                       countryCode: countrycode,
//                       title: getTranslated(context, 'SEND_OTP_TITLE'),
//                     )));
//           });
//         } else {
//           setSnackbar(msg!);
//         }
//       }
//       if (widget.title == getTranslated(context, 'FORGOT_PASS_TITLE')) {
//         if (error!) {
//           settingsProvider.setPrefrence(MOBILE, mobile!);
//           settingsProvider.setPrefrence(COUNTRY_CODE, countrycode!);
//           Future.delayed(const Duration(seconds: 1)).then((_) {
//             Navigator.pushReplacement(
//                 context,
//                 CupertinoPageRoute(
//                     builder: (context) => VerifyOtp(
//                       mobileNumber: mobile!,
//                       countryCode: countrycode,
//                       title: getTranslated(context, 'FORGOT_PASS_TITLE'),
//                     )));
//           });
//         } else {
//           setSnackbar(getTranslated(context, 'FIRSTSIGNUP_MSG')!);
//         }
//       }
//     } on TimeoutException catch (_) {
//       setSnackbar(getTranslated(context, 'somethingMSg')!);
//       await buttonController!.reverse();
//     }
//   }

  // createAccTxt() {
  //   return Padding(
  //       padding: const EdgeInsets.only(
  //         top: 30.0,
  //       ),
  //       child: Align(
  //         alignment: Alignment.center,
  //         child: Text(
  //           widget.title == getTranslated(context, 'SEND_OTP_TITLE')
  //               ? getTranslated(context, 'CREATE_ACC_LBL')!
  //               : getTranslated(context, 'FORGOT_PASSWORDTITILE')!,
  //           style: Theme.of(context).textTheme.subtitle2!.copyWith(
  //               color:
  //               Theme.of(context).colorScheme.fontColor.withOpacity(0.38),
  //               fontWeight: FontWeight.bold),
  //         ),
  //       ));
  // }

  // Widget verifyCodeTxt() {
  //   return Padding(
  //     padding: const EdgeInsets.only(top: 13.0),
  //     child: Text(
  //       getTranslated(context, 'SEND_VERIFY_CODE_LBL')!,
  //       style: Theme.of(context).textTheme.subtitle2!.copyWith(
  //         color: Theme.of(context).colorScheme.fontColor.withOpacity(0.4),
  //         fontWeight: FontWeight.bold,
  //       ),
  //       overflow: TextOverflow.ellipsis,
  //       softWrap: true,
  //       maxLines: 3,
  //     ),
  //   );
  // }

  Widget setCodeWithMono() {
    return Padding(
      padding: EdgeInsets.only(top: 45),
      child: Container(
          height: 53,
          width: double.maxFinite,
          decoration: BoxDecoration(
              color: Colors.white54,
              border: Border.all(color: Colors.green),
              borderRadius: BorderRadius.circular(10.0)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: setCountryCode(),
              ),
              Expanded(
                flex: 4,
                child: setMono(),
              )
            ],
          )),
    );
  }

  Widget setCountryCode() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height * 0.9;
    return CountryCodePicker(
        showCountryOnly: false,
        searchStyle: TextStyle(
          color: Colors.black,
        ),
        flagWidth: 20,
        boxDecoration: BoxDecoration(
          color: Colors.white,
        ),
        searchDecoration: InputDecoration(
          hintText: 'Select country code',
          hintStyle: TextStyle(color: Colors.black),
          fillColor: Colors.white,
        ),
        showOnlyCountryWhenClosed: false,
        initialSelection: 'IN',
        dialogSize: Size(width, height),
        alignLeft: true,
        textStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold),
        onChanged: (CountryCode countryCode) {
          countrycode = countryCode.toString().replaceFirst('+', '');
          countryName = countryCode.name;
        },
        onInit: (code) {
          countrycode = code.toString().replaceFirst('+', '');
        });
  }

  Widget setMono() {
    return TextFormField(

        keyboardType: TextInputType.number,
        controller: mobileController,
        style: Theme.of(context).textTheme.subtitle2!.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.normal),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        validator: (val) => validateMob(
            val!,
            'Mobile Number Required',
            'Please enter a Valid Mobile Number'),
        onChanged: (String? value) {
          mobile = value;

        },
        onSaved: (String? value) {
          mobile = value;
        },
        decoration: InputDecoration(

          hintText: "Mobile number",
          hintStyle: Theme.of(context).textTheme.subtitle2!.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.normal),
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          // focusedBorder: OutlineInputBorder(
          //   borderSide: BorderSide(color: Theme.of(context).colorScheme.lightWhite),
          // ),
          // focusedBorder: UnderlineInputBorder(
          //   borderSide:  BorderSide(color: Theme.of(context).colorScheme.primary),
          //   borderRadius: BorderRadius.circular(7.0),
          // ),
          border: InputBorder.none,
          // enabledBorder: UnderlineInputBorder(
          //   borderSide:
          //   BorderSide(color: Colors.white54),
          // ),
        ));
  }


  backBtn() {
    return Platform.isIOS
        ? Container(
        padding: const EdgeInsets.only(top: 20.0, left: 10.0),
        alignment: Alignment.topLeft,
        child: Card(
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: InkWell(
              child:  Icon(Icons.keyboard_arrow_left,
                  color: Theme.of(context).colorScheme.primary
              ),
              onTap: () => Navigator.of(context).pop(),
            ),
          ),
        ))
        : Container();
  }
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    if(_firebaseAuth.currentUser?.uid!=null){
       print("User Logged in");
    }else{
      print("User Not logged in");
    }
    super.initState();
    // buttonController = AnimationController(
    //     duration: const Duration(milliseconds: 2000), vsync: this);
    //
    // buttonSqueezeanimation = Tween(
    //   begin: MediaQuery.of(context).size.width * 0.7,
    //   end: 50.0,
    // ).animate(CurvedAnimation(
    //   parent: buttonController!,
    //   curve: const Interval(
    //     0.0,
    //     0.150,
    //   ),
    // ));
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        backgroundColor: Colors.white,

        body: _isNetworkAvail
            ? Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                    top: 23,
                    left: 23,
                    right: 23,
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Form(
                  key: _formkey,
                  child: Column(
                    children: [

                      Text("Verify your Phone Number",textAlign: TextAlign.center,style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold,fontSize: 20),),
                      SizedBox(height: 35,),
                      Text("Gapshap will send an sms message to verify your phone number.",textAlign: TextAlign.center,),
                      setCodeWithMono(),
                       // Spacer(),
                      //SizedBox(height: 300,),
                       GestureDetector(
                         onTap: (){
                           //print("mobile number: "+mobile.toString()+countrycode.toString());
                           Navigator.push(context, MaterialPageRoute(builder: (context)=>VerifyOtp(mobileNumber: mobile,
                             countryCode: countrycode,)));
                         },
                         child: Container(
                           child: Column(
                             children: [
                               Container(
                                 padding: EdgeInsets.symmetric(horizontal: 15,vertical: 8),

                                 decoration: BoxDecoration(
                                color: Colors.green,
                                   borderRadius: BorderRadius.circular(5),
                           ),
                                 child: Text("NEXT",style: TextStyle(color: Colors.white,fontSize: 17),),
                               ),
                               Text("Carrier sms charges may apply.",textAlign: TextAlign.center,style: TextStyle(color: Colors.black54),),
                             ],
                           ),
                         ),
                       ),
                      SizedBox(height: 50,),
                    ],
                  ),
                ),
              ),
            )
            : Center(
          child: Text("Kindly check your Internet Connection"),
        ));
  }


}
