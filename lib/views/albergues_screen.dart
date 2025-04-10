// Este archivo contiene el Widget de la Carretera de Refugios, que muestra una lista de refugios y permite a los usuarios buscarlos.

import 'package:civshield/Models/datos_albergue.dart';
import 'package:civshield/views/detalles_albergues.dart';
import 'package:civshield/views/listado_video_screen.dart';
import 'package:flutter/material.dart';


class ShelterListScreen extends StatefulWidget {
  @override
  _ShelterListScreenState createState() => _ShelterListScreenState();
}

class _ShelterListScreenState extends State<ShelterListScreen> {
  List<dynamic> _shelters = []; // Lista de todos los albergues.
  List<dynamic> _filteredShelters = []; // Lista filtrada de albergues.
  bool _isLoading = true; // Indicador de carga.

  @override
  void initState() {
    super.initState();
    // Llama a la función para obtener los datos de los albergues al iniciar.
    fetchShelters().then((data) {
      setState(() {
        _shelters = data;
        _filteredShelters = data; // Inicialmente no se aplica filtro.
        _isLoading = false; // Cambia el estado de carga una vez listos los datos.
      });
    });
  }

  // Filtra los albergues según la consulta ingresada en el cuadro de búsqueda.
  void _filterShelters(String query) {
    setState(() {
      _filteredShelters = _shelters.where((shelter) {
        return shelter['edificio'].toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Albergues'), // Título de la barra de navegación.
        actions: [
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 1.0, end: 1.2), // Animación de escala.
            duration: Duration(seconds: 1),
            builder: (context, scale, child) {
              return Transform.scale(
                scale: scale,
                child: IconButton(
                  icon: Icon(Icons.video_library, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoScreen(), // Pantalla de Videos.
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.lightBlueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // Indicador de carga.
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Buscar albergue',
                      labelStyle: TextStyle(color: Colors.blueAccent),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    onChanged: _filterShelters, // Filtrar la lista.
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _filteredShelters.length,
                    itemBuilder: (context, index) {
                      final shelter = _filteredShelters[index];
                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          title: Text(
                            shelter['edificio'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.blueAccent,
                            ),
                          ),
                          subtitle: Text(
                            shelter['ciudad'],
                            style: TextStyle(color: Colors.grey),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.blueAccent,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ShelterDetailScreen(shelter: shelter),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _isLoading = true; // Mostrar indicador de carga.
          });
          fetchShelters().then((data) {
            setState(() {
              _shelters = data;
              _filteredShelters = data; // Restablecer lista filtrada.
              _isLoading = false; // Ocultar indicador de carga.
            });
          });
        },
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.refresh, color: Colors.white), // Icono de recargar.
      ),
    );
  }
}