import 'package:extract_flutter/components/TagChip.dart';
import 'package:extract_flutter/models/Tag.dart';
import 'package:extract_flutter/screens/AddTag/newTagDialog.dart';
import 'package:flutter/material.dart';
import 'package:extract_flutter/services/repositories/TagRepository.dart';

class AddTagScreen extends StatefulWidget {
  AddTagScreen(this.tags);

  final List<Tag> tags;

  @override
  _AddTagScreenState createState() => _AddTagScreenState();
}

class _AddTagScreenState extends State<AddTagScreen> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final TagRepository _tagRepository = TagRepository();
  List<Tag> _tags = List<Tag>();
  List<Tag> _selectedTags = List<Tag>();
  bool _fabVisible = false;
  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
     _selectedTags = widget.tags; 
    });
    _fetchTagsFromDatabase();
    _textEditingController.addListener((){
      setState(() {
        _fabVisible = _textEditingController.text != ""; 
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("Adicionar Tag"),
      ),
      floatingActionButton: Visibility(
        visible: _fabVisible,
        child: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => _showNewTagDialog(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          children: <Widget>[
            TextField(
              onSubmitted: (string) => _showNewTagDialog(context),
              controller: _textEditingController,
              decoration: InputDecoration(
                icon: Icon(Icons.edit),
                labelText: 'Adicionar Tag',
                hintText: "Pesquise por uma tag",
                border: UnderlineInputBorder()
              ),
            ),
            Flexible(
              child: _renderListView()
            )
          ],
        ),
      ),
    );
  }

  List<int> _getSelectedIds(){
    return _selectedTags.map((tag) => tag.id).toList();
  }

  Widget _renderListView(){
    return RefreshIndicator(
      onRefresh: _fetchTagsFromDatabase,
      child: Scrollbar(
        child: ListView.builder(
          itemCount: _tags.length,
          itemBuilder: (context, index){
            return _renderTag(_tags.elementAt(index), index);
          },
        ),
      ),
    );
  }

  Future<void> _fetchTagsFromDatabase() {
    return _tagRepository.getTags()
      .then((tags){
        tags.sort((tag1, tag2){
          var selectedIds = _getSelectedIds();
          if (!selectedIds.contains(tag1.id)) return 1;
          if (!selectedIds.contains(tag2.id)) return -1;
          return 0;
        });
        setState(() {
         _tags = tags; 
        });
      });
  }
  
  void _showSnackbar(String text) {
    print("devia mostrar uma snackbar");
    print(text);
    final snackbar = SnackBar(content: Text(text),);
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }

  void _showNewTagDialog(BuildContext context){
    showDialog(
      context: context,
      builder: (context){
        return NewTagDialog(
          title: _textEditingController.text,
          onSave: (tag){
            _tagRepository.insertTag(tag)
              .then((result){
                _fetchTagsFromDatabase();
                if (result > 0) {
                  tag.id = result;
                  setState(() {
                    _selectedTags.add(tag);
                    _textEditingController.text = '';
                  });
                  _showSnackbar("Tag criada com sucesso!");
                }
                else {
                  _showSnackbar("Algo deu errado ao criar a tag :(");
                }
              });
          }
        );
      }
    );
  }

  Widget _renderTag(Tag tag, int index) {
    bool isSelected = _getSelectedIds().contains(tag.id);
    return Hero(
      tag: tag.id,
      child: ListTile(
        key: Key(tag.id.toString()),
        dense: true,
        selected: isSelected,
        onTap: () {
          if  (isSelected ) {
            setState(() {
              _selectedTags.removeAt(index);
            });
          }
          else {
            setState(() {
              _selectedTags.add(tag);
            });
          }
        },
        title: TagChip(tag),
        trailing: Icon(isSelected? Icons.check : null),
      ),
    );
  }
}