import 'package:flutter/material.dart';
import 'package:practica_apis/src/models/sensor_modelo.dart';
import 'package:practica_apis/src/pages/lista_humedad.dart';
import 'package:practica_apis/src/providers/sensores_provider.dart';
import 'package:pie_chart/pie_chart.dart';

class Humedad extends StatefulWidget {
  const Humedad({super.key});

  @override
  State<Humedad> createState() => _HumedadState();
}

class _HumedadState extends State<Humedad> {
  // Map<String, double> dataMap = {"Humedad": 0};

  final gradientList = <List<Color>>[
    [
      const Color.fromRGBO(223, 250, 92, 1),
      const Color.fromRGBO(129, 250, 112, 1),
    ],
    [
      const Color.fromRGBO(129, 182, 205, 1),
      const Color.fromRGBO(91, 253, 199, 1),
    ],
    [
      const Color.fromRGBO(175, 63, 62, 1.0),
      const Color.fromRGBO(254, 154, 92, 1),
    ]
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Humedad actual")),
        actions: [
          IconButton(
              tooltip: "Actualizar datos",
              onPressed: () {
                setState(() {});
              },
              icon: const Icon(Icons.replay_outlined))
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/fondo_humedad.jpg"), fit: BoxFit.cover),
        ),
        child: _currentHumedad(),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: const Color.fromARGB(195, 52, 182, 85),
        child: Container(
          height: 50.0,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint("Mostrar historial");
          showModalBottomSheet(
              isDismissible: true,
              isScrollControlled: true,
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height - 100),
              enableDrag: true,
              context: context,
              builder: (context) {
                return const ListaHumedad();
              });
        },
        tooltip: 'Historial de Humedad',
        child: const Icon(Icons.list_alt_rounded),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _currentHumedad() {
    final productoProvider = SensorProvider();
    return FutureBuilder(
        future: productoProvider.leerCurrentHumedad(),
        builder:
            (BuildContext context, AsyncSnapshot<List<SensorModelo>> snapshot) {
          if (snapshot.hasData) {
            return _circleHumedad(snapshot.data!);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Widget _circleHumedad(List<SensorModelo> datos) {
    int fechaHoraFb = datos[0].fecha * 1000;
    int fechaHoraAct = DateTime.now().millisecondsSinceEpoch;
    Duration fechaHoraDif = DateTimeRange(
            start: DateTime.fromMillisecondsSinceEpoch(fechaHoraFb),
            end: DateTime.fromMillisecondsSinceEpoch(fechaHoraAct))
        .duration;
    String tiempoRegistrado = "";

    if (fechaHoraDif.inSeconds <= 119) {
      tiempoRegistrado = "${fechaHoraDif.inSeconds} seg";
    } else if (fechaHoraDif.inMinutes >= 2 && fechaHoraDif.inMinutes <= 59) {
      tiempoRegistrado = "${fechaHoraDif.inMinutes} min";
    } else if (fechaHoraDif.inHours >= 1 && fechaHoraDif.inHours <= 23) {
      tiempoRegistrado = "${fechaHoraDif.inHours} hrs";
    } else {
      tiempoRegistrado = "${fechaHoraDif.inDays} d??a(s)";
    }

    Map<String, double> dataMap = {
      "Humedad": 100 - (((datos[0].valor) / 1023) * 100).round().toDouble(),
    };
    String msgHum = "";
    String msgAdvert = "";
    Color colorIcon = const Color.fromARGB(255, 33, 212, 243);
    if (datos[0].valor <= 199) {
      msgHum = "HUMEDAD MUY ALTA";
      msgAdvert = "??ALERTA! ";
      colorIcon = const Color.fromARGB(255, 0, 212, 250);
    } else if (datos[0].valor >= 200 && datos[0].valor <= 699) {
      msgHum = "HUMEDAD ??PTIMA";
      colorIcon = const Color.fromARGB(255, 33, 212, 243);
    } else {
      msgHum = "HUMEDAD BAJA";
      colorIcon = Colors.yellow.shade300;
    }

    return Column(
      children: [
        const Divider(
          height: 120,
          color: Color.fromARGB(0, 255, 255, 255),
        ),
        GestureDetector(
          onTap: () {
            debugPrint("Actualiza datos");
            setState(() {});
          },
          child: PieChart(
            dataMap: dataMap,
            animationDuration: const Duration(milliseconds: 5000),
            chartLegendSpacing: 32,
            chartRadius: MediaQuery.of(context).size.width / 1.5,
            totalValue: 100,
            // colorList: colorList,
            initialAngleInDegree: 0,
            chartType: ChartType.ring,
            baseChartColor: const Color.fromARGB(189, 51, 212, 159),
            ringStrokeWidth: 15,
            centerTextStyle: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 35),
            centerText:
                "${(100 - (((datos[0].valor) / 1023) * 100).round()).toString()} % ${datos[0].valor.toString()}",
            gradientList: gradientList,
            emptyColorGradient: const [
              Color(0xff6c5ce7),
              Colors.blue,
            ],
            legendOptions: const LegendOptions(
              showLegendsInRow: false,
              legendPosition: LegendPosition.bottom,
              showLegends: true,
              legendShape: BoxShape.circle,
              legendTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            chartValuesOptions: const ChartValuesOptions(
              showChartValueBackground: false,
              showChartValues: false,
              showChartValuesInPercentage: false,
              showChartValuesOutside: true,
              decimalPlaces: 0,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.watch_later_rounded,
              color: Colors.blue,
            ),
            Text(
              "  Hace $tiempoRegistrado",
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const Divider(
          height: 30,
          color: Color.fromARGB(0, 255, 255, 255),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.water_drop_rounded,
              color: colorIcon,
            ),
            RichText(
              text: TextSpan(
                text: msgAdvert,
                style: TextStyle(
                    color: Colors.red.shade300, fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                    text: msgHum,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        )
        // Text("Hola mundoadsfsa"),
      ],
    );
  }
}
