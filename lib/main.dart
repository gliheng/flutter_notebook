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
        accentColor: Colors.yellow.shade700,
        textTheme: TextTheme(display1: TextStyle(fontSize: 18.0))
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

  _buildDefaultContent(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            width: 100.0,
            height: 100.0,
            child: Image.asset('assets/images/note-icon.png')
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Empty notebook', style: Theme.of(context).textTheme.display1),
          )
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('flutter notebook'),
      ),
      body: notes.length == 0 ? _buildDefaultContent(context) : ListView(
        children: notes.map((note) {
          return Dismissible(
            key: ObjectKey(note),
            direction: DismissDirection.startToEnd,
            onDismissed: (DismissDirection dir) {
              setState(() {
                notes.remove(note);
              });
            },
            background: Container(
              color: Theme.of(context).primaryColor,
              child: ListTile(
                leading: Icon(Icons.delete, color: Colors.white),
              ),
            ),
            child: ListTile(
              leading: Icon(note.iconData),
              title: Text(note.text),
              trailing: Text('${note.timestamp.month} - ${note.timestamp.day}')
            ),
          );
        }).toList(),
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

  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      appBar: AppBar(
        title: Text('Edit note'),
        actions: <Widget>[
          FlatButton(
            child: Text('Save'),
            onPressed: () {
              if (textController.text.isEmpty) {
                key.currentState.showSnackBar(SnackBar(content: Text('Empty notebook, please add some text')));
                return;
              }

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
