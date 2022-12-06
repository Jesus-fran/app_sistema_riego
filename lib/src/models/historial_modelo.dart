import 'dart:convert';

HistorialModelo actuadoresModeloFromJson(String str) =>
    HistorialModelo.fromJson(json.decode(str));

String historialModeloToJson(HistorialModelo data) =>
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

class HistorialModelo {
  bool activo;
  int fechaHora;

  HistorialModelo({
    this.activo = false,
    this.fechaHora = 0,
  });

  factory HistorialModelo.fromJson(Map<String, dynamic> json) =>
      HistorialModelo(
        activo: json["activo"],
        fechaHora: json["fecha_hora"],
      );

  Map<String, dynamic> toJson() => {
        "activo": activo,
        "fecha_hora": fechaHora,
      };
}
