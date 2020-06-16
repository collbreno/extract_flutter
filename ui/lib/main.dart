import 'package:flutter/material.dart';
import 'package:appspector/appspector.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'screens/Home/homeScreen.dart';



void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting('pt_BR');
  runAppSpector();
  runApp(MaterialApp(home: HomeScreen()));

}

void runAppSpector(){
  final config = Config()..androidApiKey='android_ZTVhOGJkNzAtMjk1Zi00MWEwLWIwNjItYWZkYjVjODIxMzUz';
  AppSpectorPlugin.run(config);
}

