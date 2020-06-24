import 'package:business/business.dart';
import 'package:flutter/material.dart';
import 'package:ui/components/TagChip.dart';
import 'package:ui/helpers/navigator.dart';

class TagsScreen extends StatefulWidget {
  @override
  _TagsScreenState createState() => _TagsScreenState();
}

class _TagsScreenState extends State<TagsScreen> {
  final TagService _tagService = TagService();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Tag> _tags = <Tag>[];

  @override
  void initState() {
    super.initState();
    _fetchTags();
  }

  Future<void> _fetchTags() async {
    var tags = await _tagService.getTags();
      setState(() {
        _tags = tags;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Tags"),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchTags,
        child: Scrollbar(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 12),
            itemCount: _tags.length,
            itemBuilder: (context, index) {
              Tag tag = _tags.elementAt(index);
              return ListTile(
                title: TagChip(tag),
                dense: true,
                trailing: PopupMenuButton<String>(
                  child: IconButton(
                    icon: Icon(Icons.more_vert),
                    onPressed: null,
                  ),
                  onSelected: (action) =>
                      _handleAction(
                        context,
                        action,
                        _tags.elementAt(index),
                      ),
                  itemBuilder: (BuildContext context) {
                    return [Actions.edit, Actions.delete]
                        .map(
                          (action) =>
                          PopupMenuItem<String>(
                            child: Text(action),
                            value: action,
                          ),
                    )
                        .toList();
                  },
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          AppNavigator.pushNewTagScreen(context, onDispose: _fetchTags);
        },
      ),
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

  void _showErrorSnackBar(String text) {
    SnackBar snackBar = SnackBar(
      backgroundColor: Colors.red,
      content: Text(
        text,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void _handleAction(BuildContext context, String action, Tag tag) {
    if (action == Actions.delete) {
      _tryToDeleteTag(tag);
    } else if (action == Actions.edit) {
      _editTag(tag);
    }
  }

  void _tryToDeleteTag(Tag tag) async {
    try {
      int usages = await _tagService.getUsagesOfTag(tag.id);
      if (usages > 0)
        _showConfirmationDialog(tag, usages);
      else
        _deleteTag(tag);
    }  catch (e) {
      print(e);
      _showErrorSnackBar('Algo deu errado');
    }
  }


  void _showConfirmationDialog(Tag tag, int amount) {
    String text = amount == 1 ? 'gasto' : 'gastos';
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Tag em uso"),
          content: Text(
            "A tag está sendo usada por $amount $text. Você quer apagar assim mesmo?",
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Cancelar".toUpperCase()),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text("Deletar".toUpperCase()),
              onPressed: () {
                Navigator.pop(context);
                _deleteTag(tag);
              },
            )
          ],
        );
      },
    );
  }

  void _deleteTag(Tag tag) async {
    try {
      await _tagService.deleteTagWithId(tag.id);
      _showSnackBar("Tag deletada com sucesso");
      _fetchTags();
    } catch (error) {
      print(error);
      _showErrorSnackBar("Algo deu errado");
    }
  }

  void _editTag(Tag tag) {
    AppNavigator.pushNewTagScreen(
      context,
      tag: tag.copy(),
      onDispose: _fetchTags,
      closeOnSave: true,
    );
  }

}

class Actions {
  static const delete = 'Deletar';
  static const edit = 'Editar';
}
