import 'package:flutter/material.dart';
import 'package:kabootr_app/AppEntity/Models.dart';
import 'package:kabootr_app/Screens/DetailsScreen.dart';
import 'package:kabootr_app/Widget/BuildChatPage.dart';

class ChatScreen extends StatefulWidget {
  final Sender sender;
  final User senderUser;
  final String userID;
  ChatScreen({@required this.sender ,this.senderUser, this.userID});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          centerTitle: true,
          title: Text(widget.senderUser.name),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            GestureDetector(
              onTap: () =>Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context )=> DetailsScreen(
                    senderUser: widget.senderUser,
                    userID : widget.userID,
                    sender: widget.sender,
                  ))),
              child: CircleAvatar(
                backgroundImage: NetworkImage(widget.senderUser.imgUrl),
                radius: 20.0,
                backgroundColor: Theme.of(context).accentColor,
              ),
            ),
            SizedBox(width: 15.0,)
          ],
        ),
        body: BuildChatPage(sender: widget.sender, userID : widget.userID)
      ),
    );
  }
}