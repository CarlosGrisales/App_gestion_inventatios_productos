import 'package:gestion_inventarios_productos/models/enums.dart';
import 'package:isar/isar.dart';

part 'todo.g.dart';

@Collection()
class Todo {
  Id id = Isar.autoIncrement;
  @Index(type: IndexType.value)
  String? content;

  @enumerated
  Status status = Status.pending;

  DateTime createdAt = DateTime.now();
  DateTime updateAt = DateTime.now();

  Todo copyWith({
    String? content,
    Status? status,
  }) {
    return Todo()
      ..id = id
      ..content = content ?? this.content
      ..status = status ?? this.status
      ..createdAt = createdAt
      ..updateAt = DateTime.now();
  }
}
