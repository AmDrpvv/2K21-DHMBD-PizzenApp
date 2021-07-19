import 'package:flutter/material.dart';


class NoInternet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.wifi_off),
              SizedBox(width: 5.0,),
              Text('Opps!!! No Internet.')
            ],
            )
        ),
      ),
    );
  }
}