import 'package:gestion_inventarios_productos/models/inventory/inventory.dart';
import 'package:gestion_inventarios_productos/models/product/product.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

/// # Clase DatabaseService
///
/// ## Descripción
/// DatabaseService es una clase estática que proporciona métodos para interactuar con la base de datos Isar.
/// Se encarga de la inicialización, gestión de inventarios y productos dentro de la base de datos local.
///
/// ## Dependencias
/// - isar: Base de datos NoSQL local para Flutter.
/// - path_provider: Para obtener el directorio de almacenamiento de la aplicación.
/// - gestion_inventarios_productos/models/inventory/inventory.dart: Modelo de datos Inventory.
/// - gestion_inventarios_productos/models/product/product.dart: Modelo de datos Product.
///
/// ## Métodos de DatabaseService
///
/// ### init()
/// Descripción: Inicializa la base de datos Isar en el directorio de documentos de la aplicación.
/// Retorno: Future<void>
/// Notas:
/// - Se abre la base de datos con los esquemas de Inventory y Product.
/// - Debe llamarse antes de realizar cualquier operación en la base de datos.
///
/// ### addInventory(Inventory inventory)
/// Descripción: Agrega un nuevo inventario a la base de datos.
/// Parámetros:
/// - inventory: Objeto de tipo Inventory que será guardado.
/// Retorno: Future<void>
///
/// ### getInventories()
/// Descripción: Recupera todos los inventarios almacenados en la base de datos.
/// Retorno: Future<List<Inventory>> con la lista de inventarios.
///
/// ### deleteInventory(int inventoryId)
/// Descripción: Elimina un inventario de la base de datos junto con todos sus productos asociados.
/// Parámetros:
/// - inventoryId: ID del inventario a eliminar.
/// Retorno: Future<void>
/// Notas:
/// - Primero, elimina todos los productos asociados al inventario.
/// - Luego, elimina el inventario en sí.
///
/// ### addProductToInventory(Product product, Inventory inventory)
/// Descripción: Agrega un producto a un inventario específico y lo asocia a la relación correspondiente.
/// Parámetros:
/// - product: Producto a agregar.
/// - inventory: Inventario al que se asociará el producto.
/// Retorno: Future<void>
///
/// ### getProductsByInventory(int inventoryId)
/// Descripción: Recupera todos los productos asociados a un inventario específico.
/// Parámetros:
/// - inventoryId: ID del inventario del cual obtener los productos.
/// Retorno: Future<List<Product>> con la lista de productos del inventario.
///
/// ## Resumen
/// DatabaseService simplifica la interacción con la base de datos Isar al proporcionar métodos para gestionar inventarios y productos.
/// Es una clase esencial para la persistencia de datos en la aplicación, asegurando una estructura eficiente y organizada.

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
