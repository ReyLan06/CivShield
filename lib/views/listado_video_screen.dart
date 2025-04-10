// Este archivo contiene la implementación de la pantalla que muestra una lista de videos obtenidos desde una API externa.
// También incluye la funcionalidad para reproducir un video al hacer clic en él.

import 'package:civshield/views/videos_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Paquete para realizar solicitudes HTTP.
import 'dart:convert'; // Paquete para trabajar con JSON.


// Pantalla que muestra una lista de videos obtenidos desde una API externa.
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
        title: Text('Listado de Videos'), // Título de la barra de navegación.
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