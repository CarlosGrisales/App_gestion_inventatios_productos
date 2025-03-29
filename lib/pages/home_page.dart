import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gestion_inventarios_productos/models/enums.dart';
import 'package:gestion_inventarios_productos/models/product.dart';
import 'package:gestion_inventarios_productos/pages/product_detail_page.dart';
import 'package:gestion_inventarios_productos/services/database_service.dart';

/// Página principal de la aplicación donde se muestran la lista de productos.
/// Permite agregar, editar y eliminar productos.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// Lista de productos obtenidas de la base de datos.
  List<Product> todos = [];

  /// Suscripción para escuchar cambios en la base de datos en tiempo real.
  StreamSubscription? todosStream;

  @override
  void initState() {
    super.initState();

    /// Escucha cambios en la base de datos y actualiza la lista de productos.
    todosStream = DatabaseService.db.products
        .buildQuery<Product>()
        .watch(fireImmediately: true)
        .listen((data) {
      setState(() {
        todos = data;
      });
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
                      _addOrEditTodo(todo: todo);
                    },
                    icon: const Icon(Icons.edit),
                  ),

                  /// Botón para eliminar el producto.
                  IconButton(
                    onPressed: () async {
                      await DatabaseService.db.writeTxn(() async {
                        await DatabaseService.db.products.delete(todo.id);
                      });
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
  void _addOrEditTodo({Product? todo}) {
    TextEditingController contentController = TextEditingController(
      text: todo?.name ?? '',
    );
    Status status = todo?.status ?? Status.available;

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(todo != null ? 'Edit product' : 'Add product'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// Campo de texto para el contenido del producto.
                TextField(
                  controller: contentController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),

                /// Desplegable para seleccionar el estado de la producto.
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
                )
              ],
            ),
            actions: [
              /// Botón para cancelar la acción.
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),

              /// Botón para guardar el producto en la base de datos.
              TextButton(
                onPressed: () async {
                  if (contentController.text.isNotEmpty) {
                    late Product newTodo;
                    if (todo != null) {
                      newTodo = todo.copyWith(
                        name: contentController.text,
                        status: status,
                      );
                    } else {
                      newTodo = Product().copyWith(
                        name: contentController.text,
                        status: status,
                      );
                    }
                    await DatabaseService.db.writeTxn(
                      () async {
                        await DatabaseService.db.products.put(newTodo);
                      },
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save'),
              ),
            ],
          );
        });
  }
}
