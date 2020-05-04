import 'package:extract_flutter/components/PickerDialog.dart';
import 'package:extract_flutter/models/Tag.dart';
import 'package:extract_flutter/services/colors.dart';
import 'package:extract_flutter/services/icons.dart';
import 'package:flutter/material.dart';
import 'package:extract_flutter/components/TagChip.dart';

class NewTagDialog extends StatefulWidget {
  NewTagDialog({@required this.title, @required this.onSave});

  final String title;
  final void Function(Tag) onSave;

  @override
  _NewTagDialogState createState() => _NewTagDialogState();
}

class _NewTagDialogState extends State<NewTagDialog> {

  Color _selectedColor = Colors.grey[400];
  Color _selectedTextColor = Colors.black;
  IconData _selectedIcon;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Criar nova tag"),
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 24, bottom: 6),
            child: TagChip(Tag(widget.title, _selectedColor, _selectedTextColor, _selectedIcon)),
          ),
          ListTile(
            onTap: () => showColorPicker(context, false),
            title: Text("Selecione a cor"),
            trailing: Icon(Icons.arrow_drop_down),
          ),
          ListTile(
            onTap: () => showColorPicker(context, true),
            title: Text("Selecione a cor do texto"),
            trailing: Icon(Icons.arrow_drop_down),
          ),
          ListTile(
            onTap: () => showIconPicker(context),
            title: Text("Selecione o ícone"),
            trailing: Icon(Icons.arrow_drop_down),
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancelar".toUpperCase()),
        ),
        FlatButton(
          onPressed: () => _saveTag(context),
          child: Text("Salvar".toUpperCase()),
        ),
      ],
    );
  }

  void _saveTag(BuildContext context){
    Tag tag = Tag(widget.title, _selectedColor, _selectedTextColor, _selectedIcon);
    widget.onSave(tag);
    Navigator.pop(context);
  }

  void showIconPicker(BuildContext context){
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context){
        return PickerDialog<IconData>(
          items: materialIconList.values.toList(),
          onItemSelected: (icon){
            setState(() {
             _selectedIcon = icon; 
            });
          },
          title: "Selecione o ícone",
          columns: 4,
          onRemove: () {
            setState(() {
             _selectedIcon = null; 
            });
          },
          renderer: (icon){
            return Container(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(icon, color: _selectedTextColor,),
                  ),
                  decoration: ShapeDecoration(
                    color: _selectedColor,
                    shape: CircleBorder()
                  ),
              );
          },
        );
      }
    );
  }

  void showColorPicker(BuildContext context, bool isTextColor){
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context){
        return PickerDialog<Color>(
          items: MaterialColors.getAllColorAndTones(),
          onItemSelected: (color){
            if (isTextColor) {
              setState(() {
                _selectedTextColor = color; 
              });
            }
            else {
              setState(() {
               _selectedColor = color; 
              });
            }
          },
          title: "Selecione a cor",
          columns: 5,
          renderer: (color){
            return Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  child: null,
                  decoration: ShapeDecoration(
                    color: color,
                    shape: CircleBorder(side: BorderSide(width: 0.5, color: Colors.black))
                  ),
                ),
              );
          },
        );
      }
    );
  }
}