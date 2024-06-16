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
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    // Initialize the controllers with existing data if available
    _titleController = TextEditingController(text: widget.initialNote?['title'] ?? '');
    _contentController = TextEditingController(text: widget.initialNote?['content'] ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveNote() async {
    final box = Hive.box('notes');
    final now = DateTime.now().toString();
    // Create or update the note map
    final updatedNote = {
      'title': _titleController.text,
      'content': _contentController.text,
      'createdAt': widget.initialNote?['createdAt'] ?? now,
      'lastEditedAt': now,
    };

    if (widget.noteIndex != null) {
      await box.putAt(widget.noteIndex!, updatedNote);
    } else {
      await box.add(updatedNote);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initialNote == null ? 'Create Note' : 'Edit Note'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveNote,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
              keyboardType: TextInputType.text,
            ),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: 'Content'),
              keyboardType: TextInputType.multiline,
              maxLines: null,
            ),
          ],
        ),
      ),
    );
  }
}
