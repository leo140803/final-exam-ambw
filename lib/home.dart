import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';


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
          if (box.isEmpty) return Center(child: Text('No notes yet'));
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final note = box.getAt(index) as Map;
              return Card(
                child: ListTile(
                  title: Text(note['title'], style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(note['content'], maxLines: 2, overflow: TextOverflow.ellipsis),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => box.deleteAt(index),
                  ),
                  onTap: () {
                    // Handle tap if needed
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
          final box = Hive.box('notes');
          box.add({'title': 'New Note', 'content': 'Edit me'});
        },
        child: Icon(Icons.add),
        tooltip: 'Add Note',
      ),
    );
  }
}
