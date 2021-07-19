import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:kabootr_app/AppEntity/Models.dart';
import 'package:kabootr_app/AppEntity/utils.dart';
import 'package:kabootr_app/Screens/PhotoView.dart';


class DisplayChat extends StatelessWidget {
  final bool isMe;
  final Message message;
  final Function showReplyMessage;
  DisplayChat({this.isMe, this.message, this.showReplyMessage});

  void replyMessage(){
    String data = isMe ? 'you ;  ': 'other ;  ';
    int len = message.message.length > 30 ? 30 : message.message.length;
    showReplyMessage(data + '${message.message.substring(0,len)}');
  }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    Widget messageBody(String msg){
      if(msg.startsWith(fileAttachMsg))
      {
        return GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(
              builder: (BuildContext context )=> ImageViewer(
                nameOfImage: '_',
                url: msg.replaceFirst(fileAttachMsg, ''),
            )));
          },
          child: Container(
            width: screenWidth*0.7,
            //height: screenWidth*0.5,
            child: Image.network(
              message.message.replaceFirst(fileAttachMsg, ''),
              fit: BoxFit.cover,
            ),
          ),
        );
      }
      else {
        return Text(
          msg,
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.justify
        );
      }
    }

    Widget body(){
    return Container(
      margin: isMe ? EdgeInsets.only(top: 10, left: screenWidth*0.2)
      :EdgeInsets.only(top: 10, right: screenWidth*0.2),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end
        : CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          message.replyMessage == '' ? SizedBox(height : 0.0) : Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              border: Border.all(
                color: isMe ? Colors.blueGrey[300]: Theme.of(context).accentColor,
                style: BorderStyle.solid,
                width: 2.0
              )
            ),
            padding: EdgeInsets.all(5.0),
            margin: isMe ? EdgeInsets.only(right: 5.0)
            :EdgeInsets.only(left: 5.0),
            child: Text(
              message.replyMessage,
              style: TextStyle(
                color: isMe ? Colors.blueGrey[300]: Theme.of(context).accentColor,
              ),
            )
          ),
          Bubble(
            alignment: isMe ? Alignment.topRight : Alignment.topLeft,
            nip: isMe ? BubbleNip.rightBottom : BubbleNip.leftBottom,
            color: isMe ? Colors.blueGrey[300]: Theme.of(context).accentColor,
            child: messageBody(message.message),
          ),
          Container(
              padding: isMe ? EdgeInsets.only(right: 10.0, top: 5.0)
              :EdgeInsets.only(left: 10.0, top: 5.0),
              child: Text(message.time.substring(0,5))
            ),
        ],
      ),
    );
    }

    Widget displayMsg(){
      
      return isMe ? 
      Slidable(
        actionPane: SlidableScrollActionPane(),
        actionExtentRatio: 0.15,
        child: body(),
        
        secondaryActions: <Widget>[
          
          IconSlideAction(
            icon: Icons.reply,
            color: Theme.of(context).scaffoldBackgroundColor,
            onTap: () => replyMessage(),
          ),
          IconSlideAction(
            icon: Icons.archive,
            color: Theme.of(context).scaffoldBackgroundColor,
            onTap: () => print('Archive'),
          ),
        ],
      )
        
      :Slidable(
        actionPane: SlidableScrollActionPane(),
        actionExtentRatio: 0.15,
        child: body(),
        
        actions: <Widget>[
          
          IconSlideAction(
            icon: Icons.archive,
            color: Theme.of(context).scaffoldBackgroundColor,
            onTap: () => print('Archive'),
          ),
          IconSlideAction(
            icon: Icons.reply,
            color: Theme.of(context).scaffoldBackgroundColor,
            onTap: () => replyMessage(),
          ),
        ],
      );
    }

    return displayMsg();

  }
}