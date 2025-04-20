import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _cedulaController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _login() async {
    final cedula = _cedulaController.text;
    final password = _passwordController.text;

    if (cedula.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, ingrese cédula y contraseña')),
      );
      return;
    }

    final response = await http.post(
      Uri.parse('https://adamix.net/defensa_civil/def/iniciar_sesion.php'),
      body: {
        'cedula': cedula,
        'clave': password,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['exito'] == true) {
        String token = data['datos']['token'];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('nombre', data['datos']['nombre']);
        await prefs.setString('apellido', data['datos']['apellido']);
        await prefs.setString('correo', data['datos']['correo']);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bienvenido, ${data['datos']['nombre']}')),
        );

        Navigator.pushReplacementNamed(context, '/menu');
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,  // Fondo oscuro, representando seriedad
      appBar: AppBar(
        title: Text('Iniciar Sesión'),
        backgroundColor: Colors.yellow[800],  // Color que evoca alerta
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.warning_amber_outlined,
              color: Colors.yellow[800],  // Ícono representativo de advertencia
              size: 100,
            ),
            SizedBox(height: 30),
            TextField(
              controller: _cedulaController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Cédula',
                labelStyle: TextStyle(color: Colors.white),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.yellow[800]!, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 2),
                ),
              ),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                labelStyle: TextStyle(color: Colors.white),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.yellow[800]!, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 2),
                ),
              ),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow[800],  // Botón con color amarillo
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 100),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                'Iniciar Sesión',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
