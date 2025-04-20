import 'package:flutter/material.dart';

class PantallaBienvenida extends StatelessWidget {
  const PantallaBienvenida({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Defensa Civil App'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: PageView(
              children: [
                _buildSliderImage('assets/images/slider1.png'),
                _buildSliderImage('assets/images/slider2.jpg'),
                _buildSliderImage('assets/images/slider3.jpeg'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: const Text('Iniciar Sesión'),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: const Text('Registrarse'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliderImage(String imagePath) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
