import 'package:flutter/material.dart';
import 'package:gestion_inventarios_productos/models/product/product.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Detail')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Product Name: ${product.name}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            Text('Status: ${product.status.name}'),
            const SizedBox(height: 10),
            Text('Barcode: ${product.barcode ?? "N/A"}'),
            const SizedBox(height: 10),
            Text('Price: \$${product.price?.toStringAsFixed(2)}'),
            const SizedBox(height: 10),
            Text('Quantity: ${product.quantity}'),
            const SizedBox(height: 10),
            Text('Updated At: ${product.updateAt}'),
          ],
        ),
      ),
    );
  }
}
