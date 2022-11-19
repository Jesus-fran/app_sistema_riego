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
  bool activeLm35 = false;
  String estado = "";
  String estadoLm35 = "";
  String msgEstado = "";
  String msgContenido = "";
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
    DateTime fechaHora2 =
        DateTime.fromMillisecondsSinceEpoch(datos[1].fechaHora * 1000);
    if (datos[0].activo) {
      estado = "Encendido";
      active = true;
      msgEstado = "apagar";
      msgContenido = "";
    } else {
      estado = "Apagado";
      active = false;
      msgEstado = "encender";
      msgContenido =
          "Recuerda que mantener mucho tiempo encendido puede dañar la vida útil del Higrómetro";
    }
    if (datos[1].activo) {
      estadoLm35 = "Encendido";
      activeLm35 = true;
    } else {
      estadoLm35 = "Apagado";
      activeLm35 = false;
    }

    return Column(
      children: [
        const Divider(
          height: 60,
          color: Color.fromARGB(50, 151, 151, 151),
        ),
        const Text(
          "Higrómetro",
          style: TextStyle(fontSize: 20),
        ),
        const Divider(
          height: 60,
          color: Color.fromARGB(50, 151, 151, 151),
        ),
        Text("Fecha del útimo cambio",
            style: TextStyle(
                color: Colors.green.shade600,
                fontWeight: FontWeight.bold,
                fontSize: 15)),
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
                text: meses[fechaHora.month - 1],
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
                color: Colors.green.shade600,
                fontWeight: FontWeight.bold,
                fontSize: 15)),
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
          color: Color.fromARGB(158, 151, 151, 151),
        ),
        const Text(
          "LM35",
          style: TextStyle(fontSize: 20),
        ),
        const Divider(
          height: 60,
          color: Color.fromARGB(50, 151, 151, 151),
        ),
        Text("Fecha del último cambio",
            style: TextStyle(
                color: Colors.green.shade600,
                fontWeight: FontWeight.bold,
                fontSize: 15)),
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
                text: fechaHora2.day.toString(),
                style: const TextStyle(color: Colors.green)),
            const TextSpan(text: " de ", style: TextStyle(color: Colors.black)),
            TextSpan(
                text: meses[fechaHora2.month - 1],
                style: const TextStyle(color: Colors.green)),
            const TextSpan(
                text: " del ", style: TextStyle(color: Colors.black)),
            TextSpan(
                text: fechaHora2.year.toString(),
                style: const TextStyle(color: Colors.green)),
            const TextSpan(
                text: " a las  ", style: TextStyle(color: Colors.black)),
            TextSpan(
                text:
                    "${fechaHora2.hour.toString()}:${fechaHora2.minute.toString()}:${fechaHora2.second.toString()}",
                style: const TextStyle(color: Colors.green)),
          ])),
        ),
        const Divider(
          height: 15,
          color: Color.fromARGB(0, 151, 151, 151),
        ),
        Text("Estado actual",
            style: TextStyle(
                color: Colors.green.shade600,
                fontWeight: FontWeight.bold,
                fontSize: 15)),
        const Divider(
          height: 15,
          color: Color.fromARGB(0, 151, 151, 151),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(estadoLm35),
            Switch(
                activeColor: Colors.green,
                value: activeLm35,
                onChanged: (value) {
                  _showDialogLm35();
                }),
          ],
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
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              TextSpan(
                  text: msgEstado,
                  style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
              const TextSpan(
                  text: " el sensor de humedad?",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18))
            ])),
            content: Text(msgContenido),
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

  Future<void> _showDialogLm35() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
                "No es posible encender o apagar este sensor, no está conectado a un réle."),
            content: const Text(
                "Su estado no afecta el funcionamiento y vida del LM35"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("ACEPTAR"),
              ),
            ],
          );
        });
  }
}
