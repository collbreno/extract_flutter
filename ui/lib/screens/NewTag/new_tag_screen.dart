import 'package:business/business.dart';
import 'package:flutter/material.dart';
import 'package:ui/components/TagChip.dart';
import 'package:ui/screens/NewTag/icon_picker_button.dart';
import 'package:ui/screens/NewCategory/title_text_field.dart';
import 'package:ui/screens/NewTag/color_picker_button.dart';

class NewTagScreen extends StatefulWidget {
  const NewTagScreen({
    Key key,
    this.onDispose,
    this.tag,
    this.closeOnSave = false,
  }) : super(key: key);

  final void Function() onDispose;
  final Tag tag;
  final bool closeOnSave;

  @override
  _NewTagScreenState createState() => _NewTagScreenState();
}

class _NewTagScreenState extends State<NewTagScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Tag _tag;
  TextEditingController _titleController;
  bool _titleHasError;
  TagService _tagService;

  @override
  void dispose() {
    if (widget.onDispose != null) widget.onDispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tagService = TagService();
    _tag = widget.tag ??
        Tag(
          title: "",
          textColor: Tag.DEFAULT_TEXT_COLOR,
          color: Tag.DEFAULT_COLOR,
        );
    _titleHasError = false;
    _titleController = TextEditingController();
    _titleController.text = _tag.title;
    _titleController.addListener(() {
      _tag.title = _titleController.text;
      if (_titleController.text.isNotEmpty) {
        setState(() {
          _titleHasError = false;
        });
      }
    });
  }

  void _insertTag() async {
    Tag tagToInsert = _tag;
    String keyWordOnSuccess = tagToInsert.id == null ? 'criada' : 'editada';
    String keyWordOnFail = tagToInsert.id == null ? 'criar' : 'editar';
    int response;
    if (tagToInsert.id == null) {
      response = await _tagService.insert(tagToInsert);
    } else {
      response = await _tagService.updateTag(tagToInsert);
    }
    if (response != null && response > 0) {
      _resetFields();
      SnackBar snackBar = SnackBar(
        content: Text("Tag $keyWordOnSuccess com sucesso"),
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);
      if (widget.closeOnSave) Navigator.pop(context);
    } else {
      SnackBar snackBar = SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          "Algo deu errado ao $keyWordOnFail tag",
          style: TextStyle(color: Colors.white),
        ),
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }
  }

  void _resetFields() {
    setState(() {
      _titleController.text = '';
      _tag = Tag(
        textColor: Tag.DEFAULT_TEXT_COLOR,
        title: "",
        color: Tag.DEFAULT_COLOR,
      );
    });
  }

  void _checkFieldsAndInsert() {
    if (_titleController.text.isEmpty) {
      setState(() {
        _titleHasError = true;
      });
    } else {
      _insertTag();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Nova Tag"),
        backgroundColor: _tag.color,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        children: <Widget>[
          Center(child: TagChip(_tag)),
          TitleTextField(
            placeholder: "Insira o nome da tag",
            color: _tag.color,
            controller: _titleController,
            hasError: _titleHasError,
          ),
          ColorPickerButton(
            title: "Selecione a cor",
            leading: Icon(Icons.color_lens),
            onColorSelected: (Color color) {
              setState(() {
                _tag.color = color;
              });
            },
          ),
          ColorPickerButton(
            title: "Selecione a cor do texto",
            leading: Icon(Icons.format_color_text),
            onColorSelected: (Color color) {
              setState(() {
                _tag.textColor = color;
              });
            },
          ),
          IconPickerButton(
            color: _tag.color,
            textColor: _tag.textColor,
            onIconSelected: (IconData icon) {
              setState(() {
                _tag.icon = icon;
              });
            },
          ),
          Padding(
            padding: EdgeInsets.only(top: 30),
            child: RaisedButton(
              color: _tag.color,
              onPressed: _checkFieldsAndInsert,
              child: Text("Salvar".toUpperCase()),
            ),
          ),
        ],
      ),
    );
  }
}
