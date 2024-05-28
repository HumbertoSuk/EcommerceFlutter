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
    final glassesHomeProvider = ref.read(glassesHomeProviderProvider);

    return Scaffold(
      body: Stack(
        children: [
          _buildContent(context, glassesHomeProvider),
          Positioned(
            top: 660,
            right: 15,
            child: FloatingActionButton(
              onPressed: () {
                // Acción al hacer clic en el botón del carrito
                _navigateToCart(context);
              },
              child: const Icon(Icons.shopping_cart),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
      BuildContext context, GlassesHomeProvider glassesHomeProvider) {
    return FutureBuilder<List<String>>(
      future: glassesHomeProvider.fetchLensTypes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingIndicator();
        } else if (snapshot.hasError) {
          return _buildErrorWidget(snapshot.error.toString());
        } else {
          final lensTypes = snapshot.data ?? [];
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBannerImage(context),
                const SizedBox(height: 15),
                _buildProducts(context, glassesHomeProvider, lensTypes),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Text('Error: $error'),
    );
  }

  Widget _buildBannerImage(BuildContext context) {
    return const BannerImage(
      imagePath: 'assets/images/banner_image.png',
      height: 0.12,
    );
  }

  Widget _buildProducts(BuildContext context, GlassesHomeProvider provider,
      List<String> lensTypes) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.75,
      child: ListView.builder(
        itemCount: lensTypes.length,
        itemBuilder: (context, index) {
          final lensType = lensTypes[index];
          final products = provider.getProductsForLensType(lensType);
          final availableProducts = products.toList();

          return availableProducts.isEmpty
              ? const SizedBox.shrink()
              : _buildProductColumn(context, availableProducts, lensType);
        },
      ),
    );
  }

  Widget _buildProductColumn(BuildContext context,
      List<Map<String, dynamic>> products, String lensType) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            lensType,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        CarouselSlider(
          items: products
              .map((product) => _buildProductCard(context, product))
              .toList(),
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

  Widget _buildProductCard(BuildContext context, Map<String, dynamic> product) {
    return GestureDetector(
      onTap: () {
        _navigateToProductDetails(context, product['productId']);
      },
      child: Container(
        margin: const EdgeInsets.all(2.0),
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProductImageWidget(product),
              _buildProductDetails(product),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductImageWidget(Map<String, dynamic> product) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: _buildProductImage(product),
        ),
      ],
    );
  }

  Widget _buildProductDetails(Map<String, dynamic> product) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 2),
          Text(
            product['name'] ?? '',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(
            'Precio: ${product['price'] ?? ''}',
            style: const TextStyle(fontSize: 15, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildProductImage(Map<String, dynamic> product) {
    return Image.network(
      product['image'] ?? '',
      fit: BoxFit.scaleDown,
      width: double.infinity,
      height: 120,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          'assets/images/no_image_error.png',
          fit: BoxFit.scaleDown,
          width: double.infinity,
          height: 120,
        );
      },
    );
  }

  void _navigateToProductDetails(BuildContext context, String productId) {
    GoRouter.of(context).go('/detail-glasses?productId=$productId');
  }

  void _navigateToCart(BuildContext context) {
    GoRouter.of(context).go('/cart');
  }
}

final glassesHomeProviderProvider =
    ChangeNotifierProvider<GlassesHomeProvider>((ref) {
  return GlassesHomeProvider();
});
