import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gestion_inventarios_productos/models/inventory/inventory.dart';
import 'package:gestion_inventarios_productos/models/product/enums.dart';
import 'package:gestion_inventarios_productos/models/product/product.dart';
import 'package:gestion_inventarios_productos/presentation/pages/product_detail_page.dart';
import 'package:gestion_inventarios_productos/services/database_service.dart';

/// Página principal de la aplicación donde se muestran la lista de productos.
/// Permite agregar, editar y eliminar productos.
class ProductListPage extends StatefulWidget {
  final Inventory inventory;

  const ProductListPage({super.key, required this.inventory});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  /// Lista de productos obtenidas de la base de datos.
  List<Product> todos = [];

  /// Suscripción para escuchar cambios en la base de datos en tiempo real.
  StreamSubscription? todosStream;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  /// Cargar productos del inventario actual
  Future<void> _loadProducts() async {
    final data =
        await DatabaseService.getProductsByInventory(widget.inventory.id);
    setState(() {
      todos = data;
    });
  }

  @override
  void dispose() {
    /// Cancela la suscripción al flujo de datos para evitar fugas de memoria.
    todosStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox.expand(
          child: _buildUI(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addOrEditTodo,
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Construye la interfaz de usuario mostrando la lista de productos.
  Widget _buildUI() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: ListView.builder(
        itemCount: todos.length, // Número de produtos en la lista.
        itemBuilder: (BuildContext context, int index) {
          final todo = todos[index];
          return Card(
            child: ListTile(
              title: Text(todo.name ?? ''),
              subtitle: Text('Status ${todo.status.name} at ${todo.updateAt}'),
              onTap: () {
                // Navegar a la pantalla de detalle del producto
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailPage(product: todo),
                  ),
                );
              },
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// Botón para editar el producto.
                  IconButton(
                    onPressed: () {
                      _addOrEditTodo(product: todo);
                    },
                    icon: const Icon(Icons.edit),
                  ),

                  /// Botón para eliminar el producto.
                  IconButton(
                    onPressed: () async {
                      bool confirmDelete = await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Eliminar Producto'),
                          content: const Text(
                              '¿Estás seguro de que deseas eliminar este producto?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Eliminar',
                                  style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );

                      if (confirmDelete) {
                        await DatabaseService.db.writeTxn(() async {
                          // Buscar el producto antes de eliminarlo
                          final product =
                              await DatabaseService.db.products.get(todo.id);

                          if (product != null) {
                            // Desvincular del inventario antes de eliminarlo
                            product.inventory.value = null;
                            await product.inventory.save();

                            // Eliminar el producto
                            await DatabaseService.db.products.delete(todo.id);
                          }
                          // Remover el producto de la lista local y actualizar la UI
                          setState(() {
                            todos.removeWhere((p) => p.id == todo.id);
                          });
                        });
                      }
                    },
                    icon: const Icon(Icons.delete, color: Colors.red),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Abre un cuadro de diálogo para agregar o editar un producto.
  void _addOrEditTodo({Product? product}) {
    TextEditingController nameController = TextEditingController(
      text: product?.name ?? '',
    );
    Status status = product?.status ?? Status.available;
    TextEditingController barcodeController = TextEditingController(
      text: product?.barcode ?? '',
    );
    TextEditingController priceController = TextEditingController(
      text: product?.price?.toString() ?? '',
    );
    TextEditingController quantityController = TextEditingController(
      text: product?.quantity.toString() ?? '',
    );

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title:
                Text(product != null ? 'Editar Producto' : 'Agregar Producto'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                ),
                DropdownButtonFormField<Status>(
                  value: status,
                  items: Status.values
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e.name),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      if (value == null) return;
                      status = value;
                    });
                  },
                ),
                TextField(
                  controller: barcodeController,
                  decoration:
                      const InputDecoration(labelText: 'Código de Barras'),
                ),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: 'Precio'),
                ),
                TextField(
                  controller: quantityController,
                  decoration: const InputDecoration(labelText: 'Cantidad'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () async {
                  if (nameController.text.isNotEmpty) {
                    late Product newProduct;
                    if (product != null) {
                      newProduct = product.copyWith(
                        name: nameController.text,
                        status: status,
                        barcode: barcodeController.text,
                        price: double.tryParse(priceController.text),
                        quantity: int.tryParse(quantityController.text),
                      );
                    } else {
                      newProduct = Product()
                        ..name = nameController.text
                        ..status = status
                        ..barcode = barcodeController.text
                        ..price = double.tryParse(priceController.text)
                        ..quantity = int.tryParse(quantityController.text)
                        ..inventory.value =
                            widget.inventory; // Asigna el inventario
                    }

                    await DatabaseService.addProductToInventory(
                        newProduct, widget.inventory);

                    // Recargar la lista de productos después de agregar uno nuevo
                    _loadProducts();

                    Navigator.pop(context);
                  }
                },
                child: const Text('Guardar'),
              ),
            ],
          );
        });
  }
}
