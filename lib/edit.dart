import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class NoteEditorScreen extends StatefulWidget {
  final Map? initialNote;
  final int? noteIndex;

  NoteEditorScreen({this.initialNote, this.noteIndex});

  @override
  _NoteEditorScreenState createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
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
      'lastEditedAt': now,
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
