import 'package:flutter/material.dart';
import 'package:practica_apis/src/models/sensor_modelo.dart';
import 'package:practica_apis/src/providers/sensores_provider.dart';

class ListaHumedad extends StatelessWidget {
  final productoProvider = SensorProvider();
  // ListaPage({Key key}) : super(key: key);
  ListaHumedad({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Valores de humedad'),
      ),
      body: FutureBuilder(
        future: productoProvider.leer(),
        builder: (context, AsyncSnapshot<List<SensorModelo>> snapshot) {
          if (snapshot.hasData) {
            final items = snapshot.data;
            return ListView.builder(
                itemCount: items!.length,
                itemBuilder: (context, pos) => _crearItem(items[pos]));
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }

  _crearItem(SensorModelo sensorModelo) {
    final DateTime date1 =
        DateTime.fromMillisecondsSinceEpoch(sensorModelo.fecha * 1000);

    return ListTile(
      title: Text('Fecha: ${date1}'),
      trailing: Text('Valor: ${sensorModelo.valor}'),
    );
  }
}
