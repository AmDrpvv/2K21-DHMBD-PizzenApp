import 'package:flutter/material.dart';


class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      alignment: Alignment.center,
      child: Center(
        child: Container(
            width: MediaQuery.of(context).size.width*0.2,
            height: MediaQuery.of(context).size.width*0.2,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/logoA.png'),
                fit: BoxFit.fill
              )
            ),
          ),
      ),
    );
  }
}