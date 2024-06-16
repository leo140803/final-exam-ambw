import 'package:flutter/material.dart';
import 'package:flutter_application_1/edit.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';  // Add this for date formatting

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box('notes').listenable(),
        builder: (context, Box box, _) {
          if (box.isEmpty) {
            return Center(child: Text('No notes yet'));
          }
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final note = box.getAt(index) as Map;
              return Card(
                child: ListTile(
                  title: Text(note['title'] ?? 'No Title', style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(note['content'] ?? 'No Content'),
                      SizedBox(height: 4),
                      Text('Created: ${_formatDate(note['createdAt'])}', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      Text('Last Edited: ${_formatDate(note['lastEditedAt'])}', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                  isThreeLine: true,
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => box.deleteAt(index),
                  ),
                  onTap: () {
                  },
                ),
                margin: EdgeInsets.all(8),
                elevation: 2,
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => NoteEditorScreen()));
        },
        child: Icon(Icons.add),
        tooltip: 'Add Note',
      ),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return 'Unknown date';
    DateTime date = DateTime.parse(dateStr);
    return DateFormat('yyyy-MM-dd – kk:mm').format(date);
  }
}
