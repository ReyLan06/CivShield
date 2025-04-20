import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:latlong2/latlong.dart';

class SituacionesReportadasPage extends StatefulWidget {
  @override
  _SituacionesReportadasPageState createState() =>
      _SituacionesReportadasPageState();
}

class _SituacionesReportadasPageState extends State<SituacionesReportadasPage> {
  List<dynamic> _situaciones = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarSituaciones();
  }

  // Cargar las situaciones reportadas desde la API
  Future<void> _cargarSituaciones() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo cargar la información, por favor inicie sesión nuevamente')),
      );
      return;
    }

    final response = await http.post(
      Uri.parse('https://adamix.net/defensa_civil/def/situaciones.php'),
      body: {'token': token},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['exito'] == true) {
        setState(() {
          _situaciones = data['datos'];
          _isLoading = false; // Desactiva el indicador de carga
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['mensaje'] ?? 'No se encontraron situaciones')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de conexión, intenta nuevamente')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: const Text(
          'Mis Situaciones Reportadas',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.map, size: 30),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MapaSituacionesPage(situaciones: _situaciones),
                ),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Muestra el indicador de carga
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: _situaciones.length,
                itemBuilder: (context, index) {
                  final situacion = _situaciones[index];
                  return Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      title: Text(
                        situacion['titulo'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.redAccent,
                        ),
                      ),
                      subtitle: Text(
                        situacion['fecha'],
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(situacion['titulo']),
                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Código: ${situacion['codigo']}'),
                                  Text('Fecha: ${situacion['fecha']}'),
                                  Text('Descripción: ${situacion['descripcion']}'),
                                  Image.network(situacion['foto']),
                                  Text('Estado: ${situacion['estado']}'),
                                  Text('Comentario: ${situacion['comentario']}'),
                                ],
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('Cerrar', style: TextStyle(color: Colors.redAccent)),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
    );
  }
}

class MapaSituacionesPage extends StatelessWidget {
  final List<dynamic> situaciones;

  MapaSituacionesPage({required this.situaciones});

  @override
  Widget build(BuildContext context) {
    List<Marker> _markers = situaciones.map((situacion) {
      return Marker(
        point: LatLng(
          double.parse(situacion['latitud']),
          double.parse(situacion['longitud']),
        ),
        builder: (context) => GestureDetector(
          onTap: () {
            _mostrarPopup(context, situacion);
          },
          child: Icon(
            Icons.location_on,
            color: Colors.red,
            size: 40,
          ),
        ),
        anchorPos: AnchorPos.align(AnchorAlign.top),
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text('Mapa de Situaciones'),
      ),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(18.7686, -69.0378),
          zoom: 10,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: _markers,
          ),
        ],
      ),
    );
  }

  void _mostrarPopup(BuildContext context, dynamic situacion) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(situacion['titulo']),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Código: ${situacion['codigo']}'),
              Text('Fecha: ${situacion['fecha']}'),
              Text('Descripción: ${situacion['descripcion']}'),
              Image.network(situacion['foto']),
              Text('Estado: ${situacion['estado']}'),
              Text('Comentario: ${situacion['comentario']}'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cerrar', style: TextStyle(color: Colors.redAccent)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
