import 'package:cloud_firestore/cloud_firestore.dart';

class MyDataModel {
  String id;
  String field1;
  String field2;
  // CAMPOS GENERALES-- HAY QUE MODIFICARLO SEGUN NUESTRAS NECESIDADES

  MyDataModel({required this.id, required this.field1, required this.field2});

  factory MyDataModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return MyDataModel(
      id: doc.id,
      field1: data['field1'] ?? '',
      field2: data['field2'] ?? '',
      // Incluye más campos aquí
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'field1': field1,
      'field2': field2,
      // Agrega más campos aquí
    };
  }
}
