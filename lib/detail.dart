import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';


class NoteDetailScreen extends StatefulWidget {
  final Map note; // Holds the details of the note
  final int noteIndex; // Index of the note in the Hive box

  NoteDetailScreen({required this.note, required this.noteIndex});

  @override
  _NoteDetailScreenState createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  late TextEditingController
      _titleController; 
  late TextEditingController
      _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note['title']);
    _contentController = TextEditingController(text: widget.note['content']);
  }

  
  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }


  String _formatDateTime(String? dateTime) {
    if (dateTime == null) return 'Unknown date';
    DateTime parsedDate = DateTime.parse(dateTime);
    return DateFormat('dd MMMM yyyy - HH:mm').format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    // Determine display date based on last edit or creation time
    String dateText = widget.note['lastEditedAt'] != "-"
        ? _formatDateTime(widget.note['lastEditedAt'])
        : _formatDateTime(widget.note['createdAt']);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: BackButton(
            color:
                CupertinoColors.activeBlue), 
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Notes',
            style: TextStyle(color: Colors.black)), 
        actions: [
          TextButton(
            onPressed: () {
              Box box = Hive.box('notes'); 
              box.putAt(widget.noteIndex, {
                'title': _titleController.text, // Updated title
                'content': _contentController.text, // Updated content
                'createdAt':
                    widget.note['createdAt'], // Preserve original creation date
                'lastEditedAt':
                    DateTime.now().toString() // Update last edited time
              });
              Navigator.of(context).pop();
            },
            child: Row(
              children: [
                Text('Done',
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
            Center(
              child: Text(
                dateText,
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
            TextField(
              autocorrect: false,
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
            TextField(
              autocorrect: false,
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
