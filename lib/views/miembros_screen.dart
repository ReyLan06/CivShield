// En este archivo se define la pantalla de miembros, que muestra una lista de miembros con un campo de búsqueda.

import 'package:civshield/Models/modelo_medidas_miembros.dart';
import 'package:flutter/material.dart';

class MiembrosScreen extends StatefulWidget {
  @override
  _MiembrosScreenState createState() => _MiembrosScreenState();
}

class _MiembrosScreenState extends State<MiembrosScreen> {
  List<dynamic> _Miembros = [];
  List<dynamic> _filteredMiembros = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMiembros().then((data) {
      setState(() {
        _Miembros = data;
        _filteredMiembros = data;
        _isLoading = false;
      });
    });
  }

  void _filterMiembros(String query) {
    setState(() {
      _filteredMiembros = _Miembros.where((member) {
        return member['nombre'].toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Miembros'),
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
                      labelText: 'Buscar miembro',
                      labelStyle: TextStyle(color: Colors.blueAccent),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    onChanged: _filterMiembros,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _filteredMiembros.length,
                    itemBuilder: (context, index) {
                      final member = _filteredMiembros[index];
                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(member['foto']),
                            radius: 25,
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          title: Text(
                            member['nombre'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.blueAccent,
                            ),
                          ),
                          subtitle: Text(
                            member['cargo'],
                            style: TextStyle(color: Colors.grey),
                          ),
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
          fetchMiembros().then((data) {
            setState(() {
              _Miembros = data;
              _filteredMiembros = data;
              _isLoading = false;
            });
          });
        },
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }
}