import 'package:flutter/material.dart';
import 'package:gestion_inventarios_productos/models/product/product.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar:
          true, // Hace que el gradiente cubra hasta la barra de estado
      appBar: AppBar(
        title: const Text('Detalles del Producto'),
        backgroundColor: Colors
            .transparent, // Fondo transparente para integrar con el gradiente
        elevation: 0, // Quita la sombra de la AppBar
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity, // Asegura que ocupe toda la pantalla
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFDCECFB), // Azul claro
              Color(0xFFF3F4F6), // Gris claro
            ],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(
                height:
                    120), // Espacio para que la imagen no quede pegada a la AppBar
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

                    // Tarjeta con detalles del producto
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
