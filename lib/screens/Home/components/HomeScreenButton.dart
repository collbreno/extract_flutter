import 'package:flutter/material.dart';

class HomeScreenButton extends StatelessWidget {
  HomeScreenButton({ @required this.onPress, @required this.icon, @required this.title });

  final Function onPress;
  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      onPressed: this.onPress,
      color: Colors.blue,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Icon(this.icon, color: Colors.white, size: 28,),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Hero(tag: this.title.toUpperCase(), child: Text(this.title.toUpperCase(), textAlign: TextAlign.center, style: TextStyle(color: Colors.white, decoration: TextDecoration.none, fontSize: 16),)),
          ),
        ],
      ),
    );
  }
}