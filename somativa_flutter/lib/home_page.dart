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
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Localização do Usuário',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.red[700],
        elevation: 5,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              _closestAmbiente,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _nearbyAmbientes.length,
              itemBuilder: (context, index) {
                final ambiente = _nearbyAmbientes[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    leading: const Icon(
                      Icons.business,
                      color: Colors.red,
                      size: 40,
                    ),
                    title: Text(
                      ambiente['localizacao'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text(
                      "ID: ${ambiente['id']}",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    trailing: Text(
                      "Distância: ${ambiente['distance'].toStringAsFixed(2)} m",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.red[700],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(color: Colors.red[300]!, width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _userPosition != null
                      ? "Coordenadas do Usuário:\n"
                          "Latitude: ${_userPosition!.latitude}\n"
                          "Longitude: ${_userPosition!.longitude}"
                      : "Localização do usuário não disponível",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 30,
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getCurrentLocation,
        tooltip: 'Atualizar Localização',
        backgroundColor: Colors.red[700],
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
