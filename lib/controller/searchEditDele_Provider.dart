import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app_lenses_commerce/controllers/editDeleteGlassesController.dart';

class SearchEditDeleteProvider extends ChangeNotifier {
  final TextEditingController _searchController = TextEditingController();
  final GlassController _glassController;

  SearchEditDeleteProvider(this._glassController);

  TextEditingController get searchController => _searchController;

  Stream<QuerySnapshot> searchGlasses(String query) {
    if (query.isEmpty) {
      return _glassController.getGlassesStream();
    } else {
      String end = query.substring(0, query.length - 1) +
          String.fromCharCode(query.codeUnitAt(query.length - 1) + 1);

      return _glassController.searchGlasses(
          query.toLowerCase(), end.toLowerCase());
    }
  }

  GlassController getGlassController() {
    return _glassController;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
