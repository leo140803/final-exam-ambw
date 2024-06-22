import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class CreateNoteScreen extends StatefulWidget {
  @override
  _CreateNoteScreenState createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveNote() {
    Box notesBox = Hive.box('notes');
    var now = DateTime.now().toString();
    notesBox.add({
      'title': _titleController.text,
      'content': _contentController.text,
      'createdAt': now,
      'lastEditedAt': now,
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: BackButton(color: CupertinoColors.activeBlue),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Create Note', style: TextStyle(color: Colors.black)),
        actions: [
          TextButton(
            onPressed: _saveNote,
            child: Row(
              children: [
                Text('Save',
                    style: TextStyle(
                        color: CupertinoColors.activeBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 20)),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              cursorColor: Colors.black,
              controller: _titleController,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
              decoration: InputDecoration(
                hintText: "Enter title",
                border: InputBorder.none,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              cursorColor: Colors.black,
              controller: _contentController,
              style: TextStyle(fontSize: 18),
              decoration: InputDecoration(
                hintText: "Enter content",
                border: InputBorder.none,
              ),
              keyboardType: TextInputType.multiline,
              maxLines: null,
            ),
          ],
        ),
      ),
    );
  }
}
