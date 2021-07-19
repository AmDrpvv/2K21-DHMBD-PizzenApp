const String  userColumnID = 'uid';
const String userColumnName = 'name';
const String userColumnPhoneNo = 'phoneNo';
const String userColumnImgUrl = 'imgUrl';
const String userColumnAbout = 'about';

const String chatMessageColumnID = 'chatID';
const String chatMessageColumnchatMessage = 'chatMessage';


const String senderColumnID = 'id';
const String senderColumnChatID = 'ChatID';

class User{
  String uid;
  String name;
  String phoneNo;
  String imgUrl;
  String about;

  List<Sender> senders;
  User({this.name, this.phoneNo, this.uid, this.imgUrl, this.about});

  User.fromMap(Map<String, dynamic> map){
    uid = map[userColumnID] ?? '';
    name = map[userColumnName] ?? '';
    phoneNo = map[userColumnPhoneNo] ?? '';
    imgUrl = map[userColumnImgUrl] ?? '';
    about = map[userColumnAbout] ?? '';
  }

  Map<String, dynamic> toMap(){
    return {
      userColumnID : uid,
      userColumnName : name,
      userColumnPhoneNo : phoneNo,
      userColumnImgUrl : imgUrl,
      userColumnAbout : about
    };
  }
  String repr(){
    return 'User : $uid, $name, $phoneNo, $about, $imgUrl';
  }
}

class Sender{
  String id;
  String chatMessageUID;

  Sender({this.chatMessageUID,this.id});

  Sender.fromMap(Map<String, dynamic> map){
    id = map[senderColumnID] ?? '';
    chatMessageUID = map[senderColumnChatID] ?? '';
  }

  Map<String, dynamic> toMap(){
    return {
      senderColumnID : id,
      senderColumnChatID : chatMessageUID,
    };
  }

  String repr(){
    return 'sender : $id, $chatMessageUID,';
  }
}

class Message{
  String message;
  String replyMessage;
  String time;
  String senderID;

  Message({this.message, this.replyMessage,this.senderID,this.time});


}

class ChatMessages{
  String chatID;
  String chatMessage;
  ChatMessages({this.chatMessage, this.chatID});

  ChatMessages.fromMap(Map<String, dynamic> map){
    chatID = map[chatMessageColumnID] ?? '';
    chatMessage = map[chatMessageColumnchatMessage] ?? '';
  }

  Map<String, dynamic> toMap(){
    return {
      chatMessageColumnID : chatID,
      chatMessageColumnchatMessage : chatMessage,
    };
  }
  String repr(){
    return 'ChatMessage : $chatID, $chatMessage';
  }
}