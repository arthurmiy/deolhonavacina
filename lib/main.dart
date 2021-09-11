import 'package:deolhonafila/interface/home.dart';
import 'package:deolhonafila/interface/map.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'De olho na Fila',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        HomePage.route: (context) => HomePage(),
        MapView.route: (context) => MapView(),
      },
    );
  }
}
