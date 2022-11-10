// import 'package:app_riego/src/models/sensor_modelo.dart';
import 'package:flutter/material.dart';
import 'package:practica_apis/src/pages/humedad.dart';
import 'package:practica_apis/src/pages/mapa.dart';

class ListaPage extends StatelessWidget {
  // ListaPage({Key key}) : super(key: key);
  ListaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Center(
          child: Text("Sistema de riego"),
        )),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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
                decoration: BoxDecoration(color: Colors.green),
                margin: EdgeInsets.only(bottom: 50),
              ),
              ListTile(
                leading: Icon(
                  Icons.water_drop,
                  size: 30,
                  color: Color.fromARGB(255, 35, 196, 207),
                ),
                title: Text(
                  "Humedad",
                  style: TextStyle(fontSize: 20),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ListaHumedad()));
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.add_location,
                  size: 30,
                  color: Color.fromARGB(255, 26, 163, 56),
                ),
                title: Text(
                  "Localizacion",
                  style: TextStyle(fontSize: 20),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MapaEcotic()));
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
