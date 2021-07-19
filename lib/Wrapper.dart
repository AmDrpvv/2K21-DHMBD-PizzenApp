import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Authentication/Authentication.dart';
import 'Screens/HomePage.dart';


class Wrapper extends StatelessWidget {
  final String title;
  Wrapper({this.title});
  @override
  Widget build(BuildContext context) {
    final userID = Provider.of<String>(context);
    if(userID == null) return Authentication(title: title,);
    else return Homepage(userID: userID, title: title,);
  }
}