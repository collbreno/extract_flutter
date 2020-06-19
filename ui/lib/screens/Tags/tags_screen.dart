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
  List<Tag> _tags = <Tag>[];

  @override
  void initState() {
    super.initState();
    _fetchTags();
  }

  void _fetchTags() {
    _tagService.getTags().then((List<Tag> tags) {
      setState(() {
        _tags = tags;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tags"),
      ),
      body: ListView.builder(
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
              onSelected: (action) => _handleAction(
                context,
                action,
                _tags.elementAt(index),
              ),
              itemBuilder: (BuildContext context) {
                return [Actions.edit, Actions.delete]
                    .map(
                      (action) => PopupMenuItem<String>(
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          AppNavigator.pushNewTagScreen(context, onDispose: _fetchTags);
        },
      ),
    );
  }

  void _handleAction(BuildContext context, String action, Tag tag) {
    if (action == Actions.delete) {
      _tagService.deleteTagWithId(tag.id);
      _fetchTags();
    } else if (action == Actions.edit) {
      AppNavigator.pushNewTagScreen(
        context,
        tag: tag,
        onDispose: _fetchTags,
        closeOnSave: true,
      );
    }
  }
}

class Actions {
  static const delete = 'Deletar';
  static const edit = 'Editar';
}
