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
  String msgContenido = "";
  SensoresModelo sensoresModelo = SensoresModelo();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text("Sensores")),
        ),
        body: _body());
  }

  Widget _body() {
    return ListView(
      children: [
        const Divider(
          height: 50,
          color: Colors.transparent,
        ),
        const Text(
          "Higrómetro - FC28",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
        Image.asset(
          "images/FC28.png",
          height: 100,
          width: 100,
        ),
        const Divider(
          height: 10,
          color: Colors.transparent,
        ),
        const Text(
          "Lee la humedad actual de la tierra",
          textAlign: TextAlign.center,
          style: TextStyle(),
        ),
        Row(
          children: const [
            Padding(
              padding: EdgeInsets.all(18.5),
              child: Text(
                "Detalles del sensor:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            )
          ],
        ),
        FutureBuilder(
          future: SensorProvider().leerSensor("hum_higrometro"),
          builder: (BuildContext context,
              AsyncSnapshot<List<SensoresModelo>> snapshot) {
            if (snapshot.hasData) {
              return _detalles(snapshot.data!, 0);
            } else {
              return const LinearProgressIndicator();
            }
          },
        ),
        const Divider(
          height: 60,
          color: Colors.grey,
        ),
        const Text(
          "LM35",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
        const Divider(
          height: 20,
          color: Colors.transparent,
        ),
        Image.asset(
          "images/lm35.png",
          height: 100,
          width: 100,
        ),
        const Divider(
          height: 10,
          color: Colors.transparent,
        ),
        const Text(
          "Lee la temperatura actual del ambiente",
          textAlign: TextAlign.center,
          style: TextStyle(),
        ),
        Row(
          children: const [
            Padding(
              padding: EdgeInsets.all(18.5),
              child: Text(
                "Detalles del sensor:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            )
          ],
        ),
        FutureBuilder(
          future: SensorProvider().leerSensor("temp_lm35"),
          builder: (BuildContext context,
              AsyncSnapshot<List<SensoresModelo>> snapshot) {
            if (snapshot.hasData) {
              return _detalles(snapshot.data!, 1);
            } else {
              return const LinearProgressIndicator();
            }
          },
        ),
        const Divider(
          height: 50,
          color: Colors.transparent,
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

  Widget _detalles(List<SensoresModelo> datos, int numSensor) {
    String fecha = "";
    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(datos[0].fechaHora * 1000);
    fecha =
        "${dateTime.day} de ${meses[dateTime.month - 1]} del ${dateTime.year}";

    DateTime fechaHora =
        DateTime.fromMillisecondsSinceEpoch(datos[0].fechaHora * 1000);

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

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 18.5, right: 18.5),
              child: Text(
                estado,
              ),
            ),
            Switch(
              activeColor: Colors.green,
              value: active,
              onChanged: numSensor == 1
                  ? (value) {
                      _showDialogLm35();
                    }
                  : (bool value) {
                      active = value;
                      _showDialog();
                    },
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
            Text(fecha),
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
            Text(
                "${fechaHora.hour.toString()}:${fechaHora.minute.toString()}:${fechaHora.second.toString()}"),
          ],
        ),
      ],
    );
  }
}
