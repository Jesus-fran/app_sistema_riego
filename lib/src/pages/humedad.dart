import 'package:flutter/material.dart';
import 'package:practica_apis/src/models/sensor_modelo.dart';
import 'package:practica_apis/src/providers/sensores_provider.dart';
import 'package:pie_chart/pie_chart.dart';

class ListaHumedad extends StatefulWidget {
  const ListaHumedad({super.key});

  @override
  State<ListaHumedad> createState() => _ListaHumedadState();
}

class _ListaHumedadState extends State<ListaHumedad> {
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
        title: const Center(child: Text("Humedad")),
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
                return _humedad();
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
      tiempoRegistrado = "${fechaHoraDif.inDays} día(s)";
    }

    Map<String, double> dataMap = {
      "Humedad": 100 - (((datos[0].valor) / 1023) * 100).round().toDouble(),
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
              "Hace $tiempoRegistrado",
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        )
        // Text("Hola mundoadsfsa"),
      ],
    );
  }

  Widget _humedad() {
    final productoProvider = SensorProvider();
    return FutureBuilder(
        future: productoProvider.leerHumedad(),
        builder:
            (BuildContext context, AsyncSnapshot<List<SensorModelo>> snapshot) {
          if (snapshot.hasData) {
            return _listadeHumedad(snapshot.data!.reversed.toList());
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Widget _listadeHumedad(List<SensorModelo> datos) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          const Text(
            "Historial de humedad",
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 26, 77, 27)),
          ),
          Expanded(
            child: ListView.separated(
              primary: false,
              shrinkWrap: true,
              itemBuilder: (context, index) => ListTile(
                leading:
                    const Icon(Icons.water_drop_rounded, color: Colors.blue),
                title: Text(
                    "Porcentaje: ${(100 - (((datos[index].valor) / 1023) * 100).round()).toString()} %  Valor real: ${datos[index].valor.toString()}"),
                subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          "Fecha: ${DateTime.fromMillisecondsSinceEpoch(datos[index].fecha * 1000).day.toString()}-${DateTime.fromMillisecondsSinceEpoch(datos[index].fecha * 1000).month.toString()}-${DateTime.fromMillisecondsSinceEpoch(datos[index].fecha * 1000).year.toString()}"),
                      Text(
                          "Hora: ${DateTime.fromMillisecondsSinceEpoch(datos[index].fecha * 1000).hour.toString()}:${DateTime.fromMillisecondsSinceEpoch(datos[index].fecha * 1000).minute.toString()}:${DateTime.fromMillisecondsSinceEpoch(datos[index].fecha * 1000).second.toString()}"),
                    ]),
                // trailing: Text(
                //     "Fecha: ${DateTime.fromMillisecondsSinceEpoch(datos[index].fecha * 1000).day.toString()}-${DateTime.fromMillisecondsSinceEpoch(datos[index].fecha * 1000).month.toString()}-${DateTime.fromMillisecondsSinceEpoch(datos[index].fecha * 1000).year.toString()}"),
              ),
              itemCount: datos.length,
              separatorBuilder: (context, index) => const Divider(
                color: Color.fromARGB(255, 179, 180, 179),
                height: 50,
              ),
            ),
          )
        ],
      ),
    );
  }
}
