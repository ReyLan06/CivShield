import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';


void main() => runApp(const MyApp());

// Clase principal de la aplicación.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App', // Título de la aplicación.
      home: ShelterListScreen(), // Pantalla inicial.
    );
  }
}

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


class ShelterListScreen extends StatefulWidget {
  @override
  _ShelterListScreenState createState() => _ShelterListScreenState();
}

class _ShelterListScreenState extends State<ShelterListScreen> {
  List<dynamic> _shelters = []; // Lista de todos los albergues.
  List<dynamic> _filteredShelters = []; // Lista filtrada de albergues.
  bool _isLoading = true; // Indicador de carga.

  @override
  void initState() {
    super.initState();
    // Llama a la función para obtener los datos de los albergues al iniciar.
    fetchShelters().then((data) {
      setState(() {
        _shelters = data;
        _filteredShelters = data; // Inicialmente no se aplica filtro.
        _isLoading = false; // Cambia el estado de carga una vez listos los datos.
      });
    });
  }

  // Filtra los albergues según la consulta ingresada en el cuadro de búsqueda.
  void _filterShelters(String query) {
    setState(() {
      _filteredShelters = _shelters.where((shelter) {
        return shelter['edificio'].toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 1.0, end: 1.2), // Animación de escala.
            duration: Duration(seconds: 1),
            builder: (context, scale, child) {
              return Transform.scale(
                scale: scale,
                child: IconButton(
                  icon: Icon(Icons.video_library, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoScreen(), // Pantalla de Videos.
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.lightBlueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // Indicador de carga.
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Buscar albergue',
                      labelStyle: TextStyle(color: Colors.blueAccent),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    onChanged: _filterShelters, // Filtrar la lista.
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _filteredShelters.length,
                    itemBuilder: (context, index) {
                      final shelter = _filteredShelters[index];
                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          title: Text(
                            shelter['edificio'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.blueAccent,
                            ),
                          ),
                          subtitle: Text(
                            shelter['ciudad'],
                            style: TextStyle(color: Colors.grey),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.blueAccent,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ShelterDetailScreen(shelter: shelter),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _isLoading = true; // Mostrar indicador de carga.
          });
          fetchShelters().then((data) {
            setState(() {
              _shelters = data;
              _filteredShelters = data; // Restablecer lista filtrada.
              _isLoading = false; // Ocultar indicador de carga.
            });
          });
        },
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.refresh, color: Colors.white), // Icono de recargar.
      ),
    );
  }
}


// Pantalla que muestra los detalles de un albergue específico.
class ShelterDetailScreen extends StatelessWidget {
  final Map<String, dynamic> shelter;

  const ShelterDetailScreen({required this.shelter});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
                              double.parse(shelter['lat'].toString()), // Latitud.
                              double.parse(shelter['lng'].toString()), // Longitud.
                            ),
                            zoom: 15,
                          ),
                          children: [
                            TileLayer(
                              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
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
                                  builder: (context) => Icon(
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
                    SizedBox(height: 16), // Espaciado entre el mapa y los detalles.
                    Center(
                      child: Column(
                        children: [
                          Icon(Icons.home, size: 60, color: Colors.blueAccent), // Icono principal.
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
                    _buildDetailRow(Icons.location_city, 'Ciudad', shelter['ciudad']),
                    _buildDetailRow(Icons.person, 'Coordinador', shelter['coordinador']),
                    _buildDetailRow(Icons.phone, 'Teléfono', shelter['telefono']),
                    _buildDetailRow(Icons.people, 'Capacidad', shelter['capacidad']),
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


class VideoScreen extends StatefulWidget {
  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  List<dynamic> _videos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchVideos().then((data) {
      setState(() {
        _videos = data;
        _isLoading = false;
      });
    });
  }

  // Función para obtener la lista de videos desde la API.
  Future<List<dynamic>> fetchVideos() async {
    final response = await http.get(Uri.parse('https://adamix.net/defensa_civil/def/videos.php'));
    if (response.statusCode == 200) {
      return json.decode(response.body)['datos'];
    } else {
      throw Exception('Error al cargar los videos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.lightBlueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _videos.length,
              itemBuilder: (context, index) {
                final video = _videos[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    title: Text(
                      video['titulo'], // Título del video.
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.blueAccent,
                      ),
                    ),
                    subtitle: Text(
                      video['descripcion'], // Descripción del video.
                      style: TextStyle(color: Colors.grey),
                    ),
                    trailing: Icon(Icons.play_circle_fill, color: Colors.blueAccent),
                                        onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VideoPlayerScreen(
                                  videoId: video['link'], // Ejemplo: PMW8U0SPyEo.
                                ),
                              ),
                            );
                          },

                  ),
                );
              },
            ),
    );
  }
}

// Pantalla para reproducir videos.
class VideoPlayerScreen extends StatefulWidget {
  final String videoId;

  const VideoPlayerScreen({required this.videoId});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        forceHD: true, // Asegura calidad alta.
        disableDragSeek: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Card con el reproductor
          Card(
            elevation: 8,
            margin: EdgeInsets.all(16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 200,
                    child: YoutubePlayerBuilder(
                      player: YoutubePlayer(controller: _controller),
                      builder: (context, player) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: player,
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 16), // Espaciado entre el reproductor y el botón.
                  ElevatedButton.icon(
                    onPressed: () {
                      _controller.seekTo(Duration(seconds: 0));
                      _controller.play();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('¡Video reiniciado!')),
                      );
                    },
                    icon: Icon(Icons.replay, color: Colors.white),
                    label: Text('Reiniciar Video'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}



