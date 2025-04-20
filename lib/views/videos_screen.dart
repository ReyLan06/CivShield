// Este archivo contiene la pantalla de reproducción de videos.

import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

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
        title: Text('Reproductor de Video'), // Título de la barra de navegación.
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