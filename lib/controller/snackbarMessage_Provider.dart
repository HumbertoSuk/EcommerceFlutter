import 'package:app_lenses_commerce/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';

///  Notificar a los widgets que están escuchando sus cambios utilizando
/// la clase Provider, los widgets suscritos se actualizan automaticamente en la UI
class SnackbarProvider extends ChangeNotifier {
  void showSnackbar(BuildContext context, String message,
      {Duration? duration}) {
    SnackBarUtils.showCustomSnackBar(context, message, duration: duration);
  }
}
