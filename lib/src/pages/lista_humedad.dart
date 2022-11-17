import 'package:flutter/material.dart';
import 'package:practica_apis/src/models/sensor_modelo.dart';
import 'package:practica_apis/src/providers/sensores_provider.dart';

class ListaHumedad extends StatefulWidget {
  const ListaHumedad({super.key});

  @override
  State<ListaHumedad> createState() => _ListaHumedadState();
}

class _ListaHumedadState extends State<ListaHumedad> {
  @override
  Widget build(BuildContext context) {
    return _humedad();
  }

  Widget _humedad() {
    final productoProvider = SensorProvider();
    return FutureBuilder(
        future: productoProvider.leerHumedad(),
        builder:
            (BuildContext context, AsyncSnapshot<List<SensorModelo>> snapshot) {
          if (snapshot.hasData) {
            return _listadeHumedad(snapshot.data!.reversed.toList());
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Widget _listadeHumedad(List<SensorModelo> datos) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          const Text(
            "Historial de humedad",
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 26, 77, 27)),
          ),
          Expanded(
              child: RefreshIndicator(
            onRefresh: () {
              return Future(() {
                setState(() {
                  debugPrint("Actualiza historial");
                });
              });
            },
            child: ListView.separated(
              primary: false,
              shrinkWrap: true,
              itemBuilder: (context, index) => ListTile(
                leading:
                    const Icon(Icons.water_drop_rounded, color: Colors.blue),
                title: Text(
                    "Porcentaje: ${(100 - (((datos[index].valor) / 1023) * 100).round()).toString()} %  Valor real: ${datos[index].valor.toString()}"),
                subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          "Fecha: ${DateTime.fromMillisecondsSinceEpoch(datos[index].fecha * 1000).day.toString()}-${DateTime.fromMillisecondsSinceEpoch(datos[index].fecha * 1000).month.toString()}-${DateTime.fromMillisecondsSinceEpoch(datos[index].fecha * 1000).year.toString()}"),
                      Text(
                          "Hora: ${DateTime.fromMillisecondsSinceEpoch(datos[index].fecha * 1000).hour.toString()}:${DateTime.fromMillisecondsSinceEpoch(datos[index].fecha * 1000).minute.toString()}:${DateTime.fromMillisecondsSinceEpoch(datos[index].fecha * 1000).second.toString()}"),
                    ]),
                // trailing: Text(
                //     "Fecha: ${DateTime.fromMillisecondsSinceEpoch(datos[index].fecha * 1000).day.toString()}-${DateTime.fromMillisecondsSinceEpoch(datos[index].fecha * 1000).month.toString()}-${DateTime.fromMillisecondsSinceEpoch(datos[index].fecha * 1000).year.toString()}"),
              ),
              itemCount: datos.length,
              separatorBuilder: (context, index) => const Divider(
                color: Color.fromARGB(255, 179, 180, 179),
                height: 50,
              ),
            ),
          ))
        ],
      ),
    );
  }
}
