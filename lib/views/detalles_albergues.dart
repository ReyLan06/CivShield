import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class ShelterDetailScreen extends StatelessWidget {
  final Map<String, dynamic> shelter;

  const ShelterDetailScreen({required this.shelter});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalles de albergue"),
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
                              _parseDouble(shelter['lat'], 0.0),
                              _parseDouble(shelter['lng'], 0.0),
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
                                    _parseDouble(shelter['lat'], 0.0),
                                    _parseDouble(shelter['lng'], 0.0),
                                  ),
                                  width: 80,
                                  height: 80,
                                  builder: (context) => Icon(
                                    Icons.location_on,
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
                    SizedBox(height: 16),
                    Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.home,
                            size: 60,
                            color: Colors.blueAccent,
                          ),
                          SizedBox(height: 8),
                          Text(
                            shelter['edificio'] ?? 'Nombre no disponible',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(thickness: 1, height: 32),
                    _buildDetailRow(
                      Icons.location_city,
                      'Ciudad',
                      shelter['ciudad'] ?? 'No disponible',
                    ),
                    _buildDetailRow(
                      Icons.person,
                      'Coordinador',
                      shelter['coordinador'] ?? 'No disponible',
                    ),
                    _buildDetailRow(
                      Icons.phone,
                      'Teléfono',
                      shelter['telefono'] ?? 'No disponible',
                    ),
                    _buildDetailRow(
                      Icons.people,
                      'Capacidad',
                      shelter['capacidad'] ?? 'No disponible',
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
          Icon(icon, color: Colors.blueAccent),
          SizedBox(width: 16),
          Text(
            '$label:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // Método para manejar la conversión segura de latitudes y longitudes.
  double _parseDouble(dynamic value, double defaultValue) {
    if (value == null) return defaultValue;
    try {
      return double.parse(value.toString());
    } catch (e) {
      return defaultValue;
    }
  }
}
