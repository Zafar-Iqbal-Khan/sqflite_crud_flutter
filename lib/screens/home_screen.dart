import 'package:crud_sqflite_app/database/database.dart';
import 'package:crud_sqflite_app/models/note_model.dart';
import 'package:crud_sqflite_app/screens/add_note_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _updateNoteList();
  }

  final DateFormat _dateFormatter = DateFormat.yMMMEd();
  DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  late Future<List<Note>> _noteList;
  _updateNoteList() {
    _noteList = _databaseHelper.getNoteList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.blueAccent,
      backgroundColor: Theme.of(context).primaryColor,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).accentColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddNoteScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
      body: FutureBuilder(
        future: _noteList,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final int completeNoteCount = snapshot.data!
              .where((Note note) => note.status == 1)
              .toList()
              .length;
          return ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 80),
            itemCount: int.parse(snapshot.data!.length.toString()) + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'My Notes',
                        style: TextStyle(
                          // color: Colors.deepPurple,
                          color: Theme.of(context).accentColor,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        '$completeNoteCount of ${snapshot.data.length}',
                        style: TextStyle(
                          // color: Colors.deepPurple,
                          color: Theme.of(context).accentColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return _buildNote(snapshot.data![index - 1]);
            },
          );
        },
      ),
    );
  }

  _buildNote(Note note) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            ListTile(
              title: Text(
                note.title!,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  // color: Colors.white,
                  color: Theme.of(context).accentColor,
                  decoration: note.status == 0
                      ? TextDecoration.none
                      : TextDecoration.lineThrough,
                ),
              ),
              subtitle: Text(
                '${_dateFormatter.format(note.date!)} - ${note.priority}',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  // color: Colors.white,
                  color: Theme.of(context).accentColor,
                  decoration: note.status == 0
                      ? TextDecoration.none
                      : TextDecoration.lineThrough,
                ),
              ),
              trailing: Checkbox(
                value: note.status == 1 ? true : false,
                onChanged: (val) {
                  note.status = val! ? 1 : 0;
                  DatabaseHelper.instance.updateNote(note);
                  _updateNoteList();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HomePage(),
                    ),
                  );
                },
                activeColor: Colors.black,
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddNoteScreen(
                    note: note,
                    updateNoteList: _updateNoteList(),
                  ),
                ),
              ),
            ),
            Divider(
              height: 5,
              // color: Colors.deepPurple,
              color: Theme.of(context).accentColor,
              thickness: 2.0,
            ),
          ],
        ),
      );
}
