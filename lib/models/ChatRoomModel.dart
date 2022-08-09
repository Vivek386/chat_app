class ChatRoomModel{

  String? chatRoomId;
  String? lastmsg;
  String? contactNo;
  Map<String,dynamic>? participantsmap;
  List? participants;
  DateTime? chatDateTime;

  ChatRoomModel({this.chatRoomId,this.participants,this.lastmsg,
    this.chatDateTime,this.participantsmap,this.contactNo
  });

  ChatRoomModel.fromMap(Map<String,dynamic> data){
    chatDateTime = data["chatDateTime"].toDate();
    chatRoomId = data["chatRoomId"];
    lastmsg = data["lastmsg"];
    participants = data["participants"];
    participantsmap = data["participantsmap"];
    contactNo = data["contactNo"];
  }

  Map<String,dynamic>toMap() {
    return {
      "chatDateTime": chatDateTime,
      "chatRoomId" : chatRoomId,
      "participants" : participants,
      "lastmsg": lastmsg,
      "participantsmap": participantsmap,
      "contactNo": contactNo
    };
  }
}