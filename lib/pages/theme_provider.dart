import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  bool isDarkMode = false;

  ThemeMode get currentTheme => isDarkMode ? ThemeMode.dark : ThemeMode.light;

  ThemeProvider() {
    _loadTheme();
  }

  // Cargar el tema desde SharedPreferences
  _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    isDarkMode = prefs.getBool('isDarkMode') ?? false;
    notifyListeners();
  }

  // Cambiar el tema y guardarlo
  void toggleTheme(bool isOn) async {
    final prefs = await SharedPreferences.getInstance();
    isDarkMode = isOn;
    await prefs.setBool('isDarkMode', isDarkMode); 
    notifyListeners();
  }
}
