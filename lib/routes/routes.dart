import 'package:flutter/material.dart';
import 'package:practica_apis/src/pages/home.dart';
import 'package:practica_apis/src/pages/humedad.dart';
import 'package:practica_apis/src/pages/login.dart';
import 'package:practica_apis/src/pages/mapa.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    '/home': (BuildContext context) => const ListaPage(),
    '/humedad': (BuildContext context) => ListaHumedad(),
    '/login': (BuildContext context) => const Loginpage(),
    '/localizacion': (BuildContext context) => const MapaEcotic(),
  };
}
