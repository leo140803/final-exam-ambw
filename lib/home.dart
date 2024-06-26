import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/create.dart';
import 'package:flutter_application_1/detail.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int notesCount = 0; // Menghitung jumlah catatan yang tersimpan

  @override
  void initState() {
    super.initState();
    final notesBox = Hive.box('notes'); 
    notesCount = notesBox.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: CupertinoButton(
          child: Icon(CupertinoIcons.square_arrow_right,
              color: CupertinoColors.systemRed),
          onPressed: () {
            print('Logout action triggered');
            Navigator.pushReplacementNamed(context, '/login');
          },
        ),
        title: Text('Notes'),
        actions: [
          IconButton(
            icon: Icon(
              CupertinoIcons.settings,
              color: CupertinoColors.systemYellow,
            ),
            onPressed: () => Navigator.pushNamed(
                context, '/settings'),
          ),
        ],
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box('notes')
            .listenable(), // listen perubahan pada kotak catatan
        builder: (context, Box box, _) {
          if (box.isEmpty) {
            return Center(
                child:
                    Text('No notes yet')); // Tampilkan jika tidak ada catatan
          }
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final note = box.getAt(index) as Map;
              return Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: SizedBox(
                  height: 65,
                  child: Card(
                    color: Colors.white,
                    surfaceTintColor: Colors.white,
                    child: Dismissible(
                        key: Key(note['key']
                            .toString()), 
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
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                          child: CupertinoListTile(
                            onTap: () {
                              print(note[
                                  'content']); 
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
                            title: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                  note['title'] != ""
                                      ? note['title']
                                      : 'No Additional Text', // Judul catatan
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                            ),
                            subtitle: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(bottom: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(note['lastEditedAt'] != "-"
                                          ? formatNoteDate(note[
                                              'lastEditedAt']) // Format tanggal terakhir diedit
                                          : formatNoteDate(note[
                                              'createdAt'])), // Atau tanggal dibuat
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(note['content'] != ""
                                            ? note['content'] // Isi catatan
                                            : 'No Additional Text'),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        shadowColor: CupertinoColors.systemGrey,
        color: CupertinoColors.white,
        surfaceTintColor: CupertinoColors.white,
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 50.0, sigmaY: 50.0),
            child: Container(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text('${notesCount} Notes', // Jumlah catatan
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w500)),
                  Spacer(),
                  IconButton(
                    icon: Icon(CupertinoIcons.create),
                    color: CupertinoColors.systemYellow,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CreateNoteScreen())); 
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Fungsi untuk memformat tanggal catatan
  String formatNoteDate(String dateStr) {
    if (dateStr == "-") return "No Date";

    DateTime noteDate = DateTime.parse(dateStr);
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime aWeekAgo = now.subtract(Duration(days: 7));

    if (noteDate.compareTo(today) >= 0) {
      return DateFormat('HH:mm').format(noteDate);
    } else if (noteDate.isAfter(aWeekAgo)) {
      return DateFormat('EEEE').format(noteDate);
    } else {
      return DateFormat('HH/mm/yy').format(noteDate);
    }
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
                    setState(() {
                      notesCount--; // Mengurangi jumlah catatan
                    });
                    box.deleteAt(index); // Menghapus catatan dari box
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        ) ??
        false;
  }
}
