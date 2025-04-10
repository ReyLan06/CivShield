// En este archivo se define la pantalla de medidas preventivas, que muestra una lista de medidas con un campo de búsqueda.

import 'package:civshield/Models/modelo_medidas_miembros.dart';
import 'package:flutter/material.dart';

class MedidasPreventivasScreen extends StatefulWidget {
  @override
  _MedidasPreventivasScreenState createState() => _MedidasPreventivasScreenState();
}

class _MedidasPreventivasScreenState extends State<MedidasPreventivasScreen> {
  List<dynamic> _Medidas = [];
  List<dynamic> _filteredMedidas = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMedidasPreventivas().then((data) {
      setState(() {
        _Medidas = data;
        _filteredMedidas = data;
        _isLoading = false;
      });
    });
  }

  void _filterMedidas(String query) {
    setState(() {
      _filteredMedidas = _Medidas.where((measure) {
        return measure['titulo'].toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medidas Preventivas'),
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
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Buscar medida',
                      labelStyle: TextStyle(color: Colors.blueAccent),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                    onChanged: _filterMedidas,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _filteredMedidas.length,
                    itemBuilder: (context, index) {
                      final measure = _filteredMedidas[index];
                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          title: Text(
                            measure['titulo'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.blueAccent,
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.blueAccent,
                          ),
                          onTap: () {
                            _showMeasureDetails(context, measure);
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
            _isLoading = true;
          });
          fetchMedidasPreventivas().then((data) {
            setState(() {
              _Medidas = data;
              _filteredMedidas = data;
              _isLoading = false;
            });
          });
        },
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }

  void _showMeasureDetails(BuildContext context, dynamic measure) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(measure['titulo']),
          content: SingleChildScrollView(
            child: Text(measure['descripcion']),
          ),
          actions: [
            TextButton(
              child: Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}