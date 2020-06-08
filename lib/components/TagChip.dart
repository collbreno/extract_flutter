import 'package:extract_flutter/models/Tag.dart';
import 'package:flutter/material.dart';

class TagChip extends StatelessWidget {
  TagChip(this.tag);

  final Tag tag;
  static double height = 20;

  @override
  Widget build(BuildContext context) {
    // return Text(title);
    return SizedBox(
      height: height,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 6),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          color: tag.color
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            renderIcon(),
            Text(tag.title, style: TextStyle(color: tag.textColor, fontSize: 11, fontWeight: FontWeight.w600),)
          ],
        ),
      ),
    );
  }

  Widget renderIcon(){
    if (tag.icon== null) return Container();
    return Padding(
      padding: EdgeInsets.only(right: 6),
      child: Icon(tag.icon, size: 14, color: tag.textColor,),
    );
  }
}