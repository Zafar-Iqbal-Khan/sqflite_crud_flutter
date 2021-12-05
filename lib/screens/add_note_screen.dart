import 'package:crud_sqflite_app/database/database.dart';
import 'package:crud_sqflite_app/models/note_model.dart';
import 'package:crud_sqflite_app/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddNoteScreen extends StatefulWidget {
  final Note? note;
  final Function? updateNoteList;

  AddNoteScreen({this.note, this.updateNoteList});

  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _dateController = TextEditingController();

  final DateFormat _dateFormatter = DateFormat.yMMMEd();
  final List<String> _priorities = ['Low', 'Medium', 'High'];
  DateTime _date = DateTime.now();

  String _priority = 'Low';
  String _title = '';
  String btnText = 'Add Note';
  String titleText = 'Add Note';

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _title = widget.note!.title!;
      _date = widget.note!.date!;
      _priority = widget.note!.priority!;

      setState(
        () {
          titleText = 'Update Note';
          btnText = 'Update Note';
        },
      );
    } else {
      setState(
        () {
          titleText = 'Add Note';
          btnText = 'Add Note';
        },
      );
    }
    _dateController.text = _dateFormatter.format(_date);
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  _handleDatePicker() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null && date != _date) {
      setState(
        () {
          _date = date;
        },
      );
      _dateController.text = _dateFormatter.format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 40,
              vertical: 80,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => HomePage(),
                      ),
                    );
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  titleText,
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: TextFormField(
                          validator: (value) => value!.trim().isEmpty
                              ? 'Please enter a note title'
                              : null,
                          onSaved: (value) => _title = value!,
                          initialValue: _title,
                          style: TextStyle(fontSize: 20),
                          decoration: InputDecoration(
                            labelText: "Title",
                            labelStyle: TextStyle(
                              fontSize: 18,
                              // color: Theme.of(context).accentColor,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: TextFormField(
                          readOnly: true,
                          controller: _dateController,
                          onTap: _handleDatePicker,
                          style: TextStyle(fontSize: 20),
                          decoration: InputDecoration(
                            labelText: "Date",
                            labelStyle: TextStyle(
                              fontSize: 18,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 20,
                        ),
                        child: DropdownButtonFormField(
                          icon: Icon(
                            Icons.arrow_drop_down_circle_outlined,
                            color: Colors.black,
                          ),
                          iconSize: 22.0,

                          items: _priorities.map(
                            (String priority) {
                              return DropdownMenuItem(
                                value: priority,
                                child: Text(
                                  priority,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),
                              );
                            },
                          ).toList(),
                          style: TextStyle(
                            fontSize: 18,
                          ),
                          decoration: InputDecoration(
                            labelText: 'priority',
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          value: _priority,
                          // validator: (value) => _priority == null
                          //     ? 'Please select a priority level'
                          //     : null,
                          onChanged: (value) {
                            setState(() {
                              _priority = value.toString();
                            });
                          },
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: ElevatedButton(
                    onPressed: _submit,
                    child: Text(
                      btnText,
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                widget.note != null
                    ? Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        height: 60,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Theme.of(context).accentColor,
                          borderRadius: BorderRadius.circular(
                            30,
                          ),
                        ),
                        child: ElevatedButton(
                          child: Text(
                            'Delete',
                            style: TextStyle(
                              fontSize: 20,
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                          onPressed: _delete,
                        ),
                      )
                    : SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print("$_title , $_date , $_priority ");
      Note note = Note(title: _title, date: _date, priority: _priority);

      if (widget.note == null) {
        note.status = 0;
        DatabaseHelper.instance.insertNote(note);
        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(
            builder: (_) => HomePage(),
          ),
        );
      } else {
        note.id = widget.note!.id;
        note.status = widget.note!.status;
        DatabaseHelper.instance.updateNote(note);
        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(
            builder: (_) => HomePage(),
          ),
        );
      }
      widget.updateNoteList!();
    }
  }

  _delete() {
    DatabaseHelper.instance.deleteNote(widget.note!.id!);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HomePage(),
      ),
    );
    widget.updateNoteList!();
  }
}
