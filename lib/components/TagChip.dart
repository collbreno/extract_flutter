import 'package:flutter/material.dart';

class TagChip extends StatelessWidget {
  TagChip({@required this.title, @required this.color, this.icon, @required this.textColor});

  final String title;
  final Color color;
  final IconData icon;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    // return Text(title);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        color: color
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          renderIcon(),
          Text(title, style: TextStyle(color: textColor, fontSize: 12, fontWeight: FontWeight.w600),)
        ],
      ),
    );
  }

  Widget renderIcon(){
    if (icon == null) return Container();
    return Padding(
      padding: EdgeInsets.only(right: 6),
      child: Icon(icon, size: 16, color: textColor,),
    );
  }
}