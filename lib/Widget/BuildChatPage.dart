import 'package:flutter/material.dart';
import 'package:kabootr_app/AppEntity/Models.dart';
import 'package:kabootr_app/AppEntity/utils.dart';
import 'package:kabootr_app/Screens/Loading.dart';
import 'package:kabootr_app/Services/Database.dart';
import 'package:kabootr_app/Widget/DisplayChat.dart';
import 'BuildTextField.dart';

class BuildChatPage extends StatefulWidget {
  final Sender sender;
  final String userID;
  BuildChatPage({this.sender, this.userID});

  @override
  _BuildChatPageState createState() => _BuildChatPageState();
}

class _BuildChatPageState extends State<BuildChatPage> {
  String replymsg;

  void showReplyMessage(String replyMessage){
    setState(() {
      replymsg = replyMessage;
    });
  }
  @override
    void initState() {
      // TODO: implement initState
      replymsg = '';
      super.initState();
    }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ChatMessages>(
        stream: DatabaseService(uid: widget.sender.chatMessageUID).chatMessagesStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Loading();
          } else {
            List<Message> msgList = decodeChat(snapshot.data.chatMessage);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    shrinkWrap: true,
                    padding:
                        EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                    itemCount: msgList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return DisplayChat(
                        message: msgList[msgList.length - index -1],
                        isMe: msgList[msgList.length - index -1].senderID == widget.userID,
                        showReplyMessage: showReplyMessage,
                      );
                    },
                  ),
                  
                ),
                BuildTextField(chatMessage: snapshot.data,uid: widget.userID,
                replyMessage: replymsg,
                showReplyMessage: showReplyMessage,
                )
              ],
            );
          }
        });
  }
}
