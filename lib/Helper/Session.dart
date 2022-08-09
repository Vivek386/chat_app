import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:shimmer/shimmer.dart';


Future<bool> isNetworkAvailable() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    return true;
  } else if (connectivityResult == ConnectivityResult.wifi) {
    return true;
  }
  return false;
}


String? validateMob(String value, String? msg1, String? msg2) {
  if (value.isEmpty) {
    return msg1;
  }
  if (value.length < 6) {
    return msg2;
  }
  return null;
}

String? validateCountryCode(String value, String msg1, String msg2) {
  if (value.isEmpty) {
    return msg1;
  }
  if (value.isEmpty) {
    return msg2;
  }
  return null;
}

getDeviceHeight(BuildContext context){
  double deviceHeight = MediaQuery.of(context).size.height;
  return deviceHeight;
}

getDeviceWidth(BuildContext context){
  double deviceWidth = MediaQuery.of(context).size.width;
  return deviceWidth;
}

setSnackbar(String msg ,BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      msg,
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.black),
    ),
    backgroundColor: Colors.white60,
    elevation: 1.0,
  ));
}

Widget shimmer(BuildContext context) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
    child: Shimmer.fromColors(
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
      child: SingleChildScrollView(
        child: Column(
          children: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
              .map((_) => Padding(
            padding: const EdgeInsetsDirectional.only(bottom: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 80.0,
                  height: 80.0,
                  color: Colors.white,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 18.0,
                        color: Colors.white,
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.symmetric(vertical: 5.0),
                      ),
                      Container(
                        width: double.infinity,
                        height: 8.0,
                        color: Colors.white,
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.symmetric(vertical: 5.0),
                      ),
                      Container(
                        width: 100.0,
                        height: 8.0,
                        color: Colors.white,
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.symmetric(vertical: 5.0),
                      ),
                      Container(
                        width: 20.0,
                        height: 8.0,
                        color: Colors.white,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ))
              .toList(),
        ),
      ),
    ),
  );
}