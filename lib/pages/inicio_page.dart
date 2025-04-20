import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme_provider.dart';
import 'session_manager.dart';

class PantallaInicio extends StatefulWidget {
  const PantallaInicio({super.key});

  @override
  State<PantallaInicio> createState() => _PantallaInicioState();
}

class _PantallaInicioState extends State<PantallaInicio> {
  bool _isLoggedIn = false;
  String _nombre = '';

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  // Verificación más robusta y manejo de errores
  Future<void> _checkLoginStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      bool loggedIn = prefs.containsKey('token');
      String nombre = prefs.getString('nombre') ?? '';

      if (loggedIn && nombre.isNotEmpty) {
        setState(() {
          _isLoggedIn = loggedIn;
          _nombre = nombre;
        });
      } else {
        setState(() {
          _isLoggedIn = false;
          _nombre = '';
        });
      }
    } catch (e) {
      print("Error al obtener el estado de sesión: $e");
      setState(() {
        _isLoggedIn = false;
        _nombre = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Defensa Civil App'),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: _isLoggedIn
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Hola, $_nombre', style: TextStyle(color: Colors.white, fontSize: 18)),
                        TextButton(
                          onPressed: () async {
                            await SessionManager.logout();
                            
                            Navigator.pushReplacementNamed(context, '/bienvenida'); 
                          },
                          child: Text("Cerrar sesión", style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    )
                  : const Text('Menú', style: TextStyle(color: Colors.white)),
            ),
            ListTile(
              title: const Text('Modo Oscuro/Claro'),
              trailing: Switch(
                value: themeProvider.isDarkMode,
                onChanged: (bool value) {
                  themeProvider.toggleTheme(value);
                },
              ),
            ),
            if (_isLoggedIn) ...[  // Si está logueado
              ListTile(
                title: const Text('Reportar Situación'),
                onTap: () {
                  Navigator.pushNamed(context, '/reportar');
                },
              ),
              ListTile(
                title: const Text('Mis Situaciones'),
                onTap: () {
                  Navigator.pushNamed(context, '/mis_situaciones');
                },
              ),
              ListTile(
                title: const Text('Noticias'),
                onTap: () {
                  Navigator.pushNamed(context, '/noticias');
                },
              ),
              ListTile(
                title: const Text('Medidas Preventivas'),
                onTap: () {
                  Navigator.pushNamed(context, '/medidas');
                },
              ),
              ListTile(
                title: const Text('Albergues'),
                onTap: () {
                  Navigator.pushNamed(context, '/albergues');
                },
              ),
              ListTile(
                title: const Text('Quiero ser voluntario'),
                onTap: () {
                  Navigator.pushNamed(context, '/register');
                },
              ),
              ListTile(
                title: const Text('Acerca de'),
                onTap: () {
                  Navigator.pushNamed(context, '/acerca');
                },
              ),
            ] else ...[  // Si no está logueado
              ListTile(
                title: const Text('Iniciar Sesión'),
                onTap: () {
                  Navigator.pushNamed(context, '/login');
                },
              ),
              ListTile(
                title: const Text('Registrarse'),
                onTap: () {
                  Navigator.pushNamed(context, '/register');
                },
              ),
            ],
          ],
        ),
      ),
      body: _isLoggedIn
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Bienvenido, $_nombre!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  Text('¡Gracias por ser parte de la Defensa Civil!', style: TextStyle(fontSize: 18)),
                ],
              ),
            )
          : Center(
              child: Text(
                'Bienvenido a la app Defensa Civil',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
    );
  }
}
