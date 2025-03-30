import 'package:flutter_test/flutter_test.dart';
import 'package:gestion_inventarios_productos/models/inventory/inventory.dart';
import 'package:gestion_inventarios_productos/models/product/product.dart';
import 'package:gestion_inventarios_productos/services/database_service.dart';
import 'package:isar/isar.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'database_services_test.mocks.dart';

@GenerateMocks([Isar, IsarCollection])
void main() {
  late MockIsar mockIsar;
  late MockIsarCollection<Inventory> mockInventoryCollection;
  late MockIsarCollection<Product> mockProductCollection;

  setUp(() {
    mockIsar = MockIsar();
    mockInventoryCollection = MockIsarCollection<Inventory>();
    mockProductCollection = MockIsarCollection<Product>();

    // **En lugar de usar `mockIsar.collection<T>()`, sobrescribimos directamente `inventorys` y `products`**
    when(mockIsar.inventorys).thenReturn(mockInventoryCollection);
    when(mockIsar.products).thenReturn(mockProductCollection);

    DatabaseService.db = mockIsar;
  });

  group('DatabaseService Tests', () {
    test('Debe agregar un inventario', () async {
      final inventory = Inventory(name: 'Inventario Test');

      when(mockIsar.writeTxn(any)).thenAnswer((_) async => null);
      when(mockInventoryCollection.put(any)).thenAnswer((_) async => 1);

      await DatabaseService.addInventory(inventory);
      verify(mockIsar.writeTxn(any)).called(1);
      verify(mockInventoryCollection.put(any)).called(1);
    });

    test('Debe obtener todos los inventarios', () async {
      final inventoryList = [
        Inventory(name: 'Inventario 1'),
        Inventory(name: 'Inventario 2')
      ];

      when(mockInventoryCollection.where().findAll())
          .thenAnswer((_) async => inventoryList);

      final result = await DatabaseService.getInventories();
      expect(result.length, 2);
      expect(result, equals(inventoryList));
    });

    test('Debe eliminar un inventario y sus productos asociados', () async {
      final inventoryId = 1;
      final product1 = Product()..id = 1;
      final product2 = Product()..id = 2;

      when(mockProductCollection
              .filter()
              .inventory((q) => q.idEqualTo(inventoryId))
              .findAll())
          .thenAnswer((_) async => [product1, product2]);
      when(mockIsar.writeTxn(any)).thenAnswer((_) async => null);
      when(mockProductCollection.delete(any)).thenAnswer((_) async => true);
      when(mockInventoryCollection.delete(any)).thenAnswer((_) async => true);

      await DatabaseService.deleteInventory(inventoryId);

      verify(mockProductCollection.delete(product1.id)).called(1);
      verify(mockProductCollection.delete(product2.id)).called(1);
      verify(mockInventoryCollection.delete(inventoryId)).called(1);
    });
  });
}
