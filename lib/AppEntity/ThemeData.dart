import 'package:flutter/material.dart';

class ThemeBuilder extends StatefulWidget {
  final Widget Function(BuildContext context, bool darkThme, String title) builder;
  final bool darktheme;
  final String title;
  ThemeBuilder({@required this.builder, this.darktheme, this.title});

  @override
  _ThemeBuilderState createState() => _ThemeBuilderState();

  static _ThemeBuilderState of(BuildContext context)
  {
    return context.findAncestorStateOfType<_ThemeBuilderState>();
  }
}

class _ThemeBuilderState extends State<ThemeBuilder> {
  bool darkTheme;
  String appTitle;
  @override
    void initState() {
      // TODO: implement initState
      darkTheme = widget.darktheme;
      appTitle = widget.title;
      if(mounted)
        setState(() {});
      super.initState();
    }
  @override
  Widget build(BuildContext context) {
    return widget.builder(context, darkTheme, appTitle);
  }

  getTheme(){
    return darkTheme;
  }

  String getName(){
    return appTitle;
  }
  
  setstateExplicitly(){
    setState(() {});
  }

  changeName(String name){
    setState(() { appTitle = name; });
  } 

  changeTheme(){
    setState(() { darkTheme = !darkTheme; });
  }
}