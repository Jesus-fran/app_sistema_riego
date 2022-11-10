import 'package:flutter/material.dart';
import 'package:practica_apis/routes/routes.dart';
import 'package:practica_apis/widgets/Error404.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      routes: getApplicationRoutes(),
      initialRoute: '/login',
      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            builder: (BuildContext context) => Error404Page());
      },
    );
  }
}
