import 'package:gestion_inventarios_productos/models/inventory/inventory.dart';
import 'package:gestion_inventarios_productos/models/product/product.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseService {
  static late Isar db;

  /// Inicializa la base de datos
  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    db = await Isar.open(
      [InventorySchema, ProductSchema],
      directory: dir.path, // Agregamos el directorio requerido
    );
  }

  /// Agregar un nuevo inventario
  static Future<void> addInventory(Inventory inventory) async {
    await db.writeTxn(() async {
      await db.inventorys.put(inventory);
    });
  }

  /// Obtener todos los inventarios
  static Future<List<Inventory>> getInventories() async {
    return await db.inventorys.where().findAll();
  }

  /// Eliminar un inventario y sus productos asociados
  static Future<void> deleteInventory(int inventoryId) async {
    await db.writeTxn(() async {
      // 1. Eliminar todos los productos asociados a este inventario
      final productsToDelete = await db.products
          .filter()
          .inventory((inv) => inv.idEqualTo(inventoryId))
          .findAll();

      for (var product in productsToDelete) {
        await db.products.delete(product.id);
      }

      // 2. Eliminar el inventario
      await db.inventorys.delete(inventoryId);
    });
  }

  /// Agregar un producto a un inventario específico
  static Future<void> addProductToInventory(
      Product product, Inventory inventory) async {
    await db.writeTxn(() async {
      product.inventory.value = inventory;
      await db.products.put(product);
      await product.inventory.save();
    });
  }

  /// Obtener productos de un inventario específico
  static Future<List<Product>> getProductsByInventory(int inventoryId) async {
    return await db.products
        .filter()
        .inventory((inv) => inv.idEqualTo(inventoryId))
        .findAll();
  }
}
