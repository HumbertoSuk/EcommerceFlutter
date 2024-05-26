import 'package:app_lenses_commerce/presentation/providers/glassesHomeProvider.dart';
import 'package:app_lenses_commerce/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:go_router/go_router.dart';

class HomeForm extends ConsumerWidget {
  const HomeForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Obtener la instancia del proveedor de 'GlassesHomeProvider' utilizando 'ref.read'
    final glassesHomeProvider = ref.read(glassesHomeProviderProvider);

    // contenido de la página
    return Scaffold(
      body: _buildContent(context, glassesHomeProvider),
    );
  }

  // Contenido de la vista
  Widget _buildContent(
      BuildContext context, GlassesHomeProvider glassesHomeProvider) {
    // Construir un FutureBuilder para manejar el estado futuro de 'fetchLensTypes'
    return FutureBuilder<List<String>>(
      future: glassesHomeProvider.fetchLensTypes(),
      builder: (context, snapshot) {
        // Verificar el estado de conexión y mostrar indicador de carga si está en espera
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingIndicator();
        }
        // Manejar errores si los hay
        else if (snapshot.hasError) {
          return _buildErrorWidget(snapshot.error.toString());
        }
        // Si no hay errores, mostrar el contenido de la página
        else {
          final lensTypes = snapshot.data ?? [];
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Mostrar el banner de imagen
                _buildBannerImage(context),
                const SizedBox(height: 15),
                // Mostrar la lista de productos
                _buildProducts(context, glassesHomeProvider, lensTypes),
              ],
            ),
          );
        }
      },
    );
  }

  // Indicador de carga circular
  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  // Widget para manejar errores PARA PRUEBAS
  Widget _buildErrorWidget(String error) {
    return Center(
      child: Text('Error: $error'),
    );
  }

  // Construir el banner de imagen
  Widget _buildBannerImage(BuildContext context) {
    return const BannerImage(
      imagePath: 'assets/images/banner_image.png',
      height: 0.12,
    );
  }

// Construye la lista de productos
  Widget _buildProducts(BuildContext context, GlassesHomeProvider provider,
      List<String> lensTypes) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.75,
      child: ListView.builder(
        itemCount: lensTypes.length,
        itemBuilder: (context, index) {
          final lensType = lensTypes[index];
          // Obtiene los productos disponibles para el tipo de lente actual
          final products = provider.getProductsForLensType(lensType);
          // Convierte los productos en una lista
          final availableProducts = products.toList();

// Devuelve un contenedor vacío si no hay productos disponibles para este tipo de lente,
// de lo contrario, construye y devuelve un widget que contiene los productos.
          return availableProducts.isEmpty
              ? const SizedBox.shrink() // Contenedor vacío
              : _buildProductColumn(
                  context, availableProducts, lensType); // widget
        },
      ),
    );
  }

  // Construye una columna que muestra los productos para un tipo de lente
  Widget _buildProductColumn(BuildContext context,
      List<Map<String, dynamic>> products, String lensType) {
    // Widget que contiene una columna de elementos
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Encabezado
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            lensType, //Texto del tipo de lente
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        // Carrusel de productos
        CarouselSlider(
          // Lista de elementos del carrusel
          items: products
              .map((product) => _buildProductCard(
                  context, product)) // Construir la tarjeta de producto
              .toList(),
          // Opciones del carrusel
          options: CarouselOptions(
            height: 235.0,
            enlargeCenterPage: true,
            autoPlay: true,
            aspectRatio: 16 / 9,
            autoPlayCurve: Curves.fastOutSlowIn,
            enableInfiniteScroll: true,
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            viewportFraction: 0.8,
          ),
        ),
      ],
    );
  }

  // Tarjeta de cada producto
  Widget _buildProductCard(BuildContext context, Map<String, dynamic> product) {
    // Widget que responde a las interacciones del usuario
    return GestureDetector(
      onTap: () {
        // Si se hace click o tap te redirige a la descripción del producto
        _navigateToProductDetails(context, product['productId']);
      },
      // Contenedor que envuelve la tarjeta del producto
      child: Container(
        margin: const EdgeInsets.all(2.0),
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Alinear elementos
            children: [
              // Widget que muestra la imagen del producto
              _buildProductImageWidget(product),
              // Widget que muestra los detalles del producto
              _buildProductDetails(product),
            ],
          ),
        ),
      ),
    );
  }

//Imagen del widget de card
  Widget _buildProductImageWidget(Map<String, dynamic> product) {
    // Utiliza un Stack para superponer la imagen del producto y el ícono del carrito de compras.
    return Stack(
      children: [
        // imagen con bordes redondeados
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          // Construye y muestra la imagen del producto
          child: _buildProductImage(product),
        ),
      ],
    );
  }

  // Construir los detalles del producto
  Widget _buildProductDetails(Map<String, dynamic> product) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 2),
          // Nombre del producto
          Text(
            product['name'] ??
                '', // Si el nombre es nulo, muestra una cadena vacía
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          // Precio del producto
          Text(
            'Precio: ${product['price'] ?? ''}', // Si el precio es nulo, muestra una cadena vacía
            style: const TextStyle(fontSize: 15, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // Construye y devuelve el widget de la imagen del producto
  Widget _buildProductImage(Map<String, dynamic> product) {
    return Image.network(
      product['image'] ??
          '', // Si la URL de la imagen es nula, muestra una cadena vacía
      fit: BoxFit.scaleDown,
      width: double.infinity,
      height: 120,
      errorBuilder: (context, error, stackTrace) {
        // Si hay un error al cargar la imagen, muestra una imagen de error predeterminada
        return Image.asset(
          'assets/images/no_image_error.png',
          fit: BoxFit.scaleDown,
          width: double.infinity,
          height: 120,
        );
      },
    );
  }

// Navegar a los detalles del producto utilizando GoRouter
  void _navigateToProductDetails(BuildContext context, String productId) {
    GoRouter.of(context).go('/detail-glasses?productId=$productId');
  }
}

// Provider
final glassesHomeProviderProvider =
    ChangeNotifierProvider<GlassesHomeProvider>((ref) {
  // Se devuelve una nueva instancia de GlassesHomeProvider para ser proporcionada por el proveedor.
  return GlassesHomeProvider();
});
