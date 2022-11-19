import 'package:flutter/material.dart';
import 'package:practica_apis/src/models/sensores_modelo.dart';
import 'package:practica_apis/src/providers/sensores_provider.dart';

class Sensores extends StatefulWidget {
  const Sensores({super.key});

  @override
  State<Sensores> createState() => _SensoresState();
}

class _SensoresState extends State<Sensores> {
  bool active = false;
  String estado = "";
  String msgEstado = "";
  SensoresModelo sensoresModelo = SensoresModelo();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Sensores")),
      ),
      body: _getSensores(),
    );
  }

  Widget _getSensores() {
    final productoProvider = SensorProvider();
    return FutureBuilder(
        future: productoProvider.leerSensores(),
        builder: (BuildContext context,
            AsyncSnapshot<List<SensoresModelo>> snapshot) {
          if (snapshot.hasData) {
            return _body(snapshot.data!);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Widget _body(List<SensoresModelo> datos) {
    DateTime fechaHora =
        DateTime.fromMillisecondsSinceEpoch(datos[0].fechaHora * 1000);
    if (datos[0].activo) {
      estado = "Encendido";
      active = true;
      msgEstado = "apagar";
    } else {
      estado = "Apagado";
      active = false;
      msgEstado = "encender";
    }

    return Column(
      children: [
        const Divider(
          height: 60,
          color: Color.fromARGB(50, 151, 151, 151),
        ),
        const Text("Higrometro"),
        const Divider(
          height: 60,
          color: Color.fromARGB(50, 151, 151, 151),
        ),
        Text("Fecha del utimo cambio",
            style: TextStyle(
                color: Colors.green.shade600, fontWeight: FontWeight.bold)),
        const Divider(
          height: 15,
          color: Color.fromARGB(0, 151, 151, 151),
        ),
        ListTile(
          leading: const Icon(
            Icons.date_range_rounded,
            size: 30,
            color: Colors.black,
          ),
          title: RichText(
              text: TextSpan(children: [
            TextSpan(
                text: fechaHora.day.toString(),
                style: const TextStyle(color: Colors.green)),
            const TextSpan(text: " de ", style: TextStyle(color: Colors.black)),
            TextSpan(
                text: fechaHora.month.toString(),
                style: const TextStyle(color: Colors.green)),
            const TextSpan(
                text: " del ", style: TextStyle(color: Colors.black)),
            TextSpan(
                text: fechaHora.year.toString(),
                style: const TextStyle(color: Colors.green)),
            const TextSpan(
                text: " a las  ", style: TextStyle(color: Colors.black)),
            TextSpan(
                text:
                    "${fechaHora.hour.toString()}:${fechaHora.minute.toString()}:${fechaHora.second.toString()}",
                style: const TextStyle(color: Colors.green)),
          ])),
        ),
        const Divider(
          height: 15,
          color: Color.fromARGB(0, 151, 151, 151),
        ),
        Text("Estado actual",
            style: TextStyle(
                color: Colors.green.shade600, fontWeight: FontWeight.bold)),
        const Divider(
          height: 15,
          color: Color.fromARGB(0, 151, 151, 151),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(estado),
            Switch(
                activeColor: Colors.green,
                value: active,
                onChanged: (bool value) {
                  active = value;
                  _showDialog();
                  // setState(() {
                  //   _showDialog();
                  // });
                }),
          ],
        ),
        const Divider(
          height: 60,
          color: Color.fromARGB(50, 151, 151, 151),
        ),
        const Text("LM35"),
        const Divider(
          height: 60,
          color: Color.fromARGB(50, 151, 151, 151),
        ),
      ],
    );
  }

  Future<void> _showDialog() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: RichText(
                text: TextSpan(children: [
              const TextSpan(
                  text: "¿Deseas ",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
              TextSpan(
                  text: msgEstado,
                  style: const TextStyle(
                      color: Colors.red, fontWeight: FontWeight.bold)),
              const TextSpan(
                  text: " el sensor de humedad?",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold))
            ])),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("NO"),
              ),
              TextButton(
                onPressed: () {
                  debugPrint("PULSADO SI");
                  sensoresModelo.activo = active;
                  int fechaHoraAct = DateTime.now().millisecondsSinceEpoch;
                  sensoresModelo.fechaHora = fechaHoraAct ~/ 1000;

                  // print(DateTime.now().millisecondsSinceEpoch);
                  Future<bool> status = SensorProvider()
                      .editarSensor(sensoresModelo, "hum_higrometro");
                  status.then((value) =>
                      {Navigator.of(context).pop(), setState(() {})});
                },
                child: const Text("SI"),
              )
            ],
          );
        });
  }
}
