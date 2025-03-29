import 'package:gestion_inventarios_productos/models/product.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseService {
  static late final Isar db;
  static Future<void> Setup() async {
    final appDir = await getApplicationDocumentsDirectory();
    db = await Isar.open(
      [ProductSchema],
      directory: appDir.path,
    );
  }
}
