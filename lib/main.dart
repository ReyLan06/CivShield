import 'package:civshield/views/albergues_screen.dart';
import 'package:civshield/views/medidas_preventivas_screen.dart';
import 'package:civshield/views/miembros_screen.dart';
import 'package:flutter/material.dart';

// Todas las vistas y pantallas estan en la carpeta views
// La carpeta models contiene los modelos de datos

void main() => runApp(const MyApp());

// Clase principal de la aplicación.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Desactiva la etiqueta de depuración.
      title: 'Material App', // Título de la aplicación.
      home: ShelterListScreen(), // Pantalla inicial.
    );
  }
}



