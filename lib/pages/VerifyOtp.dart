import 'package:chat_app/Helper/Session.dart';
import 'package:chat_app/models/usermodel.dart';
import 'package:chat_app/pages/CompleteProfilePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VerifyOtp extends StatefulWidget {

  final String? mobileNumber, countryCode;

  const VerifyOtp({this.mobileNumber,this.countryCode})  ;

  @override
  State<VerifyOtp> createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {

  final dataKey = GlobalKey();
  String? password;
  String? otp;
  bool isCodeSent = false;
  late String _verificationId;
  String signature = '';
  bool _isClickable = false;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserDetails();
    getSingature();
    _onVerifyCode();
    Future.delayed(const Duration(seconds: 60)).then((_) {
      _isClickable = true;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
                top: 23,
                left: 23,
                right: 23,
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // getLogo(),
                monoVarifyText(),
                otpText(),
                mobText(),
                otpLayout(),
                resendText(),
                verifyBtn(),
                /* SizedBox(
                        height: deviceHeight! * 0.1,
                      ),
                      termAndPolicyTxt(),*/
              ],
            ),
          ),
        )
    );
  }

  monoVarifyText() {
    return Padding(
        padding: const EdgeInsetsDirectional.only(
          top: 60.0,
        ),
        child: Text("Enter Verification Code",
            style: Theme.of(context).textTheme.headline6!.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 23,
                letterSpacing: 0.8)));
  }

  otpText() {
    return Padding(
        padding: const EdgeInsetsDirectional.only(
          top: 13.0,
        ),
        child: Text(
          "We have sent a verification code to",
          style: Theme.of(context).textTheme.subtitle2!.copyWith(
            color: Colors.black.withOpacity(0.5),
            fontWeight: FontWeight.bold,
          ),
        ));
  }

  mobText() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 5.0),
      child: Text(
        '+${widget.countryCode}-${widget.mobileNumber}',
        style: Theme.of(context).textTheme.subtitle2!.copyWith(
          color: Colors.black.withOpacity(0.5),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget otpLayout() {
    return Padding(
        padding: const EdgeInsetsDirectional.only(top: 30),
        child: PinFieldAutoFill(
            decoration: BoxLooseDecoration(
                textStyle: TextStyle(
                    fontSize: 20,
                    color: Colors.black),
                radius: Radius.circular(4.0),
                // strokeWidth: 20,
                gapSpace: 15,
                bgColorBuilder: FixedColorBuilder(
                    Colors.white54.withOpacity(0.4)),
                strokeColorBuilder: FixedColorBuilder(
                    Colors.black.withOpacity(0.2))),
            currentCode: otp,
            codeLength: 6,
            onCodeChanged: (String? code) {
              otp = code;
            },
            onCodeSubmitted: (String code) {
              otp = code;
            }));
  }

  Widget resendText() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 30.0),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Didn't received the code",
            style: Theme.of(context).textTheme.caption!.copyWith(
                color: Colors.black.withOpacity(0.5),
                fontWeight: FontWeight.bold),
          ),
          InkWell(
              onTap: () async {
                //await buttonController!.reverse();
                checkNetworkOtp();
              },
              child: Text(
                "Resend Otp",
                style: Theme.of(context).textTheme.caption!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    // decoration: TextDecoration.underline,
                    fontWeight: FontWeight.bold),
              ))
        ],
      ),
    );
  }

  Future<void> checkNetworkOtp() async {
    bool avail = await isNetworkAvailable();
    if (avail) {
      if (_isClickable) {
        _onVerifyCode();
      } else {
        setSnackbar("Request new OTP after 60 seconds",context);
      }
    } else {
      if (mounted) setState(() {});

      Future.delayed(const Duration(seconds: 60)).then((_) async {
        bool avail = await isNetworkAvailable();
        if (avail) {
          if (_isClickable) {
            _onVerifyCode();
          } else {
            setSnackbar("Request new OTP after 60 seconds",context);
          }
        } else {
          //await buttonController!.reverse();
          setSnackbar("Something went wrong! Please try again later",context);
        }
      });
    }
  }

  Future<void> getSingature() async {
    signature = await SmsAutoFill().getAppSignature;
    SmsAutoFill().listenForCode;
  }

  getUserDetails() async {
    if (mounted) setState(() {});
  }

  void _onVerifyCode() async {
    if (mounted) {
      setState(() {
        isCodeSent = true;
      });
    }
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) {
      _firebaseAuth
          .signInWithCredential(phoneAuthCredential)
          .then((UserCredential credential) async{
        if (credential.user != null) {


          setSnackbar("Otp Verified Successfully",context);

          String uid = credential.user!.uid;

          UserModel newUser = UserModel(
            uid: uid,
            mobile: "",
            fullname: "",
            profilepic: "",
          );
          await FirebaseFirestore.instance.collection("users").doc(uid).set(
              newUser.toMap()).then((value) {
            print("New user created");
            Navigator.popUntil(context, (route) => route.isFirst);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>CompleteProfile(userModel: newUser,
              firebaseUser: credential.user!,)));


          });
          // settingsProvider.setPrefrence(MOBILE, widget.mobileNumber!);
          // settingsProvider.setPrefrence(COUNTRY_CODE, widget.countryCode!);

        } else {
          setSnackbar("Error validating OTP, try again",context);
        }
      }).catchError((error) {
        setSnackbar(error.toString(),context);
      });
    };
    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      if (mounted) {
        setState(() {
          isCodeSent = false;
        });
      }
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int? forceResendingToken]) async {
      _verificationId = verificationId;
      if (mounted) {
        setState(() {
          _verificationId = verificationId;
        });
      }
    };
    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
      if (mounted) {
        setState(() {
          _isClickable = true;
          _verificationId = verificationId;
        });
      }
    };

    await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: '+${widget.countryCode}${widget.mobileNumber}',
        timeout: const Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }
  List mobileList= [];
  uploadDataa(String name) async {
    List<String> splitList = name.split(' ');
    for (int i = 0; i < splitList.length; i++) {
      for (int j = 0; j < splitList[i].length + i; j++) {
        mobileList.add(splitList[i].substring(0, j).toLowerCase());
      }
    }
  }

  void _onFormSubmitted() async {
    String code = otp!.trim();

    if (code.length == 6) {
     // _playAnimation();
      AuthCredential _authCredential = PhoneAuthProvider.credential(
          verificationId: _verificationId, smsCode: code);

      _firebaseAuth
          .signInWithCredential(_authCredential)
          .then((UserCredential credential) async {
        if (credential.user != null) {
          // SettingProvider settingsProvider =
          // Provider.of<SettingProvider>(context, listen: false);

          setSnackbar("Otp Verified Successfully",context);

          String uid = credential.user!.uid;

          String fullMobile = "+"+widget.countryCode!+widget.mobileNumber!;

          uploadDataa(fullMobile);

          UserModel newUser = UserModel(
            uid: uid,
            mobile: "+" + widget.countryCode!+widget.mobileNumber!,
            fullname: "",
            profilepic: "",
            mobileList: mobileList
          );
          await FirebaseFirestore.instance.collection("users").doc(uid).set(
              newUser.toMap()).then((value) {
            print("New user created");
            Navigator.popUntil(context, (route) => route.isFirst);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>CompleteProfile(userModel: newUser,
              firebaseUser: credential.user!,)));


          });

        } else {
          setSnackbar("Error validating OTP, try again",context);
         // await buttonController!.reverse();
        }
      }).catchError((error) async {
        setSnackbar("wrong otp",context);


      });
    } else {
      setSnackbar("Please enter otp",context);
    }
  }

  Widget verifyBtn() {
    return GestureDetector(
      onTap: (){
       _onFormSubmitted();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15,vertical: 8),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text("Submit",style: TextStyle(color: Colors.white,fontSize: 17),),
      ));
  }

}
