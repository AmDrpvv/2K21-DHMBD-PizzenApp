import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kabootr_app/AppEntity/utils.dart';
import 'package:kabootr_app/CheckConn.dart';
import 'AppEntity/ThemeData.dart';
import 'AppEntity/const.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  var prefs = await getSharedPreferences();
  bool darkTheme = prefs[sharedPrefDarkTheme];
  String title = prefs[defaultAppTitle];
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: darkTheme ? Colors.black : Colors.white
  ));
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(MyApp(darkTheme: darkTheme, title: title,));
  });
}

class MyApp extends StatelessWidget {
  final bool darkTheme;
  final String title;
  MyApp({this.darkTheme, this.title});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(
      darktheme: darkTheme,
      title: title,
      builder: (context, darkTheme, title){
        return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: darkTheme ? Constants.darkTheme : Constants.lightTheme,
        darkTheme: Constants.darkTheme,
        home: CheckConn(title: title),
      );
      },
    );
  }
}
