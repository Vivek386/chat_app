class UserModel{
  String? uid;
  String? fullname;
  String? mobile;
  String? profilepic;
  List? indexList;
  List? mobileList;

  UserModel({this.uid,this.fullname,this.mobile,this.profilepic,this.indexList,this.mobileList});

  UserModel.fromMap(Map<String,dynamic> data){
    uid = data["uid"];
    fullname = data["fullname"];
    mobile = data["mobile"];
    profilepic = data["profilepic"];
    indexList = data["indexList"];
    mobileList = data["mobileList"];
  }

  Map<String,dynamic>toMap() {
    return {
    "uid" : uid,
    "fullname" : fullname,
    "mobile" : mobile,
    "profilepic" : profilepic,
      "indexList": indexList,
      "mobileList": mobileList
    };
}
}