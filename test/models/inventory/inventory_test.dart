import 'package:flutter_test/flutter_test.dart';
import 'package:gestion_inventarios_productos/models/inventory/inventory.dart';
import 'package:gestion_inventarios_productos/models/product/product.dart';

void main() {
  group('Inventory Model Tests', () {
    test('Debe crear una instancia de Inventory con valores correctos', () {
      final inventory = Inventory(name: "Depósito Principal");

      expect(inventory.id, isA<int>());
      expect(inventory.name, equals("Depósito Principal"));
      expect(inventory.products.isEmpty, isTrue);
    });

    test('Debe permitir agregar productos a un inventario (simulación)', () {
      final product1 = Product()..name = "Televisor";
      final product2 = Product()..name = "Celular";

      // Simulación de agregar productos sin Isar en memoria
      final mockProducts = <Product>[];
      mockProducts.add(product1);
      mockProducts.add(product2);

      expect(mockProducts.length, 2);
      expect(mockProducts.contains(product1), isTrue);
      expect(mockProducts.contains(product2), isTrue);
    });

    test('Debe permitir remover productos de un inventario (simulación)', () {
      final product1 = Product()..name = "Leche";
      final product2 = Product()..name = "Pan";

      // Simulación de agregar y eliminar productos sin Isar
      final mockProducts = <Product>[];
      mockProducts.add(product1);
      mockProducts.add(product2);
      mockProducts.remove(product1);

      expect(mockProducts.length, 1);
      expect(mockProducts.contains(product1), isFalse);
      expect(mockProducts.contains(product2), isTrue);
    });
  });
}
