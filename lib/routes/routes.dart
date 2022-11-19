import 'package:flutter/material.dart';
import 'package:practica_apis/src/pages/home.dart';
import 'package:practica_apis/src/pages/humedad.dart';
import 'package:practica_apis/src/pages/login.dart';
import 'package:practica_apis/src/pages/mapa.dart';
import 'package:practica_apis/src/pages/sensores.dart';
import 'package:practica_apis/src/pages/videos.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    '/home': (BuildContext context) => const ListaPage(),
    '/humedad': (BuildContext context) => const Humedad(),
    '/login': (BuildContext context) => const Loginpage(),
    '/localizacion': (BuildContext context) => const MapaEcotic(),
    '/videos': (BuildContext context) => const Videos(),
    '/sensores': (BuildContext context) => const Sensores(),
  };
}
