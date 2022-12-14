import 'dart:convert';

ActuadoresModelo actuadoresModeloFromJson(String str) =>
    ActuadoresModelo.fromJson(json.decode(str));

String actuadoresModeloToJson(ActuadoresModelo data) =>
    json.encode(data.toJson());
List<String> meses = [
  "Enero",
  "Febrero",
  "Marzo",
  "Abril",
  "Mayo",
  "Junio",
  "Julio",
  "Agosto",
  "Septiembre",
  "Octubre",
  "Noviembre",
  "Diciembre"
];

class ActuadoresModelo {
  bool activo;
  int fechaHora;
  bool programed;

  ActuadoresModelo({
    this.activo = false,
    this.fechaHora = 0,
    this.programed = false,
  });

  factory ActuadoresModelo.fromJson(Map<String, dynamic> json) =>
      ActuadoresModelo(
        activo: json["activo"],
        fechaHora: json["fecha_hora"],
        programed: json["programed"],
      );

  Map<String, dynamic> toJson() => {
        "activo": activo,
        "fecha_hora": fechaHora,
        "programed": programed,
      };
}
