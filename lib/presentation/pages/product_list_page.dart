import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gestion_inventarios_productos/models/inventory/inventory.dart';
import 'package:gestion_inventarios_productos/models/product/enums.dart';
import 'package:gestion_inventarios_productos/models/product/product.dart';
import 'package:gestion_inventarios_productos/presentation/pages/product_detail_page.dart';
import 'package:gestion_inventarios_productos/services/database_service.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// # Clase ProductListPage
///
/// ## Descripción
/// ProductListPage es una pantalla que muestra una lista de productos asociados a un inventario específico.
/// Los productos se obtienen desde la base de datos y se presentan en una lista con opciones para agregar,
/// editar y eliminar productos.
///
/// ## Dependencias
/// - flutter/material.dart: Para la construcción de la interfaz de usuario.
/// - gestion_inventarios_productos/models/inventory/inventory.dart: Modelo de datos Inventory.
/// - gestion_inventarios_productos/models/product/product.dart: Modelo de datos Product.
/// - gestion_inventarios_productos/models/product/enums.dart: Enumeraciones de Product, como su estado.
/// - gestion_inventarios_productos/presentation/pages/product_detail_page.dart: Pantalla de detalles del producto.
/// - gestion_inventarios_productos/services/database_service.dart: Servicio para la gestión de base de datos.
/// - lucide_icons/lucide_icons.dart: Conjunto de iconos utilizados en la interfaz.
///
/// ## Clase ProductListPage
/// ### Descripción
/// ProductListPage es un StatefulWidget que permite visualizar y gestionar los productos de un inventario.
/// Se proporciona una interfaz intuitiva con una lista de productos y opciones de gestión.
///
/// ### initState()
/// Método que se ejecuta al iniciar la pantalla y carga los productos desde la base de datos.
///
/// ### build(BuildContext context)
/// Construye la interfaz de usuario que incluye:
/// - AppBar con el nombre del inventario.
/// - Imagen de encabezado decorativa.
/// - Lista de productos, cada uno mostrado en una tarjeta con detalles y acciones disponibles.
/// - Botón flotante para agregar nuevos productos.
///
/// ### Métodos Auxiliares
///
/// #### _loadProducts()
/// Obtiene los productos del inventario desde la base de datos y actualiza la lista.
///
/// #### _buildProductList()
/// Construye y muestra la lista de productos en un ListView.builder.
///
/// #### _deleteProduct(Product product)
/// Muestra un cuadro de diálogo de confirmación y, si se confirma, elimina el producto de la base de datos.
///
/// #### _addOrEditTodo({Product? product})
/// Muestra un cuadro de diálogo para agregar o editar un producto. Permite modificar su nombre,
/// estado, código de barras, precio y cantidad.
///
/// ## UI y Estilo
/// - Usa un LinearGradient como fondo para mejorar la estética.
/// - Las tarjetas de producto tienen bordes redondeados y sombras sutiles.
/// - Se utilizan iconos de LucideIcons para representar visualmente las propiedades del producto.
///
/// ## Resumen
/// ProductListPage es una pantalla clave en la aplicación que facilita la gestión de productos
/// dentro de un inventario. Su diseño intuitivo y sus funcionalidades permiten una experiencia fluida
/// para el usuario al administrar los productos.
///

class ProductListPage extends StatefulWidget {
  final Inventory inventory;

  const ProductListPage({super.key, required this.inventory});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  List<Product> todos = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final data =
        await DatabaseService.getProductsByInventory(widget.inventory.id);
    setState(() {
      todos = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Gradiente detrás de la AppBar
      appBar: AppBar(
        title: Text(widget.inventory.name),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity, // Que abarque toda la pantalla
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
            const SizedBox(height: 150), // Espacio para la AppBar

            // Imagen de encabezado
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
                'assets/list_product.jpg',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(
                      Icons.image_not_supported,
                      size: 80,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Lista de productos
            Expanded(
              child: _buildProductList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addOrEditTodo,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildProductList() {
    return todos.isEmpty
        ? const Center(child: Text("No hay productos, por favor agrega uno."))
        : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: todos.length,
            itemBuilder: (BuildContext context, int index) {
              final todo = todos[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: CircleAvatar(
                    backgroundColor: Colors.blueAccent.withOpacity(0.2),
                    child: const Icon(
                      LucideIcons.box,
                      color: Colors.blueAccent,
                    ),
                  ),
                  title: Text(
                    todo.name ?? 'Sin nombre',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(LucideIcons.tag,
                              size: 16, color: Colors.grey),
                          const SizedBox(width: 5),
                          Expanded(
                            // Esto evitará el desbordamiento
                            child: Text(
                              "Status: ${todo.status.name}",
                              style: const TextStyle(color: Colors.grey),
                              overflow: TextOverflow
                                  .ellipsis, // Evita que el texto se salga del área disponible
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(LucideIcons.archive,
                              size: 16, color: Colors.grey),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text("${todo.quantity}",
                                style: const TextStyle(color: Colors.grey)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          _addOrEditTodo(product: todo);
                        },
                        icon: const Icon(LucideIcons.pencil,
                            color: Colors.orange),
                      ),
                      IconButton(
                        onPressed: () => _deleteProduct(todo),
                        icon: const Icon(LucideIcons.trash, color: Colors.red),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailPage(product: todo),
                      ),
                    );
                  },
                ),
              );
            },
          );
  }

  Future<void> _deleteProduct(Product todo) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Producto'),
        content:
            const Text('¿Estás seguro de que deseas eliminar este producto?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmDelete) {
      await DatabaseService.db.writeTxn(() async {
        final product = await DatabaseService.db.products.get(todo.id);
        if (product != null) {
          product.inventory.value = null;
          await product.inventory.save();
          await DatabaseService.db.products.delete(todo.id);
        }
        setState(() {
          todos.removeWhere((p) => p.id == todo.id);
        });
      });
    }
  }

  void _addOrEditTodo({Product? product}) {
    TextEditingController nameController =
        TextEditingController(text: product?.name ?? '');
    Status status = product?.status ?? Status.available;
    TextEditingController barcodeController =
        TextEditingController(text: product?.barcode ?? '');
    TextEditingController priceController =
        TextEditingController(text: product?.price?.toString() ?? '');
    TextEditingController quantityController =
        TextEditingController(text: product?.quantity.toString() ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(product != null ? 'Editar Producto' : 'Agregar Producto'),
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
                    .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      status = value;
                    });
                  }
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
              onPressed: () => Navigator.pop(context),
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
                      ..inventory.value = widget.inventory;
                  }

                  await DatabaseService.addProductToInventory(
                      newProduct, widget.inventory);

                  _loadProducts();
                  Navigator.pop(context);
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }
}
