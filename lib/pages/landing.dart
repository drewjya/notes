import 'package:flutter/material.dart';
import 'package:notes/api/notes.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes/api/boxes.dart';
import 'package:notes/pages/notesdialog.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final List<Notes> notes = [];

  @override
  void dispose() {
    Hive.box('notes').close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple ToDo App'),
        centerTitle: true,
      ),
      body: ValueListenableBuilder<Box<Notes>>(
        valueListenable: Boxes.getNotes().listenable(),
        builder: (context, box, _) {
          final notes = box.values.toList().cast<Notes>();
          if (notes.isEmpty) {
            return const Center(
              child: Text(
                'No Notes yet!',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 25,
                ),
              ),
            );
          } else {
            return ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 5),
                    color: Colors.amberAccent,
                    child: ListTile(
                      title: Text(notes[index].title),
                      subtitle: Text(notes[index].data),
                      trailing: buildButton(context, notes[index]),
                    ),
                  );
                });
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => showDialog(
          context: context,
          builder: (context) => NotesDialog(
            onClickedOnce: addNotes,
          ),
        ),
      ),
    );
  }

  Widget buildButton(BuildContext context, Notes note) => FittedBox(
        fit: BoxFit.fill,
        child: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => NotesDialog(
                    onClickedOnce: (title, data) => editNote(note, data, title),
                  ),
                ),
              ),
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => deleteNote(note),
            ),
          ],
        ),
      );

  Future addNotes(String title, String data) async {
    final note = Notes()
      ..title = title
      ..created = DateTime.now()
      ..data = data;

    final box = Boxes.getNotes();
    box.add(note);
  }

  void editNote(Notes note, String data, String title) {
    note.title = title;
    note.data = data;
    note.created = DateTime.now();
    note.save();
  }

  void deleteNote(Notes note) {
    note.delete();
  }
}
