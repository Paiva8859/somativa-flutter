import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:local_auth/local_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _locationMessage = "Obtendo localização...";
  List<Map<String, dynamic>> _nearbyAmbientes = [];
  String _closestAmbiente = "Sem ambientes próximos";
  Position? _userPosition;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final LocalAuthentication _localAuth = LocalAuthentication();
  bool _biometricAvailable = false;

  @override
  void initState() {
    super.initState();
    //_checkBiometricSupport();
    autentica();
    _getCurrentLocation();
  }

  autentica() async {
    bool canAuthenticateWithBiometrics = await _localAuth.canCheckBiometrics;
    if (canAuthenticateWithBiometrics) {
      final didAuth = await _localAuth.authenticate(
          localizedReason: "Por favor, insira sua credencial");
      if (didAuth) {
        _showMessage('Acesso autorizado!');
      }
    }
  }

  Future<void> _checkBiometricSupport() async {
    try {
      // Verifica se o dispositivo suporta biometria e se há biometria registrada
      bool canAuthenticateWithBiometrics = await _localAuth.canCheckBiometrics;
      bool canAuthenticate = await _localAuth.isDeviceSupported();
      bool hasBiometrics = await _localAuth
          .getAvailableBiometrics()
          .then((biometrics) => biometrics.isNotEmpty);

      setState(() {
        _biometricAvailable =
            canAuthenticate && canAuthenticateWithBiometrics && hasBiometrics;
      });

      if (!_biometricAvailable) {
        _showMessage(
            "Este dispositivo não suporta ou não possui biometria registrada.");
      }
    } catch (e) {
      print("Erro ao verificar suporte à biometria: $e");
      _showMessage("Erro ao verificar suporte à biometria.");
    }
  }

  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _locationMessage =
            "Permissão negada. Não é possível obter a localização.";
      });
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _userPosition = position;
      _locationMessage =
          "Localização: \nLatitude: ${position.latitude}\nLongitude: ${position.longitude}";
    });

    await _fetchNearbyAmbientes(position.latitude, position.longitude);
  }

  Future<void> _fetchNearbyAmbientes(double latitude, double longitude) async {
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('Ambientes').get();

    List<Map<String, dynamic>> ambientes = [];

    for (var doc in snapshot.docs) {
      double ambienteLatitude = double.parse(doc['latitude']);
      double ambienteLongitude = double.parse(doc['longitude']);
      double distance = Geolocator.distanceBetween(
          latitude, longitude, ambienteLatitude, ambienteLongitude);

      if (distance <= 20) {
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
          ? ambientes.reduce(
              (a, b) => a['distance'] < b['distance'] ? a : b)['localizacao']
          : "Sem ambientes próximos";
    });
  }

  Future<void> _checkAuthorization(String ambienteId) async {
    try {
      String userEmail = _auth.currentUser?.email ?? "";
      if (userEmail.isEmpty) {
        _showMessage("Usuário não autenticado");
        return;
      }

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Ambientes')
          .doc(ambienteId)
          .collection('usuarios_autorizados')
          .doc(userEmail)
          .get();

      if (userDoc.exists == false) {
        _showMessage("Acesso negado: usuário não autorizado");
      } else {
        autentica();
      }
    } catch (e) {
      print("Erro na verificação de autorização: $e");
      _showMessage("Erro na verificação de autorização.");
    }
  }

  void _showMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Localização do Usuário'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              _closestAmbiente,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                    trailing: Text(
                        "Distância: ${ambiente['distance'].toStringAsFixed(2)} m"),
                    onTap: () {
                      _checkAuthorization(ambiente['id']);
                    },
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            color: Colors.grey[200],
            child: Text(
              _userPosition != null
                  ? "Coordenadas do Usuário:\nLatitude: ${_userPosition!.latitude}\nLongitude: ${_userPosition!.longitude}"
                  : "Localização do usuário não disponível",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getCurrentLocation,
        tooltip: 'Atualizar Localização',
        child: const Icon(Icons.location_searching),
      ),
    );
  }
}
