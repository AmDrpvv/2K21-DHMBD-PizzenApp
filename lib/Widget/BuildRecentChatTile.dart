import 'package:flutter/material.dart';
import 'package:kabootr_app/AppEntity/Models.dart';
import 'package:kabootr_app/Screens/ChatScreen.dart';
import 'package:kabootr_app/Services/Database.dart';

class RecentChatTile extends StatefulWidget {
  final String userID;
  final Sender sender;
  RecentChatTile({@required this.sender, this.userID});

  @override
  _RecentChatTileState createState() => _RecentChatTileState();
}

class _RecentChatTileState extends State<RecentChatTile> {
  User user;
  bool isLoading;
  bool isFavorite= false;
  initializeData() async{
    isLoading = true;
    user = await DatabaseService(uid: widget.sender.id).getOnlyUser();
    setState(() { isLoading = false;});
  }
  @override
    void initState() {
      // TODO: implement initState
      isLoading = true;
      isFavorite= false;
      initializeData();
      super.initState();
    }
  @override
  Widget build(BuildContext context) {
    
    return isLoading ? Container(height: 55.0,): Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: ListTile(
            tileColor: Theme.of(context).primaryColor,
            onTap: () => Navigator.push(context, MaterialPageRoute(
              builder: (BuildContext context )=> ChatScreen(
                sender: widget.sender,
                senderUser : user,
                userID : widget.userID,
              ))),
            leading: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(user.imgUrl),
                  fit: BoxFit.cover
                ),
                color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0)
                )
              ),
              height: 45.0,
              width: 45.0,
            ),
            title: Text(user.name, style: TextStyle(
              fontSize: 18.0, fontWeight: FontWeight.w500),),
            subtitle: Text(user.about,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            ),
            trailing: IconButton(
              icon: isFavorite ? Icon(Icons.favorite): Icon(Icons.favorite_border_outlined),
              color: Theme.of(context).accentColor,
              onPressed: (){
                setState(() { isFavorite = !isFavorite;});
              },
            )
          ),
        );
  }
}