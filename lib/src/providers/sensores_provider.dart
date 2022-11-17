import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:practica_apis/src/models/sensor_modelo.dart';

class SensorProvider {
  final _url = 'https://sistemariego-70eeb-default-rtdb.firebaseio.com';

  Future<List<SensorModelo>> leerHumedad() async {
    final List<SensorModelo> lista = [];
    final url = '$_url/tierra/humedad.json';
    final respuesta = await http.get(Uri.parse(url));
    final Map<String, dynamic> data = json.decode(respuesta.body);
    data.forEach((key, value) {
      SensorModelo sensorModelo = SensorModelo.fromJson(value);
      lista.add(sensorModelo);
    });
    return lista;
  }

  Future<List<SensorModelo>> leerCurrentHumedad() async {
    final List<SensorModelo> lista = [];
    final url =
        '$_url/tierra/humedad.json?orderBy="fecha"&limitToLast=1&print=pretty';
    final respuesta = await http.get(Uri.parse(url));
    final Map<String, dynamic> data = json.decode(respuesta.body);
    data.forEach((key, value) {
      SensorModelo sensorModelo = SensorModelo.fromJson(value);
      lista.add(sensorModelo);
    });
    return lista;
  }

  Future<List<SensorModelo>> leerTemperatura() async {
    final List<SensorModelo> lista = [];
    final url = '$_url/tierra/temperatura.json';
    final respuesta = await http.get(Uri.parse(url));
    final Map<String, dynamic> data = json.decode(respuesta.body);
    data.forEach((key, value) {
      SensorModelo sensorModelo = SensorModelo.fromJson(value);
      lista.add(sensorModelo);
    });
    return lista;
  }

  Future<List<SensorModelo>> leerCurrentTemperatura() async {
    final List<SensorModelo> lista = [];
    final url =
        '$_url/tierra/temperatura.json?orderBy="fecha"&limitToLast=1&print=pretty';
    final respuesta = await http.get(Uri.parse(url));
    final Map<String, dynamic> data = json.decode(respuesta.body);
    data.forEach((key, value) {
      SensorModelo sensorModelo = SensorModelo.fromJson(value);
      lista.add(sensorModelo);
    });
    return lista;
  }
}
