import 'dart:convert';

SensorModelo sensorModeloFromJson(String str) =>
    SensorModelo.fromJson(json.decode(str));

String sensorModeloToJson(SensorModelo data) => json.encode(data.toJson());

class SensorModelo {
  SensorModelo({
    this.fecha = 0,
    this.valor = 0,
  });

  int fecha;
  int valor;

  factory SensorModelo.fromJson(Map<String, dynamic> json) => SensorModelo(
        fecha: json["fecha"],
        valor: json["valor"],
      );

  Map<String, dynamic> toJson() => {
        //  "id": id,
        "fecha": fecha,
        "valor": valor,
      };
}
