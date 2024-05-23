// ignore_for_file: use_build_context_synchronously
import 'package:app_lenses_commerce/presentation/providers/add-editProduct_Provider.dart';
import 'package:app_lenses_commerce/presentation/providers/searchEditDele_Provider.dart';
import 'package:app_lenses_commerce/presentation/providers/snackbarMessage_Provider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

class EditDeleteGlassesForm extends StatefulWidget {
  final SearchEditDeleteProvider searchControllerProvider;
  final SnackbarProvider snackbarProvider;

  const EditDeleteGlassesForm({
    Key? key,
    required this.searchControllerProvider,
    required this.snackbarProvider,
  }) : super(key: key);

  @override
  _EditDeleteGlassesFormState createState() => _EditDeleteGlassesFormState();
}

class _EditDeleteGlassesFormState extends State<EditDeleteGlassesForm> {
  /// Stream que se encarga de obtener los lentes de la base de datos
  late Stream<QuerySnapshot> _glassesStream;

  /// Controlador de la barra de búsqueda para filtrar los lentes por su id
  late TextEditingController _searchController;
  // ProductProvider instancia;
  late ProductProvider productProvider;

  @override
  void initState() {
    super.initState();

    /// Inicializamos el controlador de la barra de búsqueda
    _searchController = widget.searchControllerProvider.searchController;

    /// Creamos el stream de lentes que se encarga de obtener los lentes de la base de datos
    _glassesStream = widget.searchControllerProvider.searchGlasses('');

    productProvider =
        ProductProvider(snackbarProvider: widget.snackbarProvider);
  }

  @override
  void dispose() {
    /// Deshacemos el controlador de la barra de búsqueda
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Buscar por ID...',
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search),
          ),

          /// Cada vez que se modifica el texto en la barra de búsqueda
          onChanged: _filterGlasses,
        ),
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _glassesStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Ha ocurrido un error.'));
          }

          /// Obtener los lentes de la base de datos
          final glasses = snapshot.data!.docs;

          /// Creamos un listado de lentes con los datos obtenidos
          return ListView.builder(
            itemCount: glasses.length,
            itemBuilder: (context, index) {
              final glass = glasses[index];
              return _buildGlassItem(glass);
            },
          );
        },
      ),
    );
  }

  /// Filtrar los lentes por su id
  void _filterGlasses(String query) {
    setState(() {
      _glassesStream =
          widget.searchControllerProvider.searchGlasses(query.toLowerCase());
    });
  }

  /// Crea un widget para mostrar los datos de un lente
  Widget _buildGlassItem(DocumentSnapshot glass) {
    final String glassId = glass.id;
    final String imageUrl = glass['image'];
    final String glassName = glass['name'];

    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Card(
        elevation: 3,
        child: ListTile(
          leading: Image.network(
            imageUrl,
            width: 120,
            height: 80,
            fit: BoxFit.scaleDown,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                'assets/images/no_image_error.png',
                width: 120,
                height: 80,
                fit: BoxFit.scaleDown,
              );
            },
          ),
          title: Text(
            glassId,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nombre: $glassName', style: const TextStyle(fontSize: 13)),
            ],
          ),
          trailing: Padding(
            padding: const EdgeInsets.only(right: 2.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    final glassId = glass.id;
                    GoRouter.of(context).go('/editExist-lenses?id=$glassId');
                  },
                ),
                const SizedBox(width: 4),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    _deleteGlassConfirmation(context, glassId);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _deleteGlassConfirmation(BuildContext context, String glassId) {
    bool deleting = false; // Variable para rastrear si se está eliminando

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Confirmación'),
              content: deleting
                  ? const SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(),
                    )
                  : const Text('¿Seguro que deseas borrar este lente?'),
              actions: [
                TextButton(
                  onPressed:
                      deleting ? null : () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: deleting
                      ? null
                      : () async {
                          setState(() {
                            deleting =
                                true; // Marcar que se está realizando la eliminación
                          });
                          await _deleteGlass(context, glassId);
                          await Future.delayed(
                              const Duration(milliseconds: 1000));
                          Navigator.of(context).pop(); // Cerrar el diálogo
                          FocusScope.of(context).unfocus();
                        },
                  child: const Text('Borrar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _deleteGlass(BuildContext context, String glassId) async {
    try {
      // Llamar al método para eliminar el producto
      final result = await productProvider.deleteProduct(
        context: context,
        productId: glassId,
      );

      // Mostrar el mensaje utilizando ScaffoldMessenger
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result)),
      );
    } catch (error) {
      // Manejar errores
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }
}
