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
        title: const Text('Valores de humedad'),
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
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  _crearItem(SensorModelo sensorModelo) {
    final DateTime date1 =
        DateTime.fromMillisecondsSinceEpoch(sensorModelo.fecha * 1000);
    String fecha = "${date1.day}-${date1.month}-${date1.year}";
    String tiempo = "${date1.hour}:${date1.minute}:${date1.second}";
    return ListTile(
      title: Text('Fecha: $fecha'),
      subtitle: Text(tiempo),
      trailing: Text('Valor: ${sensorModelo.valor}'),
    );
  }
}
