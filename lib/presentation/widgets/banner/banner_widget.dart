import 'package:flutter/material.dart';

class BannerImage extends StatelessWidget {
  /// Ruta de la imagen del banner.
  final String imagePath;

  /// Altura del contenedor del banner en relación con la altura de la pantalla.
  final double height;

  const BannerImage({
    Key? key,
    required this.imagePath,
    this.height = 0.12,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height *
          height, // Altura del contenedor del banner % de la altura de la pantalla
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath), // Imagen del banner
          fit: BoxFit.cover, //
        ),
      ),
    );
  }
}
