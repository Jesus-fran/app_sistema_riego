import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:practica_apis/src/models/actuadores_modelo.dart';
import 'package:practica_apis/src/models/sensor_modelo.dart';
import 'package:practica_apis/src/models/sensores_modelo.dart';

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

  Future<List<SensoresModelo>> leerSensor(String id) async {
    final List<SensoresModelo> lista = [];
    final url = '$_url/sensores/$id.json';
    final respuesta = await http.get(Uri.parse(url));
    final Map<String, dynamic> data = json.decode(respuesta.body);
    SensoresModelo sensoresModelo = SensoresModelo.fromJson(data);
    lista.add(sensoresModelo);
    return lista;
  }

  //   Future<bool> crear(TaskModelo tarea) async {
  //   //variables
  //   final _urlCrear = '$_url/tareas.json';
  //   final respuesta = await http.post(_urlCrear, body: taskModeloToJson(tarea));

  //   print("Subida exitosa!! " + "$respuesta");
  //   return true;
  // }

  //  Future<bool> eliminar(String id) async {
  //   //variables
  //   bool eliminado = false;
  //   final url = '$_url/tareas/$id.json';
  //   final respuesta = await http.delete(url);
  //   if (respuesta.body == null) {
  //     eliminado = true;
  //   }
  //   return eliminado;
  // }

  Future<bool> editarSensor(SensoresModelo sensorHumedad, String id) async {
    //variables
    bool editado = false;
    final url = '$_url/sensores/$id.json';
    final respuesta = await http.put(Uri.parse(url),
        body: sensoresModeloToJson(sensorHumedad));
    if (respuesta.statusCode == 200) {
      editado = true;
    }
    return editado;
  }

  Future<List<ActuadoresModelo>> getHistorialValvula() async {
    final List<ActuadoresModelo> lista = [];
    //Falta optimizar la consulta
    final url =
        '$_url/actuadores/valvula/historial.json?orderBy="fecha_hora"&limitToLast=1&print=pretty';
    final respuesta = await http.get(Uri.parse(url));
    final Map<String, dynamic> data = json.decode(respuesta.body);
    data.forEach((key, value) {
      ActuadoresModelo actuadoresModelo = ActuadoresModelo.fromJson(value);
      lista.add(actuadoresModelo);
    });
    return lista;
  }

  Future<List<ActuadoresModelo>> getAccionValvula() async {
    final List<ActuadoresModelo> lista = [];
    //Falta optimizar la consulta
    final url = '$_url/actuadores/valvula/accion.json';
    final respuesta = await http.get(Uri.parse(url));
    final Map<String, dynamic> data = json.decode(respuesta.body);
    // print(data);
    ActuadoresModelo actuadoresModelo = ActuadoresModelo.fromJson(data);
    lista.add(actuadoresModelo);
    // data.forEach((key, value) {
    //   ActuadoresModelo actuadoresModelo = ActuadoresModelo.fromJson(value);
    //   lista.add(actuadoresModelo);
    // });
    return lista;
  }

  Future<bool> registrarEncendido(ActuadoresModelo datos) async {
    //variables
    bool editado = false;
    final url = '$_url/actuadores/valvula/accion.json';
    final respuesta =
        await http.put(Uri.parse(url), body: actuadoresModeloToJson(datos));
    if (respuesta.statusCode == 200) {
      editado = true;
    }
    return editado;
  }
}
