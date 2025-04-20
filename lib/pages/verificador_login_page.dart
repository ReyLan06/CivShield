import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerificadorLoginPage extends StatelessWidget {
  const VerificadorLoginPage({super.key});

  Future<bool> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    bool loggedIn = prefs.containsKey('token');
    return loggedIn;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<bool>(
        future: _checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            // Si hay un error, se maneja
            return const Center(child: Text('Error al verificar el estado de sesión.'));
          }

          // Redirigir a la página correspondiente según el estado de sesión
          if (snapshot.data == true) {
            // Si está logueado, ir a la pantalla de inicio
            Future.microtask(() {
              Navigator.pushReplacementNamed(context, '/menu');
            });
          } else {
            // Si no está logueado, ir a la pantalla de inicio de sesión
            Future.microtask(() {
              Navigator.pushReplacementNamed(context, '/verificador');
            });
          }

          
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
