import 'package:flutter/material.dart';
import 'package:kabootr_app/AppEntity/Models.dart';
import 'package:kabootr_app/Screens/Loading.dart';
import 'package:kabootr_app/Services/Database.dart';
import 'package:kabootr_app/Widget/BuildRecentChatTile.dart';

class RecentChatScreen extends StatelessWidget {
  final String userID;
  RecentChatScreen({this.userID});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Sender>>(
      stream: DatabaseService(uid: userID).senderStream,
      builder: (context, snapshot) {
        return !snapshot.hasData ? Loading() : ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (BuildContext context, int i){
            int index = snapshot.data.length - i - 1;
            return RecentChatTile(sender: snapshot.data[index], userID : userID);
          },
        );
      }
    );
  }
}