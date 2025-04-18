import 'dart:convert';
import 'package:http/http.dart' as http;

class Noticia {
  final String id;
  final String fecha;
  final String titulo;
  final String contenido;
  final String foto;

  Noticia({
    required this.id,
    required this.fecha,
    required this.titulo,
    required this.contenido,
    required this.foto,
  });

  factory Noticia.fromJson(Map<String, dynamic> json) {
    return Noticia(
      id: json['id'],
      fecha: json['fecha'],
      titulo: json['titulo'],
      contenido: json['contenido'],
      foto: json['foto'],
    );
  }

  static Future<List<Noticia>> fetchNoticias() async {
    final response = await http.get(
      Uri.parse('https://adamix.net/defensa_civil/def/noticias.php'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['exito']) {
        return (data['datos'] as List)
            .map((noticia) => Noticia.fromJson(noticia))
            .toList();
      }
    }
    throw Exception('Failed to load noticias');
  }
}