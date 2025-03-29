import 'package:gestion_inventarios_productos/models/enums.dart';
import 'package:isar/isar.dart';

part 'product.g.dart';

/// Representa una tarea en la base de datos Isar.
@Collection()
class Product {
  /// Identificador único del producto. Se genera automáticamente en bases de datos locales.
  Id id = Isar.autoIncrement;

  /// Contenido o descripción del producto.
  @Index(type: IndexType.value) // Se indexa para búsquedas rápidas.
  String? name;

  /// Estado del producot, definido en un enum (`Status`).
  /// Puede ser `Available`: El producto está en stock y listo para la venta,
  /// `completed`: No hay unidades disponibles en el inventario,
  /// `LowStock`:Quedan pocas unidades y es necesario reabastecer.,
  @enumerated
  Status status = Status.available;

  /// Código de barras del producto.
  String? barcode;

  /// Precio del producto.
  double? price;

  /// Cantidad disponible del producto.
  int? quantity;

  /// Fecha de creación del producto.
  DateTime createdAt = DateTime.now();

  /// Fecha de la última actualización del producto.
  DateTime updateAt = DateTime.now();

  /// Crea una copia del objeto `Producto`, permitiendo modificar ciertos atributos.
  ///
  /// - Parámetros opcionales:
  ///   - `name`: Nombre del producto.
  ///   - `status`: estado del producto.
  ///   - `barcode`: codigo de barras del producto.
  ///   - `price`: Precio del producto.
  ///   - `quantity`: cantidad de unidades disponibles.
  ///
  /// - Devuelve: Una nueva instancia de `producto` con los valores actualizados.
  Product copyWith({
    String? name,
    Status? status,
    String? barcode,
    double? price,
    int? quantity,
  }) {
    return Product()
      ..id = id // Mantiene el mismo ID
      ..name = name ?? this.name // Si no se proporciona, conserva el actual
      ..status =
          status ?? this.status // Mantiene el estado actual si no se modifica
      ..barcode =
          barcode ?? this.barcode // Si no se proporciona, conserva el actual
      ..price = price ?? this.price // Si no se proporciona, conserva el actual
      ..quantity =
          quantity ?? this.quantity // Si no se proporciona, conserva el actual
      ..createdAt = createdAt // La fecha de creación no cambia
      ..updateAt = DateTime.now(); // Se actualiza la fecha de modificación
  }
}
