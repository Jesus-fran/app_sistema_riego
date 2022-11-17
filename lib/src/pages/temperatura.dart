import 'package:flutter/material.dart';
import 'package:practica_apis/src/models/sensor_modelo.dart';
import 'package:practica_apis/src/pages/lista_temperatura.dart';
import 'package:practica_apis/src/providers/sensores_provider.dart';
import 'package:pie_chart/pie_chart.dart';

class Temperatura extends StatefulWidget {
  const Temperatura({super.key});

  @override
  State<Temperatura> createState() => _TemperaturaState();
}

class _TemperaturaState extends State<Temperatura> {
  // Map<String, double> dataMap = {"Humedad": 0};

  final gradientList = <List<Color>>[
    [
      const Color.fromARGB(255, 241, 245, 6),
      const Color.fromARGB(255, 226, 60, 9),
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Temperatura actual")),
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
          color: Color.fromARGB(255, 52, 121, 155),
          image: DecorationImage(
              image: AssetImage("images/fondo_temp.jpg"), fit: BoxFit.cover),
        ),
        child: _currentTemperatura(),
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
                return const ListaTemperatura();
              });
        },
        tooltip: 'Historial de temperatura',
        child: const Icon(Icons.list_alt_rounded),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _currentTemperatura() {
    final productoProvider = SensorProvider();
    return FutureBuilder(
        future: productoProvider.leerCurrentTemperatura(),
        builder:
            (BuildContext context, AsyncSnapshot<List<SensorModelo>> snapshot) {
          if (snapshot.hasData) {
            return _circleTemperatura(snapshot.data!);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Widget _circleTemperatura(List<SensorModelo> datos) {
    // Diferencia de tiempo actual-ult registr
    int fechaHoraFb = datos[0].fecha * 1000;
    int fechaHoraAct = DateTime.now().millisecondsSinceEpoch;
    Duration fechaHoraDif = DateTimeRange(
            start: DateTime.fromMillisecondsSinceEpoch(fechaHoraFb),
            end: DateTime.fromMillisecondsSinceEpoch(fechaHoraAct))
        .duration;
    String tiempoRegistrado = "";
    // Cuanto tiempo pasó desde el ult registro
    if (fechaHoraDif.inSeconds <= 119) {
      tiempoRegistrado = "${fechaHoraDif.inSeconds} seg";
    } else if (fechaHoraDif.inMinutes >= 2 && fechaHoraDif.inMinutes <= 59) {
      tiempoRegistrado = "${fechaHoraDif.inMinutes} min";
    } else if (fechaHoraDif.inHours >= 1 && fechaHoraDif.inHours <= 23) {
      tiempoRegistrado = "${fechaHoraDif.inHours} hrs";
    } else {
      tiempoRegistrado = "${fechaHoraDif.inDays} día(s)";
    }

    // Tipo temperatura
    String msgTemp = "xd";
    Color colorIcon = const Color.fromARGB(255, 134, 124, 26);
    if (datos[0].valor <= 20) {
      msgTemp = "TEMPERATURA ÓPTIMA";
      colorIcon = const Color.fromARGB(255, 35, 46, 202);
    } else if (datos[0].valor >= 21 && datos[0].valor <= 35) {
      msgTemp = "TEMPERATURA ÓPTIMA";
      colorIcon = Colors.yellow;
    } else if (datos[0].valor >= 36 && datos[0].valor <= 45) {
      msgTemp = "TEMPERATURA ÓPTIMA";
      colorIcon = Colors.yellowAccent.shade700;
    } else if (datos[0].valor >= 46 && datos[0].valor <= 55) {
      msgTemp = "¡TEMPERATURA MUY ALTA!";
      colorIcon = Colors.red;
    } else {
      msgTemp = "¡TEMPERATURA EXTREMADAMENTE ALTA!";
      colorIcon = Colors.red.shade900;
    }

    Map<String, double> dataMap = {
      "Temperatura": datos[0].valor.toDouble(),
    };

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
            baseChartColor: const Color.fromARGB(115, 91, 168, 219),
            ringStrokeWidth: 15,
            centerTextStyle: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 35),
            centerText: "${datos[0].valor} °C",
            gradientList: gradientList,
            // emptyColorGradient: const [
            //   Color(0xff6c5ce7),
            //   Colors.blue,
            // ],
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
              Icons.thermostat,
              color: colorIcon,
              size: 40,
            ),
            Text(
              msgTemp,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}
