import 'package:flutter/material.dart';

class PickerDialog<T> extends StatelessWidget {
  PickerDialog({
    @required this.title, 
    @required this.items, 
    @required this.renderer,
    @required this.onItemSelected,
    this.contentPadding = const EdgeInsets.all(12),
    this.columns = 1,
    this.onRemove
  });

  final EdgeInsets contentPadding;
  final int columns;
  final void Function(T) onItemSelected;
  final void Function() onRemove;
  final Widget Function(T) renderer;
  final List<T> items;
  final String title;


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: contentPadding,
      title: Text(this.title),
      content: renderList(),
      actions: renderButtons(context)
    );
  }

  List<Widget> renderButtons(BuildContext context) {
    var buttons = List<Widget>();
    if (onRemove != null){
      buttons.add(
        FlatButton(
          child: Text("Remover".toUpperCase()),
          onPressed: () {
            Navigator.pop(context);
            onRemove();
          },
        )
      );
    }
    buttons.add(
      FlatButton(
        child: Text("Cancelar".toUpperCase()),
        onPressed: () => Navigator.pop(context),
      )
    );
    return buttons;
  }

  Widget renderList(){
    if (columns > 1){
      return Container(
        height: 300,
        child: Scrollbar(
          child: GridView.builder(
            itemCount: items.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
            ),
            itemBuilder: (context, index){
              return FlatButton(
                padding: EdgeInsets.all(0),
                onPressed: (){
                  onItemSelected(items[index]);
                  Navigator.pop(context);
                },
                child: renderer(items[index]),
              );
            },
          ),
        ),
      );
    }
    return Container(
      height: 300,
      child: Scrollbar(
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index){
            return FlatButton(
              padding: EdgeInsets.all(0),
              onPressed: (){
                onItemSelected(items[index]);
                Navigator.pop(context);
              },
              child: renderer(items[index]),
            );
          },
        ),
      ),
    );
  }

}