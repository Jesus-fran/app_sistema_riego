import 'package:flutter/material.dart';
import 'package:practica_apis/src/models/actuadores_modelo.dart';
import 'package:practica_apis/src/providers/sensores_provider.dart';

class Actuadores extends StatefulWidget {
  const Actuadores({super.key});

  @override
  State<Actuadores> createState() => _ActuadoresState();
}

class _ActuadoresState extends State<Actuadores> {
  String estado = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Center(child: Text("Actuadores"))),
      body: _body(),
    );
  }

  Widget _body() {
    return Column(
      children: [
        const Divider(
          color: Colors.transparent,
          height: 50,
        ),
        const Text("Electroválvula",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            )),
        const Divider(
          color: Colors.transparent,
          height: 30,
        ),
        Image.asset(
          "images/electrovalvula.png",
          width: 150,
          height: 150,
        ),
        const Divider(
          color: Colors.transparent,
          height: 30,
        ),
        const Text(
          "Controla el flujo de agua el cual permite regar las plantas",
          textAlign: TextAlign.justify,
          style: TextStyle(),
        ),
        const Divider(
          height: 10,
          color: Colors.transparent,
        ),
        Row(
          children: const [
            Padding(
              padding: EdgeInsets.all(18.5),
              child: Text(
                "Detalles del actuador:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            )
          ],
        ),
        FutureBuilder(
          future: SensorProvider().getHistorialValvula(),
          builder: (BuildContext context,
              AsyncSnapshot<List<ActuadoresModelo>> snapshot) {
            if (snapshot.hasData) {
              return _detalles(snapshot.data!);
            } else {
              return const LinearProgressIndicator();
            }
          },
        ),
      ],
    );
  }

  Widget _detalles(List<ActuadoresModelo> datos) {
    String fechaHora = "";
    String hora = "";
    if (datos[0].fechaHora == 0) {
      fechaHora = "No establecida";
      hora = "No establecida";
    } else {
      DateTime dateTime =
          DateTime.fromMillisecondsSinceEpoch(datos[0].fechaHora * 1000);
      fechaHora =
          "${dateTime.day} de ${meses[dateTime.month - 1]} del ${dateTime.year}";
      hora = "${dateTime.hour}:${dateTime.minute}:${dateTime.second}";
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 18.5, right: 18.5),
              child: Text(
                datos[0].activo ? "Encendido" : "Apagado",
              ),
            ),
            Switch(
              activeColor: Colors.green,
              value: datos[0].activo,
              onChanged: null,
            ),
          ],
        ),
        const Divider(
          color: Colors.transparent,
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(
                left: 18.5,
                right: 18.5,
              ),
              child: Text(
                "Fecha: ",
              ),
            ),
            Text(fechaHora),
          ],
        ),
        const Divider(
          color: Colors.transparent,
          height: 25,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(
                left: 18.5,
                right: 25.5,
              ),
              child: Text(
                "Hora: ",
              ),
            ),
            Text(hora),
          ],
        ),
      ],
    );
  }
}
