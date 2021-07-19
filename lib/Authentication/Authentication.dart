import 'package:flutter/material.dart';
import 'package:kabootr_app/AppEntity/utils.dart';
import 'package:kabootr_app/Authentication/Register.dart';
import 'package:kabootr_app/Authentication/SignIn.dart';
import 'package:kabootr_app/Screens/Loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authentication extends StatefulWidget {
  final String title;
  Authentication({this.title});
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  
  bool isLoading;
  bool isRegister;
  String passkey;
  String imgurl;

  void toggleScreen(){
    setState(() { isRegister = !isRegister; });
  }

  initializeSharedPreferences() async{
    isLoading = true;
    var sharedprefs = await getSharedPreferences();
    imgurl = sharedprefs[defaultImageUrl];
    passkey = sharedprefs[defaultPassKey];
    if(passkey == ''){
      passkey = 'dhiman';
      var prefs = await SharedPreferences.getInstance();
      prefs.setString(defaultImageUrl, imgurl);
      prefs.setString(defaultPassKey, passkey);
      prefs.setString(defaultAppTitle, 'Pizzen');
      prefs.setBool(sharedPrefDarkTheme, false);
      prefs.setInt(defaultFontSize, 0);
    }
    setState(() { isLoading = false;});
    
  }
  @override
    void initState() {
      // TODO: implement initState
      isRegister = false;
      initializeSharedPreferences();
      super.initState();
    }
  @override
  Widget build(BuildContext context) {
    return isLoading ? Loading() : GestureDetector(
      onTap: (){
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
          actions: [
            FlatButton.icon(
              icon: Icon(!isRegister ? Icons.app_registration: Icons.login),
              label: Text(!isRegister ? 'Register': 'Login'),
              onPressed: toggleScreen
            )
          ],
        ),
        body: isRegister ? Registration(imgageUrl: imgurl, passkey: passkey,) : SignIn()
      ),
    );
  }
}