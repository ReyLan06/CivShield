import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Providers
import 'pages/theme_provider.dart';

// Pages principales
import 'pages/inicio_page.dart';
import 'pages/login_page.dart';
import 'pages/reportar_situacion_page.dart';
import 'pages/mis_situaciones_page.dart';
import 'pages/verificador_login_page.dart';

// Vistas (views)
import 'views/noticias_page.dart';
import 'views/medidas_preventivas_screen.dart';
import 'views/albergues_screen.dart';
import 'views/volunteer.dart';
import 'views/aboutScreen.dart';
import 'views/historia_screen.dart';
import 'views/servicios_screen.dart';
import 'views/miembros_screen.dart';
import 'views/videos_screen.dart';
import 'views/detalles_albergues.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Defensa Civil App',
      themeMode: themeProvider.currentTheme,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      initialRoute: '/menu',
      routes: {
        //'/': (context) => const VerificadorLoginPage(), 
        '/login': (context) => LoginPage(),
        '/menu': (context) => const PantallaInicio(),
        '/reportar': (context) => ReportarSituacionPage(),
        '/mis_situaciones': (context) => SituacionesReportadasPage(),
        '/noticias': (context) => NoticiasPage(),
        '/medidas': (context) => MedidasPreventivasScreen(),
        '/albergues': (context) => ShelterListScreen(),
        '/register': (context) => VolunteerView(),
        '/acerca': (context) => AboutPage(),
        '/historia': (context) => HistoriaScreen(),
        '/servicios': (context) => ServiciosScreen(),
        '/miembros': (context) => MiembrosScreen(),
        '/videos': (context) => VideoPlayerScreen(videoId: ''), 
      },
    );
  }
}
