// Este archivo contiene el widget ShelterDetailScreen, que muestra los detalles de un refugio específico.
// Incluye un mapa que muestra la ubicación del refugio, junto con varios detalles, como la ciudad, el coordinador, el número de teléfono y la capacidad.

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

// Pantalla que muestra los detalles de un albergue específico.
class ShelterDetailScreen extends StatelessWidget {
  final Map<String, dynamic> shelter;

  const ShelterDetailScreen({required this.shelter});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalles de albergue"), // Título de la barra de navegación.
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card con el mapa y detalles del albergue
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Mapa de OpenStreetMap con marcador
                    SizedBox(
                      height: 300,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: FlutterMap(
                          options: MapOptions(
                            center: LatLng(
                              double.parse(
                                shelter['lat'].toString(),
                              ), // Latitud.
                              double.parse(
                                shelter['lng'].toString(),
                              ), // Longitud.
                            ),
                            zoom: 15,
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                              subdomains: ['a', 'b', 'c'],
                            ),
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: LatLng(
                                    double.parse(shelter['lat'].toString()),
                                    double.parse(shelter['lng'].toString()),
                                  ),
                                  width: 80,
                                  height: 80,
                                  builder:
                                      (context) => Icon(
                                        Icons.location_pin,
                                        color: Colors.red,
                                        size: 40,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ), // Espaciado entre el mapa y los detalles.
                    Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.home,
                            size: 60,
                            color: Colors.blueAccent,
                          ), // Icono principal.
                          SizedBox(height: 8),
                          Text(
                            shelter['edificio'], // Nombre del albergue.
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(thickness: 1, height: 32), // Línea divisoria.
                    _buildDetailRow(
                      Icons.location_city,
                      'Ciudad',
                      shelter['ciudad'],
                    ),
                    _buildDetailRow(
                      Icons.person,
                      'Coordinador',
                      shelter['coordinador'],
                    ),
                    _buildDetailRow(
                      Icons.phone,
                      'Teléfono',
                      shelter['telefono'],
                    ),
                    _buildDetailRow(
                      Icons.people,
                      'Capacidad',
                      shelter['capacidad'],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Método para crear filas de detalle con íconos.
  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent), // Icono representativo.
          SizedBox(width: 16),
          Text(
            '$label:', // Etiqueta del campo.
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              value, // Valor del campo.
              style: TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
