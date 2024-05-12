// ignore_for_file: use_build_context_synchronously
import 'package:app_lenses_commerce/controllers/editDeleteGlassesController.dart';
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

  @override
  void initState() {
    super.initState();

    /// Inicializamos el controlador de la barra de búsqueda
    _searchController = widget.searchControllerProvider.searchController;

    /// Creamos el stream de lentes que se encarga de obtener los lentes de la base de datos
    _glassesStream = widget.searchControllerProvider.searchGlasses('');
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

                  /// Muestra un dialogo de confirmación antes de borrar el lente
                  onPressed: () => _deleteGlassConfirmation(context, glassId),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _deleteGlassConfirmation(BuildContext context, String glassId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmación'),
        content: const Text('¿Seguro que deseas borrar este lente?'),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Borrar'),
            onPressed: () => _deleteGlass(context, glassId),
          ),
        ],
      ),
    );
  }

  void _deleteGlass(BuildContext context, String glassId) async {
    GlassController glassController =
        widget.searchControllerProvider.getGlassController();

    try {
      Map<String, dynamic> result = await glassController.deleteGlass(glassId);

      if (result['success']) {
        widget.snackbarProvider.showSnackbar(context, result['message']);
      } else {
        widget.snackbarProvider.showSnackbar(context, result['message']);
      }
    } catch (error) {
      widget.snackbarProvider.showSnackbar(context, 'Error: $error');
    }

    Navigator.of(context).pop();
    FocusScope.of(context).unfocus();
  }
}
