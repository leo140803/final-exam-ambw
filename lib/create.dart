import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class CreateNote extends StatefulWidget {
  final Map? initialNote;
  final int? noteIndex;

  CreateNote({this.initialNote, this.noteIndex});

  @override
  _CreateNoteState createState() => _CreateNoteState();
}

class _CreateNoteState extends State<CreateNote> {
  late TextEditingController _contentController;
  late TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController();
    _titleController = TextEditingController();
  }

  @override
  void dispose() {
    _contentController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  void _saveNote() async {
    final box = Hive.box('notes');
    final now = DateTime.now().toString();
    final newNote = {
      'title':
          _titleController.text.isNotEmpty ? _titleController.text : 'Untitled',
      'content': _contentController.text.isNotEmpty
          ? _contentController.text
          : 'No content',
      'createdAt': now,
      'lastEditedAt': '-',
    };

    await box.add(newNote);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Note'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveNote,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Note Title'),
              maxLines: 1,
            ),
            SizedBox(height: 10),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: 'Note Content'),
              maxLines: null,
            ),
          ],
        ),
      ),
    );
  }
}
