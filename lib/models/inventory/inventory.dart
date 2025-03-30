import 'package:gestion_inventarios_productos/models/product/product.dart';
import 'package:isar/isar.dart';

part 'inventory.g.dart';

@Collection()
class Inventory {
  Id id = Isar.autoIncrement;

  /// Nombre del inventario
  String name;

  /// Relación con los productos
  @Backlink(to: 'inventory')
  final products = IsarLinks<Product>();

  Inventory({required this.name});
}
