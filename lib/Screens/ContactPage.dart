import 'package:flutter/material.dart';
import 'package:kabootr_app/AppEntity/Models.dart';
import 'package:kabootr_app/Screens/ChatScreen.dart';
import 'package:kabootr_app/Screens/Loading.dart';
import 'package:kabootr_app/Services/Database.dart';

class ContactPage extends StatelessWidget {
  final String userID;
  ContactPage({@required this.userID});

  addContact(BuildContext context, String senderID, User senderUser) async{

    Sender sender = await DatabaseService(uid: userID).getOnlySender(senderID);
    if(sender == null){
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          actions: [
            FlatButton(
              child: Text('start chatting'),
              onPressed: () async{
                try {
                  String chatId = await DatabaseService(uid: userID).getchatMessageID();
                  await DatabaseService(uid: userID).createchatMessage(
                    ChatMessages(chatID: chatId, chatMessage:  ''));
                  await DatabaseService(uid: userID).createsender(
                    Sender(
                      id: senderUser.uid,
                      chatMessageUID: chatId
                    ));
                  await DatabaseService(uid: senderID).createsender(
                    Sender(
                      id: userID,
                      chatMessageUID: chatId
                    ));
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context )=> ChatScreen(
                      sender: Sender(
                        id: senderUser.uid,
                        chatMessageUID: chatId
                      ),
                      senderUser : senderUser,
                      userID : userID
                    )));
                } catch (e) {
                  print('error in adding sender : $e');
                  Navigator.pop(context);
                }
              },
            )
          ],
          title: Text('New Chat'),
          content: Text('Do you want to start chatting with this user ? '),
        )
      );
    }
    else
    {
      Navigator.push(context, MaterialPageRoute(
        builder: (BuildContext context )=> ChatScreen(
          sender: sender,
          senderUser : senderUser,
          userID : userID
        )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<User>>(
      stream: DatabaseService(uid: userID).userListStream,
      builder: (context, snapshot) {
        return !snapshot.hasData ? Loading()
        : ListView.builder(
          padding: EdgeInsets.only(top: 20.0),
          itemCount: snapshot.data.length,
          itemBuilder: (BuildContext context, int index){
            User user = snapshot.data[index];
            return userID == user.uid ? SizedBox(height: 0.0,)
            : Card(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              color: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))
              ),
              child: Container(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width*0.3,
                      height: MediaQuery.of(context).size.width*0.3,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(user.imgUrl),
                        fit: BoxFit.cover
                      ),
                      color: Theme.of(context).accentColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0)
                      )
                    ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(user.name,
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontWeight: FontWeight.normal,
                            fontSize: 20.0
                            ),
                          ),
                          SizedBox(height: 5.0,),
                          Text('+91 '+ user.phoneNo,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16.0
                            ),
                          ),
                          SizedBox(height: 5.0,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                icon: Icon(Icons.chat),
                                color: Theme.of(context).accentColor,
                                onPressed: (){
                                  addContact(context, user.uid, user);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.call),
                                color: Theme.of(context).accentColor,
                                onPressed: (){},
                              ),
                              IconButton(
                                icon: Icon(Icons.videocam),
                                color: Theme.of(context).accentColor,
                                onPressed: (){},
                              ),
                          ],)
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      }
    );
  }
}