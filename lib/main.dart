import 'package:flutter/material.dart';

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
        onPressed: () {
          setState(() {
            notes.add(NoteModel(
              iconData: Icons.star,
              text: 'Hello',
              timestamp: DateTime.now())
            );
          });
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
