import 'dart:io';
import 'package:flutter/material.dart';
import 'package:kabootr_app/AppEntity/Models.dart';
import 'package:kabootr_app/AppEntity/utils.dart';
import 'package:kabootr_app/AppEntity/utils2.dart';
import 'package:kabootr_app/Screens/PhotoView.dart';
import 'package:kabootr_app/Services/Database.dart';

class BuildTextField extends StatelessWidget {
  final ChatMessages chatMessage;
  final String uid;
  final String replyMessage;
  final Function showReplyMessage;
  BuildTextField({this.chatMessage, this.uid, this.replyMessage, this.showReplyMessage});

  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void sendMessage(String msg , [String dateTime = '']) async {
      await DatabaseService(uid: chatMessage.chatID).updatechatMessage(
          ChatMessages(
              chatID: chatMessage.chatID,
              chatMessage: encodeChat(chatMessage.chatMessage, uid, msg, dateTime)));
      textController.clear();
    }

    return Card(
      color: Theme.of(context).primaryColor,
      elevation: 2.0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          replyMessage == '' || replyMessage == null ? SizedBox(height: 0.0,): Row(
            children: [
              IconButton(
                icon: Icon(Icons.reply),
                onPressed: () {},
              ),
              Expanded(
                child: Text(
                  replyMessage
                ),
              ),
              IconButton(
                icon: Icon(Icons.cancel),
                onPressed: () {
                  showReplyMessage('');
                },
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.emoji_emotions),
                onPressed: () {},
              ),
              Expanded(
                child: TextField(
                  textCapitalization: TextCapitalization.sentences,
                  controller: textController,
                  decoration:
                      InputDecoration.collapsed(hintText: 'Type a message'),
                ),
              ),
              IconButton(
                icon: Icon(Icons.photo_library_outlined),
                onPressed: () async {
                  File image = await getImageFromDevice(false);
                  if(image != null){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                      builder: (BuildContext context) => ImageViewer(
                            image: image,
                            uploadImage: sendMessage,
                            nameOfImage: ''
                      )));
                  }
                },
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  if(textController.text == '' || textController.text == null) return null;
                  if(replyMessage == '' || replyMessage == null){
                    sendMessage(textController.text);
                  }
                  else{
                    sendMessage(textController.text + replyMessageFormat + replyMessage);
                    showReplyMessage('');
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
