import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _locationMessage = "Obtendo localização...";
  List<Map<String, dynamic>> _nearbyAmbientes = [];
  String _closestAmbiente = "Sem ambientes próximos";
  
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _locationMessage = "Permissão negada. Não é possível obter a localização.";
      });
      return;
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _locationMessage = "Localização: \nLatitude: ${position.latitude}\nLongitude: ${position.longitude}";
    });

    // Obter ambientes próximos
    await _fetchNearbyAmbientes(position.latitude, position.longitude);
  }

  Future<void> _fetchNearbyAmbientes(double latitude, double longitude) async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Ambientes').get();

    List<Map<String, dynamic>> ambientes = [];

    for (var doc in snapshot.docs) {
      double ambienteLatitude = double.parse(doc['latitude']);
      double ambienteLongitude = double.parse(doc['longitude']);
      double distance = Geolocator.distanceBetween(latitude, longitude, ambienteLatitude, ambienteLongitude);

      if (distance <= 20) { // Filtrando ambientes dentro de 20 metros
        ambientes.add({
          'id': doc.id,
          'localizacao': doc['localizacao'],
          'latitude': ambienteLatitude,
          'longitude': ambienteLongitude,
          'distance': distance,
        });
      }
    }

    setState(() {
      _nearbyAmbientes = ambientes;
      _closestAmbiente = ambientes.isNotEmpty
          ? ambientes.reduce((a, b) => a['distance'] < b['distance'] ? a : b)['localizacao']
          : "Sem ambientes próximos";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Localização do Usuário'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              _closestAmbiente,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _nearbyAmbientes.length,
              itemBuilder: (context, index) {
                final ambiente = _nearbyAmbientes[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(ambiente['localizacao']),
                    subtitle: Text("ID: ${ambiente['id']}"),
                    trailing: Text("Distância: ${ambiente['distance'].toStringAsFixed(2)} m"),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getCurrentLocation,
        tooltip: 'Atualizar Localização',
        child: Icon(Icons.location_searching),
      ),
    );
  }
}
