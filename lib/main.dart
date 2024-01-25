import 'dart:convert';
import 'package:flutter/material.dart';
import 'route_generator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: HomePage(),
      theme: ThemeData(
        primaryColor: Colors.blue,
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      onGenerateRoute: RouteGenerator.routeGenerator,
    );
  }
}





  

