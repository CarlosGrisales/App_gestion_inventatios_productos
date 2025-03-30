import 'package:flutter_test/flutter_test.dart';
import 'package:gestion_inventarios_productos/models/inventory/inventory.dart';
import 'package:gestion_inventarios_productos/models/product/enums.dart';
import 'package:gestion_inventarios_productos/models/product/product.dart';
import 'package:isar/isar.dart';

void main() {
  group('Product Model Tests', () {
    test('Debe crear una instancia de Product con valores por defecto', () {
      final product = Product();

      expect(product.id, isA<int>());
      expect(product.name, isNull);
      expect(product.status, equals(Status.available));
      expect(product.barcode, isNull);
      expect(product.price, isNull);
      expect(product.quantity, isNull);
      expect(product.createdAt, isA<DateTime>());
      expect(product.updateAt, isA<DateTime>());
      expect(product.inventory, isA<IsarLink<Inventory>>());
    });

    test('Debe permitir crear un producto con valores personalizados', () {
      final product = Product()
        ..name = "Laptop"
        ..status = Status.lowStock
        ..barcode = "123456789"
        ..price = 1200.99
        ..quantity = 5;

      expect(product.name, "Laptop");
      expect(product.status, Status.lowStock);
      expect(product.barcode, "123456789");
      expect(product.price, 1200.99);
      expect(product.quantity, 5);
    });

    test('copyWith debe crear una copia con valores modificados', () {
      final product = Product()
        ..id = 1
        ..name = "Laptop"
        ..status = Status.available
        ..barcode = "123456789"
        ..price = 1200.99
        ..quantity = 5;

      final updatedProduct = product.copyWith(name: "Tablet", price: 800.50);

      expect(updatedProduct.id, equals(product.id));
      expect(updatedProduct.name, "Tablet");
      expect(updatedProduct.price, 800.50);
      expect(updatedProduct.quantity, product.quantity);
      expect(updatedProduct.createdAt, equals(product.createdAt));
      expect(updatedProduct.updateAt.isAfter(product.updateAt), isTrue);
    });
  });
}
