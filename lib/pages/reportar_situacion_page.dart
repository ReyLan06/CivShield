import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ReportarSituacionPage extends StatefulWidget {
  @override
  _ReportarSituacionPageState createState() => _ReportarSituacionPageState();
}

class _ReportarSituacionPageState extends State<ReportarSituacionPage> {
  final _tituloController = TextEditingController();
  final _descripcionController = TextEditingController();
  File? _image;
  Position? _position;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showLocationServiceDialog();
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Permiso de ubicación denegado')),
        );
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _position = position;
    });
  }

  void _showLocationServiceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Ubicación desactivada'),
        content: Text('Para reportar la situación, es necesario habilitar la ubicación del dispositivo.'),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              // Redirigir a la configuración de ubicación
              await Geolocator.openLocationSettings();
            },
            child: Text('Ir a Configuración'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  Future<void> _reportarSituacion() async {
    FocusScope.of(context).unfocus();  // Cerrar el teclado al enviar el reporte

    if (_tituloController.text.isEmpty ||
        _descripcionController.text.isEmpty ||
        _image == null ||
        _position == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, complete todos los campos')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Convertir la imagen a base64
    final bytes = await _image!.readAsBytes();
    final base64Image = base64Encode(bytes);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.post(
      Uri.parse('https://adamix.net/defensa_civil/def/nueva_situacion.php'),
      body: {
        'token': token!,
        'titulo': _tituloController.text.trim(),
        'descripcion': _descripcionController.text.trim(),
        'foto': base64Image,
        'latitud': _position!.latitude.toString(),
        'longitud': _position!.longitude.toString(),
      },
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['exito']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Situación reportada con éxito')),
        );
        _tituloController.clear();
        _descripcionController.clear();
        setState(() {
          _image = null;
          _position = null;
        });

        // Regresar a la vista principal
        Navigator.pop(context);  // Esto va a cerrar la vista actual y volver a la anterior
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['mensaje'])),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de conexión, intenta nuevamente')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reportar Situación'),
        backgroundColor: Colors.red[800],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();  // Cierra el teclado al tocar fuera de los campos
        },
        child: SingleChildScrollView(  // Envuelve todo en un SingleChildScrollView
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Título:',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
                TextField(
                  controller: _tituloController,
                  decoration: InputDecoration(
                    hintText: 'Ingrese el título',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.text,
                ),
                SizedBox(height: 10),
                Text(
                  'Descripción:',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
                TextField(
                  controller: _descripcionController,
                  decoration: InputDecoration(
                    hintText: 'Ingrese la descripción',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4,
                ),
                SizedBox(height: 10),
                Text(
                  'Ubicación:',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
                _position == null
                    ? CircularProgressIndicator()
                    : Text(
                        'Lat: ${_position!.latitude}\nLon: ${_position!.longitude}',
                        style: TextStyle(fontSize: 16, color: Colors.blue),
                      ),
                SizedBox(height: 10),
                Text(
                  'Foto:',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: Icon(Icons.camera_alt),
                  label: Text('Tomar Foto'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red[800]),
                ),
                SizedBox(height: 10),
                _image == null
                    ? Text('No se ha seleccionado ninguna imagen',
                        style: TextStyle(fontSize: 16, color: Colors.grey))
                    : Image.file(_image!, height: 150, width: 150),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _reportarSituacion,
                    child: _isLoading
                        ? CircularProgressIndicator()
                        : Text('Reportar Situación'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[800],
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 80),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
