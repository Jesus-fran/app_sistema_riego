import 'dart:convert';

SensoresModelo sensoresModeloFromJson(String str) =>
    SensoresModelo.fromJson(json.decode(str));

String sensoresModeloToJson(SensoresModelo data) => json.encode(data.toJson());
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

class SensoresModelo {
  bool activo;
  int fechaHora;

  SensoresModelo({
    this.activo = false,
    this.fechaHora = 0,
  });

  factory SensoresModelo.fromJson(Map<String, dynamic> json) => SensoresModelo(
        activo: json["activo"],
        fechaHora: json["fecha_hora"],
      );

  Map<String, dynamic> toJson() => {
        //  "id": id,
        "activo": activo,
        "fecha_hora": fechaHora,
      };
}
