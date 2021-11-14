import 'package:flutter/material.dart';
import 'package:notes/api/notes.dart';


class NotesDialog extends StatefulWidget {
  final Notes? note;
  final Function(String name, String data) onClickedOnce;
  const NotesDialog({
    Key? key,
    this.note,
    required this.onClickedOnce,
  }) : super(key: key);

  @override
  _NotesDialogState createState() => _NotesDialogState();
}

class _NotesDialogState extends State<NotesDialog> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final dataController = TextEditingController();
  DateTime created = DateTime.now();
  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      final note = widget.note!;
      titleController.text = note.title;
      dataController.text = note.data;
      created = note.created;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    dataController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.note != null;
    final title = isEditing ? 'Edit Notes' : 'Add Notes';
    return Scaffold(
      body: AlertDialog(
        title: Text(title),
        content: Form(
          key:formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(height: 8,),
                buildTitle(),
                const SizedBox(height: 8,),
                buildData(),
              ],
            ),
          ),
        
        ),
        actions: <Widget>[
          cancelButton(context),
          addButton(context, isEditing:isEditing),
        ],
      ),
    );
  }
  Widget buildTitle() => TextFormField(
        controller: titleController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Enter Title',
        ),
        validator: (title) =>
            title != null && title.isEmpty ? 'Enter title' : null,
      );

  Widget buildData() => TextFormField(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Notes',
        ),
        validator: (notes) => notes != null && notes.isEmpty ? 'Enter Notes'
            : null,
        controller: dataController,
      );

  

  Widget cancelButton(BuildContext context) => TextButton(
        child: const Text('Cancel'),
        onPressed: () => Navigator.of(context).pop(),
      );

  Widget addButton(BuildContext context, {required bool isEditing}) {
    final text = isEditing ? 'Save' : 'Add';

    return TextButton(
      child: Text(text),
      onPressed: () async {
        final isValid = formKey.currentState!.validate();

        if (isValid) {
          final title = titleController.text;
          final data = dataController.text;
          widget.onClickedOnce(title, data);

          Navigator.of(context).pop();
        }
      },
    );
  }
}
