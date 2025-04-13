import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Servicio {
  final String id;
  final String nombre;
  final String descripcion;
  final String imagen;

  Servicio({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.imagen,
  });

  factory Servicio.fromJson(Map<String, dynamic> json) {
    return Servicio(
      id: json['id'] ?? '',
      nombre: json['nombre'] ?? 'Servicio sin nombre',
      descripcion: json['descripcion'] ?? 'Descripción no disponible',
      imagen:
          json['foto'] ??
          '', // Nota: El campo puede ser 'foto' en lugar de 'imagen'
    );
  }
}

class ServiciosScreen extends StatefulWidget {
  @override
  _ServiciosScreenState createState() => _ServiciosScreenState();
}

class _ServiciosScreenState extends State<ServiciosScreen> {
  List<Servicio> _servicios = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchServicios();
  }

  Future<void> _fetchServicios() async {
    try {
      final response = await http.get(
        Uri.parse('https://adamix.net/defensa_civil/def/servicios.php'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Verificar estructura de la respuesta
        if (data['exito'] == true && data['datos'] is List) {
          List<Servicio> servicios = [];
          for (var item in data['datos']) {
            servicios.add(Servicio.fromJson(item));
          }
          setState(() {
            _servicios = servicios;
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
            _errorMessage = data['mensaje'] ?? 'Estructura de datos inesperada';
          });
        }
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Error de conexión: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Servicios de la Defensa Civil'),
        backgroundColor: Colors.orange,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_errorMessage),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _fetchServicios,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (_servicios.isEmpty) {
      return const Center(child: Text('No hay servicios disponibles'));
    }

    return ListView.builder(
      itemCount: _servicios.length,
      itemBuilder: (context, index) {
        return _buildServiceCard(_servicios[index]);
      },
    );
  }

  Widget _buildServiceCard(Servicio servicio) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (servicio.imagen.isNotEmpty)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(10.0),
              ),
              child: Image.network(
                servicio.imagen,
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 180,
                    color: Colors.grey[200],
                    child: const Center(child: CircularProgressIndicator()),
                  );
                },
                errorBuilder:
                    (context, error, stackTrace) => Container(
                      height: 180,
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(Icons.broken_image, color: Colors.grey),
                      ),
                    ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  servicio.nombre,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  servicio.descripcion,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
