import 'package:app_lenses_commerce/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';

///  Notificar a los widgets que están escuchando sus cambios utilizando
/// la clase Provider, los widgets suscritos se actualizan automaticamente en la UI
class SnackbarProvider extends ChangeNotifier {
  void showSnackbar(BuildContext context, String message,
      {Duration? duration}) {
    SnackBarUtils.showCustomSnackBar(context, message, duration: duration);
  }

  void showCustomSnackbar(BuildContext context, String title, String body,
      {Duration? duration, IconData? iconData}) {
    final snackbar = SnackBar(
      backgroundColor: Colors.grey[900],
      content: Stack(
        children: [
          Row(
            children: [
              _buildIcon(iconData),
              Expanded(child: _buildContent(title, body)),
            ],
          ),
          _buildCloseButton(context),
        ],
      ),
      duration: duration ?? const Duration(seconds: 8),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 16.0,
      margin: const EdgeInsets.all(16.0),
      animation: CurvedAnimation(
        parent: kAlwaysCompleteAnimation,
        curve: Curves.easeInOut,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  Widget _buildIcon(IconData? iconData) {
    return Container(
      margin: const EdgeInsets.only(right: 12.0, top: 12.0),
      child: CircleAvatar(
        radius: 20.0,
        backgroundColor: Colors.blue,
        child: Icon(
          iconData ?? Icons.notifications,
          color: Colors.white,
          size: 24.0,
        ),
      ),
    );
  }

  Widget _buildContent(String title, String body) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17.0,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          body,
          style: const TextStyle(
            fontSize: 14.0,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return Positioned(
      bottom: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SnackBarAction(
          label: 'Close',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}
