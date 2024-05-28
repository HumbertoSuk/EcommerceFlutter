import 'package:app_lenses_commerce/presentation/widgets/forms/cart_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartScreen extends ConsumerWidget {
  static const String nameScreen = "CartScreen";
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const CartForm();
  }
}
