import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.yellow.shade700
      ),
      home: HomePage()
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<NoteModel> notes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('flutter notebook'),
      ),
      body: ListView(
        children: notes.map((note) => NoteBookItem(
          icon: Icon(note.iconData),
          text: note.text,
          timestamp: note.timestamp
        )).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          NoteModel ret = await Navigator.push(context, MaterialPageRoute<NoteModel>(
            builder: (BuildContext context) => NoteEditDialog(),
            fullscreenDialog: true,
          ));

          if (ret != null) {
            setState(() {
              notes.add(ret);
            });
          }
        }
      ),
    );
  }
}


class NoteModel {
  NoteModel({this.iconData, this.text, this.timestamp});

  final IconData iconData;
  final String text;
  final DateTime timestamp;
}

class NoteBookItem extends StatelessWidget {
  NoteBookItem({@required this.icon, @required this.text, @required this.timestamp});

  final Icon icon;
  final String text;
  final DateTime timestamp;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.0,
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: icon,
          ),
          Expanded(
            child: Text(text,
              overflow: TextOverflow.ellipsis,
              maxLines: 2
            )
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text('${timestamp.month} - ${timestamp.day}'),
          ),
        ],
      ),
    );
  }
}


const List<IconData> ICONS = [Icons.star, Icons.favorite, Icons.fastfood, Icons.card_travel];


class NoteEditDialog extends StatefulWidget {
  @override
  _NoteEditDialogState createState() => _NoteEditDialogState();
}

class _NoteEditDialogState extends State<NoteEditDialog> {

  IconData currentIcon;
  TextEditingController textController;

  @override
  void initState() {
    super.initState();
    currentIcon = ICONS[0];
    textController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit note'),
        actions: <Widget>[
          FlatButton(
            child: Text('Save'),
            onPressed: () {
              Navigator.pop(context, NoteModel(
                iconData: currentIcon,
                text: textController.text,
                timestamp: DateTime.now()
              ));
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: ICONS.map((iconData) {
              var color = Theme.of(context).iconTheme.color;
              if (iconData == currentIcon) {
                color = Theme.of(context).primaryColor;
              }
              return IconButton(
                icon: Icon(iconData, color: color),
                onPressed: () {
                  setState(() {
                    currentIcon = iconData;
                  });
                },
              );
            }).toList()
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                autofocus: true,
                decoration: new InputDecoration.collapsed(
                  hintText: 'Note Message'
                ),
                keyboardType: TextInputType.multiline,
                controller: textController,
                maxLines: 1000,
              ),
            ),
          )
        ],
      )
    );
  }
}
