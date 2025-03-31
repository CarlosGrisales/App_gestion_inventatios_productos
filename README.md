# Instalación

Gestión de inventarios y productos en Flutter con base de datos Isar.

## Consideraciones

1. Instalación de Android Studio 2020.3 y SDK 33.0.0.
2. Instalación de Visual Studio Code.
3. Instalación de Flutter 3.24.5 y configuración de variables de entorno para su reconocimiento.
4. Instalación de las extensiones de Flutter y Dart en Visual Studio Code.

## Procedimiento

### Validación de dependencias
Ejecutar el siguiente comando para verificar la instalación de Flutter:
```sh
flutter doctor
```

### Descarga del repositorio
Desde la consola de Git, ejecutar:
```sh
git clone https://github.com/CarlosGrisales/App_gestion_inventatios_productos.git
```

### Abrir el proyecto en Visual Studio Code
Tras ejecutar el comando anterior, ejecutar los siguientes pasos en la misma terminal
para abrir el proyecto en visual studio code


### Ejecución de pruebas
Ejecutar pruebas unitarias con:
```sh
flutter test
```

### Compilación para cada plataforma

#### Android
```sh
flutter build apk
```

#### iOS
```sh
flutter build ios
```

# Consideraciones Técnicas

**Gestión de Inventarios** es una aplicación móvil desarrollada en Flutter que permite administrar inventarios y productos de manera eficiente utilizando la base de datos Isar.

## Arquitectura

Flutter & Dart: Desarrollado con Flutter 3.24.5 y Dart 3.5.4.
Gestor de estado: Actualmente, la aplicación utiliza StatefulWidget para el manejo del estado dentro de la UI.
Base de datos: Se utiliza `isar` como base de datos local para almacenar inventarios y productos de manera eficiente.
Organización del código: Estructurado hexagonal en modelos, servicios y vistas para mejorar la mantenibilidad.

## Componentes Clave

- **InventoryListPage**: Página principal que muestra la lista de inventarios almacenados en Isar.
- **ProductDetailPage**: Muestra los detalles de un producto seleccionado.
- **DatabaseService**: Maneja la conexión con Isar y proporciona métodos para gestionar inventarios y productos.

## Bibliotecas y Paquetes Utilizados

- `isar`: Base de datos NoSQL para Flutter.
- `isar_flutter_libs`: Librerías necesarias para el funcionamiento de Isar en Flutter.
- `path_provider`: Para obtener rutas del sistema de archivos.
- `lucide_icons`: Conjunto de iconos modernos y personalizables.
- `provider`: Gestión del estado y dependencias.
- `mockito`: Creación de mocks para pruebas unitarias.

## Seguridad y Buenas Prácticas

- Manejo adecuado de excepciones al interactuar con la base de datos.
- Uso de `Provider` para mejorar la escalabilidad y separación de responsabilidades.
- Separación de lógica de negocio y UI para mejorar la escalabilidad.
- Uso de principios SOLID

## Flujo de Trabajo

1. **Visualización de Inventarios**: La aplicación carga y muestra la lista de inventarios almacenados en Isar.
2. **Gestión de Productos**: Se pueden agregar, editar y eliminar productos de cada inventario.
3. **Detalles del Producto**: Muestra información detallada de cada producto, incluyendo código de barras, precio y fecha de actualización.

