import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ActualLocalizacion extends StatefulWidget {
  const ActualLocalizacion({super.key});

  @override
  State<ActualLocalizacion> createState() => _ActualLocalizacionState();
}

class _ActualLocalizacionState extends State<ActualLocalizacion> {
  String latitud = "";
  String longitud = "";
  String msg = "Obtener mi ubicación actual";
  String msgErr = "";
  bool loanding = false;

  Future<Position> _getUbicacion() async {
    bool serviceOn = await Geolocator.isLocationServiceEnabled();
    if (!serviceOn) {
      setState(() {
        msgErr = "Servicio de localización está desactivado";
      });
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          msgErr = "Permiso de localización está denegado";
        });
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        msgErr = "Permiso de localización está denegado permanentemente";
      });
    }

    return await Geolocator.getCurrentPosition();
  }

  final Completer<GoogleMapController> _controller = Completer();

  CameraPosition cameraPosition = const CameraPosition(
    target: LatLng(18.1138923, -90.9871263),
    zoom: 1.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("Mi ubicación actual"),
        ),
      ),
      body: ListView(
        children: [
          const Divider(
            color: Colors.transparent,
            height: 100,
          ),
          loanding == true
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : msgErr == ""
                  ? Center(
                      child: Column(
                      children: [
                        Text(
                          msg,
                          style: const TextStyle(fontSize: 20),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          height: MediaQuery.of(context).size.height,
                          child: GoogleMap(
                            mapType: MapType.hybrid,
                            initialCameraPosition: cameraPosition,
                          ),
                        )
                      ],
                    ))
                  : Center(
                      child: Column(
                      children: [
                        Text(
                          msgErr,
                          style:
                              const TextStyle(fontSize: 15, color: Colors.red),
                        ),
                        const Icon(
                          Icons.error,
                          color: Colors.red,
                        )
                      ],
                    )),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: Colors.white,
        child: Container(
          height: 50.0,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          setState(() {
            loanding = true;
          });
          _getUbicacion().then((value) => {
                cameraPosition = CameraPosition(
                  target: LatLng(value.latitude, value.longitude),
                  zoom: 19.151926040649414,
                ),
                latitud = '${value.latitude}',
                longitud = '${value.longitude}',
                setState(() {
                  loanding = false;
                  msg = "Latitud: $latitud  Longitud: $longitud";
                }),
              });
        },
        tooltip: 'Mi ubicación',
        child: const Icon(Icons.location_on),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
