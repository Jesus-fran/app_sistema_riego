// import 'package:app_riego/src/models/sensor_modelo.dart';
import 'package:flutter/material.dart';
import 'package:practica_apis/src/pages/humedad.dart';
import 'package:practica_apis/src/pages/mapa.dart';
import 'package:practica_apis/src/pages/temperatura.dart';

class ListaPage extends StatelessWidget {
  // ListaPage({Key key}) : super(key: key);
  const ListaPage({super.key});

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
                onTap: () {},
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
                onTap: () {},
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
          child: Image.asset(
            "images/logo2.jpg",
            height: 200,
            width: 200,
          ),
        ));
  }
}
