import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tu_app/model/my_data_model.dart';

class MyDataController {
  final CollectionReference _dataCollection =
      FirebaseFirestore.instance.collection('myData');

  Future<void> addData(MyDataModel newData) async {
    await _dataCollection.add(newData.toMap());
  }

  Stream<List<MyDataModel>> getData() {
    return _dataCollection.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => MyDataModel.fromFirestore(doc)).toList());
  }

  Future<void> updateData(String id, Map<String, dynamic> newData) async {
    await _dataCollection.doc(id).update(newData);
  }

  Future<void> deleteData(String id) async {
    await _dataCollection.doc(id).delete();
  }
}

/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tu_app/model/my_data_model.dart';

class MyDataController {
  final CollectionReference _dataCollection = FirebaseFirestore.instance.collection('myData');

  // Método para agregar un nuevo documento a la colección
  Future<void> addData(MyDataModel newData) async {
    await _dataCollection.add(newData.toMap());
  }

  // Método para obtener todos los documentos de la colección
  Stream<List<MyDataModel>> getData() {
    return _dataCollection.snapshots().map((snapshot) => snapshot.docs.map((doc) => MyDataModel.fromFirestore(doc)).toList());
  }

  // Método para actualizar un documento existente en la colección
  Future<void> updateData(String id, Map<String, dynamic> newData) async {
    await _dataCollection.doc(id).update(newData);
  }

  // Método para eliminar un documento de la colección
  Future<void> deleteData(String id) async {
    await _dataCollection.doc(id).delete();
  }
}

*/