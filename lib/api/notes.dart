import 'package:hive/hive.dart';

part 'notes.g.dart';

@HiveType(typeId: 0)
class Notes extends HiveObject {
  @HiveField(0)
  late String title;

  @HiveField(1)
  late DateTime created;

  @HiveField(2)
  late String data;
}
