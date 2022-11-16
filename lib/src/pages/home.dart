// import 'package:app_riego/src/models/sensor_modelo.dart';
import 'package:flutter/material.dart';
import 'package:practica_apis/src/pages/humedad.dart';
import 'package:practica_apis/src/pages/mapa.dart';

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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ListaHumedad()));
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.add_location,
                  size: 30,
                  color: Color.fromARGB(255, 26, 163, 56),
                ),
                title: const Text(
                  "Localizacion",
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
              )
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
