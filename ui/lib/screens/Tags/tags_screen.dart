import 'package:business/business.dart';
import 'package:flutter/material.dart';
import 'package:ui/components/TagChip.dart';

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
    _fetchCategories();
  }

  void _fetchCategories() {
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
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        itemCount: _tags.length,
        itemBuilder: (context, index) {
          Tag tag = _tags.elementAt(index);
          return ListTile(
            title: TagChip(tag),
            dense: true,
          );
        },
      ),
    );
  }
}
