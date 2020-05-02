import 'package:extract_flutter/screens/Home/homeScreen.dart';
import 'package:extract_flutter/services/database/dbHelper.dart';
import 'package:flutter/material.dart';
import 'package:appspector/appspector.dart';



void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DbHelper().database;
  runAppSpector();
  runApp(MaterialApp(home: HomeScreen()));

}

void runAppSpector(){
  final config = Config()..androidApiKey='android_ZTVhOGJkNzAtMjk1Zi00MWEwLWIwNjItYWZkYjVjODIxMzUz';
  AppSpectorPlugin.run(config);
}

