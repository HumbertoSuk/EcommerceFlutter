import 'package:flutter/material.dart';
import 'package:tu_app/model/my_data_model.dart';

class MyDataListScreen extends StatelessWidget {
  final List<MyDataModel> data;

  MyDataListScreen({required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Datos'),
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          final item = data[index];
          return ListTile(
            title: Text(item.field1),
            subtitle: Text(item.field2),
            // Agrega más campos según sea necesario
            onTap: () {
              // Implementa la lógica para navegar a la pantalla de detalles o editar aquí
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implementa la lógica para navegar a la pantalla de agregar aquí
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
