import 'package:flutter/material.dart';
import 'package:gestion_inventarios_productos/models/inventory/inventory.dart';
import 'package:gestion_inventarios_productos/presentation/pages/product_list_page.dart';
import 'package:gestion_inventarios_productos/services/database_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Inventory> inventories = [];

  @override
  void initState() {
    super.initState();
    _loadInventories();
  }

  /// Cargar todos los inventarios desde la base de datos
  Future<void> _loadInventories() async {
    final data = await DatabaseService.getInventories();
    setState(() {
      inventories = data;
    });
  }

  /// Mostrar diálogo para agregar un nuevo inventario
  void _showAddInventoryDialog() {
    TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nuevo Inventario'),
          content: TextField(
            controller: nameController,
            decoration:
                const InputDecoration(labelText: 'Nombre del Inventario'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty) {
                  final inventory = Inventory(name: nameController.text);
                  await DatabaseService.addInventory(inventory);
                  _loadInventories();
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

  /// Eliminar inventario con confirmación
  void _deleteInventory(int inventoryId) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Inventario'),
        content: const Text(
            '¿Estás seguro de que deseas eliminar este inventario? Se perderán todos sus productos.'),
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
      await DatabaseService.deleteInventory(inventoryId);
      _loadInventories();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inventarios')),
      body: inventories.isEmpty
          ? const Center(child: Text('No hay inventarios aún'))
          : ListView.builder(
              itemCount: inventories.length,
              itemBuilder: (context, index) {
                final inventory = inventories[index];
                return Card(
                  child: ListTile(
                    title: Text(inventory.name),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteInventory(inventory.id),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductListPage(inventory: inventory),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddInventoryDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
