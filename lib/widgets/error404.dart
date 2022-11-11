import 'package:flutter/material.dart';

class Error404Page extends StatelessWidget {
  const Error404Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.red,
        child: const Center(
          child: ListTile(
            title: Text('Error 404',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24),
                textAlign: TextAlign.center),
            subtitle: Text('Página no encontrada.',
                style: TextStyle(color: Colors.white, fontSize: 18),
                textAlign: TextAlign.center),
          ),
        ),
      ),
    );
  }
}
