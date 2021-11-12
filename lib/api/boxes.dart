import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes/api/notes.dart';

class Boxes {
  static Box<Notes> getNotes() => Hive.box<Notes>('notes');
}
