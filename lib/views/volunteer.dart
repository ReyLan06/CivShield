import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VolunteerView extends StatefulWidget {
  @override
  _VolunteerViewState createState() => _VolunteerViewState();
}

class _VolunteerViewState extends State<VolunteerView> {
  final _formKey = GlobalKey<FormState>();
  bool? _isSuccess;

  final _cedulaController = TextEditingController();
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _claveController = TextEditingController();
  final _correoController = TextEditingController();
  final _telefonoController = TextEditingController();

  bool _loading = false;
  String _message = '';

  Future<void> _registrarVoluntario() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _message = '';
    });

    final url = Uri.parse('https://adamix.net/defensa_civil/def/registro.php');

    final response = await http.post(url, body: {
      'cedula': _cedulaController.text,
      'nombre': _nombreController.text,
      'apellido': _apellidoController.text,
      'clave': _claveController.text,
      'correo': _correoController.text,
      'telefono': _telefonoController.text,
    });

    final data = jsonDecode(response.body);

    setState(() {
      _loading = false;
      _message = data['mensaje'];
      _isSuccess = data['exito'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quiero ser voluntario'), backgroundColor: Colors.blueAccent,),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Requisitos para ser voluntario:\n\n'
                  '- Ser mayor de edad\n'
                  '- Tener interés en servir a la comunidad\n'
                  '- Estar dispuesto a recibir capacitaciones\n',
              style: TextStyle(fontSize: 16),
            ),
            Divider(),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildInput(_cedulaController, 'Cédula'),
                  _buildInput(_nombreController, 'Nombre'),
                  _buildInput(_apellidoController, 'Apellido'),
                  _buildInput(_claveController, 'Contraseña', obscure: true),
                  _buildInput(_correoController, 'Correo electrónico', inputType: TextInputType.emailAddress),
                  _buildInput(_telefonoController, 'Teléfono', inputType: TextInputType.phone),
                  SizedBox(height: 16),
                  _loading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent
                    ),
                    onPressed: _registrarVoluntario,
                    child: Text('Enviar solicitud', style: TextStyle(color: Colors.black)
                    ),
                  ),
                  if (_message.isNotEmpty) ...[
                    SizedBox(height: 16),
                    Card(
                      color: _isSuccess == true ? Colors.green[50] : Colors.red[50],
                      child: ListTile(
                        leading: Icon(
                          _isSuccess == true ? Icons.check_circle : Icons.error,
                          color: _isSuccess == true ? Colors.green : Colors.red,
                        ),
                        title: Text(
                          _message,
                          style: TextStyle(
                            color: _isSuccess == true ? Colors.green[800] : Colors.red[800],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(TextEditingController controller, String label,
      {bool obscure = false, TextInputType inputType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        obscureText: obscure,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator: (value) =>
        value == null || value.isEmpty ? 'Este campo es obligatorio' : null,
      ),
    );
  }
}
