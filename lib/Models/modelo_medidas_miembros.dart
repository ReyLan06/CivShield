// En este archivo se definen los modelos y funciones para obtener datos de la API de medidas preventivas y miembros.

import 'package:http/http.dart' as http; // Paquete para realizar solicitudes HTTP.
import 'dart:convert'; // Paquete para trabajar con JSON.

// Modelo para Medidas Preventivas
class PreventiveMeasure {
  final String id;
  final String titulo;
  final String descripcion;

  PreventiveMeasure({
    required this.id,
    required this.titulo,
    required this.descripcion,
  });

  factory PreventiveMeasure.fromJson(Map<String, dynamic> json) {
    return PreventiveMeasure(
      id: json['id'],
      titulo: json['titulo'],
      descripcion: json['descripcion'],
    );
  }
}

// Modelo para Miembros
class Member {
  final String id;
  final String nombre;
  final String cargo;
  final String foto;

  Member({
    required this.id,
    required this.nombre,
    required this.cargo,
    required this.foto,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id'],
      nombre: json['nombre'],
      cargo: json['cargo'],
      foto: json['foto'],
    );
  }
}

// Funciones para obtener datos de la API
Future<List<dynamic>> fetchMedidasPreventivas() async {
  final response = await http.get(Uri.parse('https://adamix.net/defensa_civil/def/medidas_preventivas.php'));
  
  if (response.statusCode == 200) {
    return json.decode(response.body)['datos'];
  } else {
    throw Exception('Error al cargar las medidas preventivas');
  }
}

Future<List<dynamic>> fetchMiembros() async {
  final response = await http.get(Uri.parse('https://adamix.net/defensa_civil/def/miembros.php'));
  
  if (response.statusCode == 200) {
    return json.decode(response.body)['datos'];
  } else {
    throw Exception('Error al cargar los miembros');
  }
}