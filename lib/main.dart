import 'package:flutter/material.dart';
import 'package:project_imc/home.dart';

void main() {
  runApp(
    MaterialApp(
      title: "Calculadora de IMC",
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: Home(),
    ),
  );
}

