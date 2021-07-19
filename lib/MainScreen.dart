import 'package:flutter/material.dart';
import 'package:kabootr_app/Services/Auth.dart';
import 'package:provider/provider.dart';
import 'Wrapper.dart';

class MainScreen extends StatelessWidget {
  final String title;
  MainScreen({this.title});
  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      value: AuthService().userStream,
      child: Wrapper(title : title),
    );
  }
}