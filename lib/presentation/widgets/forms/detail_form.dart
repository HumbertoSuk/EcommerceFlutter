import 'package:flutter/material.dart';
import 'package:app_lenses_commerce/presentation/providers/glassesHomeProvider.dart';

class DetailForm extends StatefulWidget {
  final String productId;

  // Constructor for DetailForm widget
  const DetailForm({Key? key, required this.productId}) : super(key: key);

  @override
  _DetailFormState createState() => _DetailFormState();
}

class _DetailFormState extends State<DetailForm> {
  late Map<String, dynamic> _productData = {};
  int _quantity = 1;
  bool _isLoading = false;
  late GlassesHomeProvider _glassesHomeProvider; // Proveedor GlassesHomeProvider

 @override
  void initState() {
    super.initState();
    _glassesHomeProvider = GlassesHomeProvider(); // Inicializar el proveedor
    _fetchProduct();
  }

  void _fetchProduct() async {
    setState(() {
      _isLoading =
          true; // Establecer isLoading como true al iniciar la carga de datos
    });

    try {
      final provider = GlassesHomeProvider();
      await provider.fetchLensTypes();

      // Verificar si lensTypes no está vacío antes de intentar obtener los productos
      if (provider.lensTypes.isNotEmpty) {
        // Obtener el producto para el productId actual
        final productData = await provider.getProductById(widget.productId);
        setState(() {
          _productData = productData;
        });
      } else {
        // Manejar adecuadamente el caso donde no hay tipos de lentes disponibles
        _showErrorDialog('No hay tipos de lentes disponibles');
      }
    } catch (e) {
      // Manejo de errores
      _showErrorDialog('Error al obtener productos: $e');
    } finally {
      setState(() {
        _isLoading =
            false; // Establecer isLoading como false después de completar la carga de datos
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: _isLoading
          ? const CircularProgressIndicator() // Mostrar un indicador de carga si se están cargando los datos
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProductImage(_productData['image']),
                const SizedBox(height: 24.0),
                _buildProductDetails(_productData),
                const SizedBox(height: 24.0),
                _buildQuantitySelector(_productData['stock']),
                const SizedBox(height: 24.0),
                _buildAddToCartButton(_productData['stock']),
              ],
            ),
    );
  }

  // Widget para mostrar la imagen del producto
  Widget _buildProductImage(String? imageUrl) {
    return Center(
      child: Container(
        width: double.infinity,
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: imageUrl != null && imageUrl.isNotEmpty
              ? Image.network(
                  imageUrl,
                  fit: BoxFit.scaleDown,
                  errorBuilder: (context, error, stackTrace) =>
                      _buildErrorImage(),
                )
              : _buildErrorImage(),
        ),
      ),
    );
  }

  // Widget para mostrar una imagen de error si no se puede cargar la imagen del producto
  Widget _buildErrorImage() {
    return Image.asset(
      'assets/images/no_image_error.png',
      fit: BoxFit.scaleDown,
    );
  }

  // Widget para mostrar los detalles del producto
  Widget _buildProductDetails(Map<String, dynamic> productData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          productData['name'],
          style: const TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8.0),
        _buildProductDetailText('Descripción:', productData['description']),
        const SizedBox(height: 16.0),
        _buildProductDetailText('Material:', productData['material']),
        const SizedBox(height: 16.0),
        _buildProductDetailText('Tipo:', productData['type']),
        const SizedBox(height: 16.0),
        _buildProductDetailText('Color:', productData['color']),
        const SizedBox(height: 16.0),
        _buildProductDetailText(
            'Stock actual:', productData['stock'].toString()),
        const SizedBox(height: 16.0),
        _buildProductDetailText(
          'Precio:',
          '\$${productData['price']}',
        ),
      ],
    );
  }

  // Widget para construir un detalle del producto
  Widget _buildProductDetailText(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          value,
          style: const TextStyle(fontSize: 18.0),
        ),
      ],
    );
  }

  // Widget para seleccionar la cantidad de productos a agregar al carrito
  Widget _buildQuantitySelector(int stock) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: () {
            setState(() {
              if (_quantity > 1) {
                _quantity--;
              }
            });
          },
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Text(
            '$_quantity',
            style: const TextStyle(fontSize: 20.0),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            setState(() {
              if (_quantity < stock) {
                _quantity++;
              } else {
                _showStockErrorDialog();
              }
            });
          },
        ),
      ],
    );
  }

  // Widget para el botón "Agregar al carrito"
  Widget _buildAddToCartButton(int stock) {
    return Center(
      child: ElevatedButton(
        onPressed: null // Implementar la función para agregar al carrito
        ,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        child: const Text(
          'Agregar al carrito',
          style: TextStyle(fontSize: 18.0),
        ),
      ),
    );
  }

  // Método para mostrar un diálogo de error con un mensaje personalizado
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Método para mostrar un diálogo de error si la cantidad supera el stock disponible
  void _showStockErrorDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content:
              const Text('La cantidad seleccionada supera el stock disponible'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}