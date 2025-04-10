// Este archivo contiene el modelo de datos para los albergues y la función para obtener los datos desde una API externa.

import 'package:http/http.dart' as http; // Paquete para realizar solicitudes HTTP.
import 'dart:convert'; // Paquete para trabajar con JSON.

// Modelo de datos para representar un Albergue.
class Shelter {
  final String ciudad; // Ciudad donde se encuentra el albergue.
  final String codigo; // Código único del albergue.
  final String edificio; // Nombre del edificio.
  final String coordinador; // Nombre del coordinador.
  final String telefono; // Teléfono de contacto.
  final String capacidad; // Capacidad máxima del albergue.
  final double lat; // Latitud para ubicación en mapa.
  final double lng; // Longitud para ubicación en mapa.

  Shelter({
    required this.ciudad,
    required this.codigo,
    required this.edificio,
    required this.coordinador,
    required this.telefono,
    required this.capacidad,
    required this.lat,
    required this.lng,
  });

  // Método de fábrica para convertir datos JSON en un objeto Shelter.
  factory Shelter.fromJson(Map<String, dynamic> json) {
    return Shelter(
      ciudad: json['ciudad'],
      codigo: json['codigo'],
      edificio: json['edificio'],
      coordinador: json['coordinador'],
      telefono: json['telefono'],
      capacidad: json['capacidad'],
      lat: double.parse(json['lat']),
      lng: double.parse(json['lng']),
    );
  }
}

// Función que obtiene los datos de los albergues desde una API externa.
Future<List<dynamic>> fetchShelters() async {
  final response = await http.get(Uri.parse('https://adamix.net/defensa_civil/def/albergues.php'));
  
  if (response.statusCode == 200) {
    // Decodifica el cuerpo del JSON y retorna la lista de datos.
    return json.decode(response.body)['datos'];
  } else {
    // Lanza una excepción si ocurre un error durante la solicitud.
    throw Exception('Error al cargar los datos');
  }
}
