import 'package:flutter/material.dart';
import 'package:gestion_inventarios_productos/models/product/product.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// # clase ProductDetailPage
///
/// ## Descripción
/// `ProductDetailPage` es una pantalla que muestra los detalles de un producto seleccionado.
/// Incluye información como nombre, estado, código de barras, precio, cantidad y fecha de actualización.
///
/// ## Dependencias
/// - `flutter/material.dart`: Para la interfaz de usuario en Flutter.
/// - `gestion_inventarios_productos/models/product/product.dart`: Modelo de datos `Product`.
/// - `lucide_icons/lucide_icons.dart`: Conjunto de iconos utilizados en la interfaz.
///
/// ## Clase `ProductDetailPage`
/// ### Descripción
/// `ProductDetailPage` es un `StatelessWidget` que recibe un objeto `Product` como parámetro
/// y muestra sus detalles en un diseño atractivo.
///
/// ### `build(BuildContext context)`
/// Construye la interfaz de usuario que incluye:
/// - **AppBar** con el título "Detalles del Producto".
/// - **Imagen del producto** con un marcador de error si la imagen no se encuentra.
/// - **Tarjeta con detalles del producto**, donde se muestra la información del producto en filas organizadas.
///
/// ### Métodos Auxiliares
///
/// #### `_buildDetailRow({required IconData icon, required String label, required String value, required BuildContext context})`
/// Construye una fila de detalle con un ícono, etiqueta y valor.
///
/// #### `_buildDivider()`
/// Devuelve un `Divider` para separar los elementos de la tarjeta.
///
/// #### `_formatDate(DateTime date)`
/// Formatea una fecha para mostrarla en formato "dd/MM/yyyy HH:mm".
///
/// ## UI y Estilo
/// - Usa un `LinearGradient` como fondo.
/// - La tarjeta de detalles tiene bordes redondeados y sombra para mejorar la apariencia.
/// - Los iconos de `LucideIcons` se utilizan para representar visualmente los atributos del producto.
///
/// ## Resumen
/// `ProductDetailPage` es una pantalla informativa que proporciona una vista detallada de un producto
/// con un diseño atractivo y organizado.

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Detalles del Producto'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFDCECFB),
              Color(0xFFF3F4F6),
            ],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 120),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Imagen del producto
                    Container(
                      height: 200,
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            spreadRadius: 1,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Image.asset(
                        'assets/product.jpg',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(Icons.image_not_supported,
                                size: 80, color: Colors.grey),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    /// Tarjeta con detalles del producto
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            _buildDetailRow(
                              icon: LucideIcons.box,
                              label: "Product Name",
                              value: product.name?.isNotEmpty == true
                                  ? product.name!
                                  : "Sin dato",
                              context: context,
                            ),
                            _buildDivider(),
                            _buildDetailRow(
                              icon: LucideIcons.tag,
                              label: "Status",
                              value: product.status.name.isNotEmpty
                                  ? product.status.name
                                  : "Sin dato",
                              context: context,
                            ),
                            _buildDivider(),
                            _buildDetailRow(
                              icon: LucideIcons.scanLine,
                              label: "Barcode",
                              value: product.barcode?.isNotEmpty == true
                                  ? product.barcode!
                                  : "N/A",
                              context: context,
                            ),
                            _buildDivider(),
                            _buildDetailRow(
                              icon: LucideIcons.dollarSign,
                              label: "Price",
                              value: product.price != null
                                  ? "\$${product.price!.toStringAsFixed(2)}"
                                  : "0.00",
                              context: context,
                            ),
                            _buildDivider(),
                            _buildDetailRow(
                              icon: LucideIcons.package,
                              label: "Quantity",
                              value: "${product.quantity ?? 0}",
                              context: context,
                            ),
                            _buildDivider(),
                            _buildDetailRow(
                              icon: LucideIcons.clock,
                              label: "Updated At",
                              value: _formatDate(product.updateAt),
                              context: context,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget para una fila de detalles con ícono y texto estilizado
  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    required BuildContext context,
  }) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor, size: 24),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            "$label: $value",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }

  // Línea divisoria para separar los detalles
  Widget _buildDivider() {
    return const Divider(thickness: 1, height: 20);
  }

  // Formateo de fecha (para que se vea más legible)
  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}";
  }
}
