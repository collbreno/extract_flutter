import 'package:flutter/material.dart';

class MaterialColors {
  static List<Color> colorList = [
    Colors.pink, Colors.red, Colors.deepOrange, Colors.orange, 
    Colors.amber, Colors.yellow, Colors.lime, Colors.lightGreen, 
    Colors.green, Colors.teal, Colors.cyan, Colors.lightBlue, 
    Colors.blue, Colors.indigo, Colors.purple, Colors.deepPurple, 
    Colors.blueGrey, Colors.brown, Colors.grey
  ];

  static List<Color> getAllColorTones(MaterialColor color){
    return [500, 600, 700, 800, 900].map((tone){
      return color[tone];
    }).toList();
  }

  static List<Color> getAllColorAndTones(){
    var list = List<Color>();
    colorList.forEach((color){
      getAllColorTones(color).forEach((newColor){
        list.add(newColor);
      });
    });
    list.add(Colors.white);
    list.add(Colors.black);
    return list;
  }

}