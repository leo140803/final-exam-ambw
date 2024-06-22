import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/create.dart';
import 'package:flutter_application_1/detail.dart';
import 'package:flutter_application_1/edit.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
// import 'edit_note_screen.dart';  // Assuming this is the import for your NoteEditorScreen

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Notes'),
        actions: [
          IconButton(
            icon: Icon(CupertinoIcons.settings),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
        backgroundColor: Colors.white,
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
                color: Colors.white,
                surfaceTintColor: Colors.white,
                child: Dismissible(
                    key: Key(note['key']
                        .toString()), // Ensure you have a unique key here
                    direction: DismissDirection.endToStart,
                    dismissThresholds: {DismissDirection.endToStart: 0.25},
                    confirmDismiss: (direction) =>
                        _showConfirmDialog(context, box, index),
                    background: Container(
                      color: CupertinoColors.destructiveRed,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Icon(CupertinoIcons.delete,
                          color: CupertinoColors.white),
                    ),
                    child: CupertinoListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NoteDetailScreen(
                              note: note,
                              noteIndex: index,
                            ),
                          ),
                        );
                      },
                      title: Text(note['title'] ?? 'No Title',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(note['content'] ?? 'No Content'),
                          ],
                        ),
                      ),
                    )),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CreateNote()));
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        tooltip: 'Add Note',
        backgroundColor: Colors.black,
      ),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return 'Unknown date';
    DateTime date = DateTime.parse(dateStr);
    return DateFormat('yyyy-MM-dd – hh:mm a').format(date);
  }

  Future<bool> _showConfirmDialog(
      BuildContext context, Box box, int index) async {
    return await showCupertinoDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: Text('Confirm Delete'),
              content: Text('Are you sure you want to delete this note?'),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: CupertinoColors.activeBlue),
                  ),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                CupertinoDialogAction(
                  child: Text('Delete'),
                  isDestructiveAction: true,
                  onPressed: () {
                    box.deleteAt(index);
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          },
        ) ??
        false;
  }
}
