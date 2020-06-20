import 'dart:io';

import 'package:business/business.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class BackupScreen extends StatefulWidget {
  @override
  _BackupScreenState createState() => _BackupScreenState();
}

class _BackupScreenState extends State<BackupScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final BackupService _service = BackupService();
  File _file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Backup"),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: <Widget>[
          renderFileContent(),
          ...getButtons(),
        ],
      ),
    );
  }

  List<Widget> getButtons() {
    if (_file == null)
      return <Widget>[
        renderSelectFileButton(),
      ];
    return <Widget>[
      renderSelectFileButton(),
      renderRunButton(),
    ];
  }

  Widget renderSelectFileButton() {
    return RaisedButton(
      child: Text("Selecione o arquivo".toUpperCase()),
      onPressed: () {
        FilePicker.getFile().then((File file) {
          print('peguei o arquivo');
          print(file.path);
          setState(() {
            _file = file;
          });
        }).catchError((Object error) => print(error));
      },
    );
  }

  Widget renderRunButton() {
    return RaisedButton(
      color: Colors.blue,
      child: Text(
        "Rodar".toUpperCase(),
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        _service
            .runScript(_file.readAsStringSync())
            .then((value) => _showSnackBar('Script finalizado com sucesso'))
            .catchError((Object error) => _showSnackBar('Algo deu errado'));
      },
    );
  }

  void _showSnackBar(String text) {
    SnackBar snackBar = SnackBar(
      content: Text(
        text,
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  Widget renderFileContent() {
    if (_file == null) {
      return Text('Vazio');
    }
    return Container(
        padding: EdgeInsets.all(10),
        color: Colors.grey[200],
        child: Text(
          _file.readAsStringSync(),
        ));
  }
}
