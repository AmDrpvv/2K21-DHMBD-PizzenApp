import 'package:flutter/material.dart';
import 'package:kabootr_app/AppEntity/Models.dart';
import 'package:kabootr_app/AppEntity/utils.dart';
import 'package:kabootr_app/Screens/HomePage.dart';
import 'package:kabootr_app/Screens/PhotoView.dart';
import 'package:kabootr_app/Services/DeleteAccount.dart';

class DetailsScreen extends StatelessWidget {
  final User senderUser;
  final String userID;
  final Sender sender;
  DetailsScreen({@required this.senderUser, this.userID, this.sender});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Card(
              elevation: 5.0,
              color: Theme.of(context).primaryColor,
              margin: EdgeInsets.all(20.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(20.0),
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                        builder: (BuildContext context) => ImageViewer(
                          nameOfImage: 'img_${senderUser.uid}',
                          url: senderUser.imgUrl,
                        ))),
                      child: CircleAvatar(
                          radius: 65.0,
                          backgroundColor: Theme.of(context).accentColor,
                          backgroundImage: NetworkImage(senderUser.imgUrl),
                        ),
                    ),
                  ),
                  Text(
                    senderUser.name,
                    style: TextStyle(
                        fontSize: 24.0, color: Theme.of(context).accentColor),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    'Phone Number',
                    style: TextStyle(
                      fontSize: 12.0,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    '+91 '+ senderUser.phoneNo,
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    'About',
                    style: TextStyle(
                      fontSize: 12.0,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      senderUser.about,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  Text(
                    'Block',
                    style: TextStyle(fontSize: 18.0, color: Colors.red),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  GestureDetector(
                    onTap: (){
                      showDialog(context: context,
                      builder: (context) => AlertDialog(
                        title: Text('kick Sender'),
                        content: Text('Do you really want to Kick '+
                        'this Sender\nYou can not undo this action'),
                        actions: [
                          FlatButton(
                            child: Text('Kick'),
                            onPressed: () async {
                              try {
                                var prefs = await getSharedPreferences();

                                DeleteAccount(userID: userID).deleteSenderDatabase(sender: sender);
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                  builder: (BuildContext context) => Homepage(
                                    title: prefs[defaultAppTitle],
                                    userID: userID,
                                  )));
                              } catch (e) {
                                Navigator.pop(context);
                                print('error in kicking sender : $e');
                              }
                              
                            },
                          )
                        ],
                      )
                      );
                    },
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        'Kick',
                        style: TextStyle(fontSize: 18.0, color: Colors.red),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    'Report',
                    style: TextStyle(fontSize: 18.0, color: Colors.red),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  }
}