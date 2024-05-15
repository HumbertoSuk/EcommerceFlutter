// Modelo de representación de los lentes (glasses)
import 'package:cloud_firestore/cloud_firestore.dart';


class GlassesModel {
  late final String productId; // Nuevo atributo para el ID del producto//kvn
  late String _name;
  late String _description;
  late String _type;
  late String _color;
  late String _material;
  late String? _image;
  late double _price;
  late int _stock;
  late int _minStock;
  late int _maxStock;
  late bool _available;
  late Timestamp _creationDate; // Cambio de DateTime a Timestamp

  // Constructor
  GlassesModel({
    required String name,
    required String description,
    required String type,
    required String color,
    required String material,
    String? image,
    required double price,
    required int stock,
    required int minStock,
    required int maxStock,
    required bool available,
    required Timestamp creationDate, // Cambio de DateTime a Timestamp
  })  : _name = name,
        _description = description,
        _type = type,
        _color = color,
        _material = material,
        _image = image,
        _price = price,
        _stock = stock,
        _minStock = minStock,
        _maxStock = maxStock,
        _available = available,
        _creationDate = creationDate;

  // Getter y Setter para el nombre
  String get name => _name;
  set name(String value) => _name = value;

  // Getter y Setter para la descripción
  String get description => _description;
  set description(String value) => _description = value;

  // Getter y Setter para el tipo
  String get type => _type;
  set type(String value) => _type = value;

  // Getter y Setter para el color
  String get color => _color;
  set color(String value) => _color = value;

  // Getter y Setter para el material
  String get material => _material;
  set material(String value) => _material = value;

  // Getter y Setter para la imagen (opcional)
  String? get image => _image;
  set image(String? value) => _image = value;

  // Getter y Setter para el precio
  double get price => _price;
  set price(double value) => _price = value;

  // Getter y Setter para el stock
  int get stock => _stock;
  set stock(int value) => _stock = value;

  // Getter y Setter para el stock mínimo
  int get minStock => _minStock;
  set minStock(int value) => _minStock = value;

  // Getter y Setter para el stock máximo
  int get maxStock => _maxStock;
  set maxStock(int value) => _maxStock = value;

  // Getter y Setter para la disponibilidad
  bool get available => _available;
  set available(bool value) => _available = value;

  // Getter y Setter para la fecha de creación (Tipo Timestamp)
  Timestamp get creationDate => _creationDate;
  set creationDate(Timestamp value) => _creationDate = value;

  factory GlassesModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return GlassesModel(
      name: data['name'],
      description: data['description'],
      type: data['type'],
      color: data['color'],
      material: data['material'],
      image: data['image'],
      price: data['price'],
      stock: data['stock'],
      minStock: data['minStock'],
      maxStock: data['maxStock'],
      available: data['available'],
      creationDate: data['creationDate'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'type': type,
      'color': color,
      'material': material,
      'image': image,
      'price': price,
      'stock': stock,
      'minStock': minStock,
      'maxStock': maxStock,
      'available': available,
      'creationDate': creationDate,
    };
  }
}
