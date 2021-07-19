import 'package:flutter/material.dart';
import 'package:kabootr_app/AppEntity/Models.dart';
import 'package:kabootr_app/AppEntity/ThemeData.dart';
import 'package:kabootr_app/AppEntity/utils.dart';
import 'package:kabootr_app/Screens/ProfileScreen.dart';
import 'package:kabootr_app/Services/Auth.dart';
import 'package:kabootr_app/Services/DeleteAccount.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomDrawer extends StatelessWidget {
  final User user;
  const CustomDrawer({this.user});

  changeTitle(BuildContext context, String name) async{
    ThemeBuilder.of(context).changeName(name);
    var prefs = await SharedPreferences.getInstance();
    prefs.setString(defaultAppTitle, ThemeBuilder.of(context).getName());
    Navigator.pop(context);
  }
  @override
  Widget build(BuildContext context) {
    //final user = Provider.of<User>(context);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).accentColor,
                  radius: 40.0,
                  backgroundImage: NetworkImage(user.imgUrl),
                ),
                SizedBox(height: 10.0,),
                Text(
                user.name,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.normal
                ),
            ),
              ],
            )
          ),
          ListTile(
            leading: Icon(Icons.brightness_low),
            title: Text(
              "Dark Mode",
            ),
            trailing: Switch(
              value: ThemeBuilder.of(context).getTheme(),
              activeColor: Colors.black,
              onChanged: (bool value)async {
                ThemeBuilder.of(context).changeTheme();
                var prefs = await SharedPreferences.getInstance();
                prefs.setBool(sharedPrefDarkTheme, ThemeBuilder.of(context).getTheme());
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Profile'),
            onTap: () =>Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context )=> ProfileScreen(user: user,))),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Log Out'),
            onTap: (){
              AuthService().signout();
            },
          ),
          ListTile(
            leading: Icon(Icons.delete_forever),
            title: Text('Delete Account'),
            onTap: (){
              showDialog(context: context,
              builder: (BuildContext context)=> AlertDialog(
                actions: [
                  FlatButton(child: Text('Delete Account'),
                  onPressed: ()async{
                    Navigator.pop(context);
                    Navigator.pop(context);
                    DeleteAccount(userID: user.uid).deleteUserAccount();
                  },
                  )
                ],
                title: Text('Delete Account'),
                content: Text('Do you want to Permanently Delete this Account ???'),
              )
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.title),
            title: Text('Kabootr'),
            onTap: () => changeTitle(context, 'Kabootr'),
          ),
          ListTile(
            leading: Icon(Icons.title),
            title: Text('Shukr'),
            onTap: () => changeTitle(context, 'Shukr'),
          ),
          ListTile(
            leading: Icon(Icons.title),
            title: Text('Pizzen'),
            onTap: () => changeTitle(context, 'Pizzen'),
          ),
        ],
      ),
    );
  }
}
