import 'package:flutter/material.dart';
import 'package:gestion_inventarios_productos/models/inventory/inventory.dart';
import 'package:gestion_inventarios_productos/presentation/pages/product_list_page.dart';
import 'package:gestion_inventarios_productos/services/database_service.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// # Clase de HomePage
///
/// ## Descripción
/// La clase HomePage es una pantalla principal de la aplicación de gestión de inventarios.
/// Permite visualizar una lista de inventarios, agregar nuevos inventarios y eliminar los existentes.
/// Se conecta con la base de datos mediante DatabaseService.
///
/// ## Dependencias
/// - flutter/material.dart: Para la interfaz de usuario en Flutter.
/// - gestion_inventarios_productos/models/inventory/inventory.dart: Modelo de datos Inventory.
/// - gestion_inventarios_productos/presentation/pages/product_list_page.dart: Pantalla de lista de productos.
/// - gestion_inventarios_productos/services/database_service.dart: Servicio para interactuar con la base de datos.
/// - lucide_icons/lucide_icons.dart: Conjunto de iconos utilizados en la interfaz.
///
/// ## Clase HomePage
/// ### Descripción
/// HomePage es un StatefulWidget que representa la pantalla principal donde se listan los inventarios
/// y se permite la navegación a la lista de productos.
///
/// ### Métodos
///
/// #### _loadInventories()
/// Carga los inventarios desde la base de datos utilizando DatabaseService.getInventories()
/// y los almacena en la lista inventories.
///
/// #### _showAddInventoryDialog()
/// Muestra un cuadro de diálogo para agregar un nuevo inventario.
/// Si el usuario ingresa un nombre y lo confirma, se guarda en la base de datos y se actualiza la lista.
///
/// #### _deleteInventory(Inventory inventory)
/// Muestra un cuadro de confirmación para eliminar un inventario.
/// Si el usuario acepta, el inventario se elimina de la base de datos y se actualiza la lista.
///
/// ### build(BuildContext context)
/// Construye la interfaz de usuario que incluye:
/// - AppBar con el título "Inventarios".
/// - Imagen de encabezado.
/// - Lista de inventarios: Si está vacía, muestra un mensaje indicando que no hay inventarios.
/// - Botón flotante para agregar un nuevo inventario.
///
/// ### UI y Estilo
/// - Usa un LinearGradient como fondo.
/// - Las tarjetas de inventario tienen bordes redondeados y sombras sutiles.
/// - Se utilizan iconos de LucideIcons para mejorar la experiencia visual.
///
/// ## Navegación
/// Cuando el usuario toca un inventario, es redirigido a ProductListPage, que muestra los productos del inventario seleccionado.
///
/// ## Resumen
/// Esta pantalla gestiona la lista de inventarios con funcionalidades de agregar, visualizar y eliminar inventarios,
/// proporcionando una interfaz atractiva y fácil de usar.

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<Inventory> inventories = [];

  @override
  void initState() {
    super.initState();
    _loadInventories();
  }

  Future<void> _loadInventories() async {
    final data = await DatabaseService.getInventories();
    setState(() {
      inventories = data;
    });
  }

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

  Future<void> _deleteInventory(Inventory inventory) async {
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
      await DatabaseService.deleteInventory(inventory.id);
      _loadInventories();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Inventarios'),
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
            colors: [Color(0xFFDCECFB), Color(0xFFF3F4F6)],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 150),
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
                    child: Icon(Icons.image_not_supported,
                        size: 80, color: Colors.grey),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: inventories.isEmpty
                  ? const Center(
                      child:
                          Text('No hay inventarios aún, por favor agrega uno.'))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: inventories.length,
                      itemBuilder: (context, index) {
                        final inventory = inventories[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 10),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(12),
                            leading: CircleAvatar(
                              backgroundColor:
                                  Colors.blueAccent.withOpacity(0.2),
                              child: const Icon(LucideIcons.box,
                                  color: Colors.blueAccent),
                            ),
                            title: Text(
                              inventory.name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            trailing: IconButton(
                              icon: const Icon(LucideIcons.trash,
                                  color: Colors.red),
                              onPressed: () => _deleteInventory(inventory),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ProductListPage(inventory: inventory),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddInventoryDialog,
        child: const Icon(LucideIcons.plus),
      ),
    );
  }
}
