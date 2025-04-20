import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class HistoriaScreen extends StatefulWidget {
  @override
  _HistoriaScreenState createState() => _HistoriaScreenState();
}

class _HistoriaScreenState extends State<HistoriaScreen> {
  late YoutubePlayerController _controller;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      final videoId =
          YoutubePlayer.convertUrlToId(
            'https://www.youtube.com/watch?v=eMXgS_U3p9g',
          ) ??
          'eMXgS_U3p9g';

      _controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          disableDragSeek: false,
          enableCaption: true,
          forceHD: false,
        ),
      );

      // Esperar a que el controlador esté listo
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historia de la Defensa Civil'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Historia de la Defensa Civil Dominicana',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 20),
            _buildVideoPlayer(),
            const SizedBox(height: 20),
            const Text(
              'Orígenes y Fundación',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'La Defensa Civil de la República Dominicana fue creada mediante el Decreto No. 1897 del 7 de junio de 1966, como respuesta a la necesidad de contar con un organismo especializado en la prevención y atención de desastres. Su creación se enmarca en el contexto internacional del desarrollo de organismos de protección civil, especialmente después de la Segunda Guerra Mundial.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              'Misión',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'La Defensa Civil tiene como misión principal proteger la vida y los bienes de la población ante la ocurrencia de desastres naturales o provocados por el hombre, mediante la ejecución de acciones de prevención, mitigación, preparación, respuesta y recuperación, en coordinación con otras instituciones del Estado y la sociedad civil.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              'Evolución',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Desde su creación, la Defensa Civil ha evolucionado significativamente, modernizando sus equipos y protocolos de actuación. En la actualidad cuenta con equipos especializados en rescate urbano, manejo de materiales peligrosos, búsqueda y rescate, entre otros. Además, ha desarrollado un importante sistema de alerta temprana y ha fortalecido su capacidad de coordinación interinstitucional.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoPlayer() {
    if (_hasError) {
      return Container(
        height: 200,
        color: Colors.grey[300],
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, color: Colors.red, size: 50),
              const SizedBox(height: 10),
              const Text('No se pudo cargar el video'),
              TextButton(
                onPressed: _retryLoading,
                child: const Text('Intentar nuevamente'),
              ),
            ],
          ),
        ),
      );
    }

    return _isLoading
        ? Container(
          height: 200,
          color: Colors.grey[300],
          child: const Center(child: CircularProgressIndicator()),
        )
        : AspectRatio(
          aspectRatio: 16 / 9,
          child: YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.orange,
            bottomActions: [
              CurrentPosition(),
              ProgressBar(isExpanded: true),
              RemainingDuration(),
              FullScreenButton(),
            ],
          ),
        );
  }

  void _retryLoading() {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    _initializePlayer();
  }
}
