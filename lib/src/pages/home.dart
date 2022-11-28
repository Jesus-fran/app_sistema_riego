// import 'package:app_riego/src/models/sensor_modelo.dart';
import 'package:flutter/material.dart';
import 'package:practica_apis/src/pages/humedad.dart';
import 'package:practica_apis/src/pages/mapa.dart';
import 'package:practica_apis/src/pages/temperatura.dart';
import 'package:practica_apis/src/providers/sensores_provider.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import '../models/actuadores_modelo.dart';

class ListaPage extends StatefulWidget {
  // ListaPage({Key key}) : super(key: key);
  const ListaPage({super.key});

  @override
  State<ListaPage> createState() => _ListaPageState();
}

class _ListaPageState extends State<ListaPage> {
  bool loanding = false;
  int _duration = 10;
  ActuadoresModelo actuadoresModelo = ActuadoresModelo();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Center(
          child: Text("Sistema de riego"),
        )),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                decoration: const BoxDecoration(color: Colors.green),
                margin: const EdgeInsets.only(bottom: 50),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "EcoTic",
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                    Icon(
                      Icons.dashboard,
                      size: 80.9,
                      color: Color.fromARGB(255, 24, 129, 89),
                    )
                  ],
                ),
              ),
              const Text(
                "Monitoreo",
                style: TextStyle(
                    color: Color.fromARGB(255, 24, 129, 89),
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              ListTile(
                leading: const Icon(
                  Icons.water_drop,
                  size: 30,
                  color: Color.fromARGB(255, 35, 196, 207),
                ),
                title: const Text(
                  "Humedad",
                  style: TextStyle(fontSize: 20),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Humedad()));
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.thermostat,
                  size: 30,
                  color: Color.fromARGB(255, 231, 227, 10),
                ),
                title: const Text(
                  "Temperatura",
                  style: TextStyle(fontSize: 20),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Temperatura()));
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.sensors_rounded,
                  size: 30,
                  color: Color.fromARGB(255, 100, 100, 100),
                ),
                title: const Text(
                  "Sensores",
                  style: TextStyle(fontSize: 20),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, '/sensores');
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.device_hub,
                  size: 30,
                  color: Color.fromARGB(255, 40, 59, 85),
                ),
                title: const Text(
                  "Actuadores",
                  style: TextStyle(fontSize: 20),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, '/actuadores');
                },
              ),
              const Divider(
                height: 10,
                color: Color.fromARGB(50, 151, 151, 151),
              ),
              const Text(
                "Empresa",
                style: TextStyle(
                    color: Color.fromARGB(255, 24, 129, 89),
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              ListTile(
                leading: const Icon(
                  Icons.add_location,
                  size: 30,
                  color: Color.fromARGB(255, 26, 163, 56),
                ),
                title: const Text(
                  "Localización",
                  style: TextStyle(fontSize: 20),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MapaEcotic()));
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.video_collection,
                  size: 30,
                  color: Colors.red,
                ),
                title: const Text(
                  "Videos",
                  style: TextStyle(fontSize: 20),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/videos');
                },
              ),
              const Divider(
                height: 10,
                color: Color.fromARGB(50, 151, 151, 151),
              ),
              const Text(
                "Cuenta",
                style: TextStyle(
                    color: Color.fromARGB(255, 24, 129, 89),
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              ListTile(
                leading: const Icon(
                  Icons.exit_to_app,
                  size: 30,
                  color: Colors.green,
                ),
                title: const Text(
                  "Cerrar sesión",
                  style: TextStyle(fontSize: 20),
                ),
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
            ],
          ),
        ),
        body: Center(
          child: _body(),
        ));
  }

  Widget _body() {
    return Column(
      children: [
        const Divider(
          height: 50,
          color: Colors.transparent,
        ),
        Expanded(
            child: RefreshIndicator(
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    // const Center(
                    //   child: Text(
                    //     "Regar plantas",
                    //     style: TextStyle(
                    //         fontSize: 15, fontWeight: FontWeight.bold),
                    //   ),
                    // ),
                    loanding == true
                        ? const LinearProgressIndicator()
                        : _getButton(),
                  ],
                ),
                onRefresh: () {
                  return Future(() {
                    setState(() {
                      debugPrint("Actualiza historial");
                    });
                  });
                })),
      ],
    );
  }

  Widget _getButton() {
    return FutureBuilder(
      future: SensorProvider().getHistorialValvula(),
      builder: (BuildContext context,
          AsyncSnapshot<List<ActuadoresModelo>> snapshot) {
        if (snapshot.hasData) {
          return FutureBuilder(
            future: SensorProvider().getAccionValvula(),
            builder: (BuildContext context,
                AsyncSnapshot<List<ActuadoresModelo>> snapshot1) {
              if (snapshot1.hasData) {
                return _button(snapshot.data!, snapshot1.data!);
              } else {
                return const LinearProgressIndicator();
              }
            },
          );
          // return _button(snapshot.data!);
        } else {
          return const LinearProgressIndicator();
        }
      },
    );
  }

  Widget _button(List<ActuadoresModelo> datos1, List<ActuadoresModelo> datos2) {
    if (datos1[0].activo == false) {
      // Si es false, significa que la electrovalvula está apagada
      int fechaHoraFb = datos2[0].fechaHora * 1000;
      int fechaHoraAct = DateTime.now().millisecondsSinceEpoch;
      if (fechaHoraAct < fechaHoraFb && datos2[0].activo == true) {
        // Si aun no llega el tiempo (si el tiempo actual es menor al de FBS) que está registrado, y si es true.
        // significa que hay un riego programado.
        Duration fechaHoraDif = DateTimeRange(
                start: DateTime.fromMillisecondsSinceEpoch(fechaHoraAct),
                end: DateTime.fromMillisecondsSinceEpoch(fechaHoraFb))
            .duration;

        _duration = fechaHoraDif.inSeconds;
        return _contador();
        // print(fechaHoraFb);
        // print(DateTime.fromMillisecondsSinceEpoch(fechaHoraFb));
        // return Column(
        //   children: [
        //     const Divider(
        //       height: 60,
        //       color: Color.fromRGBO(252, 117, 117, 0),
        //     ),
        //     const Text("Tiempo faltante: ",
        //         style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        //     // Text(DateTime.fromMillisecondsSinceEpoch(fechaHoraFb).toString()),
        //     const Divider(
        //       height: 10,
        //       color: Colors.transparent,
        //     ),
        //     Text(fechaHoraDif.inSeconds.toString(),
        //         style:
        //             const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        //   ],
        // );
      } else {
        //Si el tiempo ya pasó (tiempo actual es mayor al de FBS) significa que la electrovalvula está apagada
        //Significa que puede programarse un riego
        return Column(
          children: [
            const Divider(
              height: 10,
              color: Colors.transparent,
            ),
            const Text(
              "Activar el riego ahora mismo: ",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(
              height: 20,
              color: Colors.transparent,
            ),
            const Icon(Icons.arrow_right_alt_rounded),
            const Divider(
              height: 20,
              color: Colors.transparent,
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "La electroválvula se activara por varios segundos y comenzará a pasar el flujo de agua para humedecer la tierra.",
                style: TextStyle(fontSize: 15),
                textAlign: TextAlign.justify,
              ),
            ),
            SizedBox(
              height: 70,
              // width: 200,
              child: FittedBox(
                fit: BoxFit.fill,
                child: Switch(
                  // inactiveThumbColor: Colors.blueGrey.shade600,
                  // inactiveTrackColor: Color.fromARGB(255, 216, 8, 8),
                  activeColor: Colors.green,
                  value: datos1[0].activo,
                  onChanged: (value) {
                    _showDialog();
                  },
                ),
              ),
            ),
            const Divider(
              height: 50,
              color: Colors.grey,
            ),
            const Text(
              "Programar riego: ",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(
              height: 20,
              color: Colors.transparent,
            ),
            const Icon(Icons.alarm_add_rounded),
            const Divider(
              height: 20,
              color: Colors.transparent,
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Cuando llegué el tiempo establecido la electroválvula se activara por varios segundos y comenzará a pasar el flujo de agua para humedecer la tierra.",
                style: TextStyle(fontSize: 15),
                textAlign: TextAlign.justify,
              ),
            ),
            const Divider(
              height: 20,
              color: Colors.transparent,
            ),
            IconButton(
                iconSize: 50,
                onPressed: () {
                  displayTimePicker(context);
                },
                icon: Icon(
                  color: Colors.grey[350],
                  Icons.add_circle_outlined,
                )),
          ],
        );
      }
    } else {
      // Si no es false, entonces es true, significa que está regando...
      return const Center(
        child: Text("Regando...",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
      );
    }
  }

  Future<void> _showDialog() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("¿Estás seguro de regar la planta?"),
            content: const Text(
                "La electroválvula se encenderá y permitira el flujo de agua"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("NO"),
              ),
              TextButton(
                onPressed: () {
                  // _regar();
                  Navigator.of(context).pop();
                  setState(() {
                    loanding = true;
                  });
                  actuadoresModelo.activo = true;
                  int fechaHoraAct =
                      DateTime.now().millisecondsSinceEpoch + 3000;
                  actuadoresModelo.fechaHora = fechaHoraAct ~/ 1000;
                  // print(fechaHoraAct);
                  Future<bool> status =
                      SensorProvider().registrarEncendido(actuadoresModelo);
                  status.then((value) => {
                        setState(() {
                          loanding = false;
                        })
                      });
                },
                child: const Text("SI"),
              ),
            ],
          );
        });
  }

  Widget _contador() {
    return Column(
      children: [
        const Divider(
          height: 60,
          color: Colors.transparent,
        ),
        Row(
          children: const [
            Padding(
              padding: EdgeInsets.only(left: 60),
              child: Text(
                "Hay un riego programado",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Icon(Icons.alarm_sharp, color: Colors.green),
          ],
        ),
        const Divider(
          height: 30,
          color: Colors.transparent,
        ),
        const Text(
          "Comenzará a regarse en: ",
          style: TextStyle(fontSize: 15),
        ),
        CircularCountDownTimer(
          width: MediaQuery.of(context).size.width / 2,
          height: MediaQuery.of(context).size.height / 2,
          duration: _duration + 2,
          isReverse: true,
          fillColor: Colors.green[400]!,
          ringColor: Colors.grey[300]!,
          onComplete: () {
            setState(() {});
          },
        ),
        TextButton(
          onPressed: () {
            setState(() {
              loanding = true;
            });
            actuadoresModelo.activo = false;
            actuadoresModelo.fechaHora = 0;
            Future<bool> status =
                SensorProvider().cancelarRiego(actuadoresModelo);
            status.then((value) => {
                  setState(() {
                    loanding = false;
                  })
                });
          },
          child: const Text(
            "Cancelar riego",
            style: TextStyle(color: Colors.green),
          ),
        )
      ],
    );
  }

  Future displayTimePicker(BuildContext context) async {
    var time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(
            hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute + 1));

    if (time != null) {
      DateTime dateTimeActual = DateTime.now();
      int programTime = DateTime(dateTimeActual.year, dateTimeActual.month,
              dateTimeActual.day, time.hour, time.minute)
          .millisecondsSinceEpoch;

      setState(() {
        loanding = true;
      });
      actuadoresModelo.activo = true;
      actuadoresModelo.fechaHora = programTime ~/ 1000;
      Future<bool> status =
          SensorProvider().registrarEncendido(actuadoresModelo);
      status.then((value) => {
            setState(() {
              loanding = false;
            })
          });
    }
  }
}
