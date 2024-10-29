import 'package:flutter/material.dart'; // Importa o pacote Material do Flutter para construção de UI
import 'package:geolocator/geolocator.dart'; // Importa o pacote Geolocator para acesso à localização do dispositivo
import 'package:cloud_firestore/cloud_firestore.dart'; // Importa o Firestore para acesso ao banco de dados Firebase
import 'package:firebase_auth/firebase_auth.dart'; // Importa o Firebase Auth para autenticação de usuários
import 'package:local_auth/local_auth.dart'; // Importa o pacote de autenticação local para biometria

// Classe principal da página inicial
class HomePage extends StatefulWidget {
  const HomePage({super.key}); // Construtor da classe HomePage

  @override
  _HomePageState createState() => _HomePageState(); // Cria o estado associado à HomePage
}

// Estado da página inicial
class _HomePageState extends State<HomePage> {
  // Variáveis para armazenar informações sobre localização e ambientes
  String _locationMessage = "Obtendo localização..."; // Mensagem inicial de localização
  List<Map<String, dynamic>> _nearbyAmbientes = []; // Lista de ambientes próximos
  String _closestAmbiente = "Sem ambientes próximos"; // Mensagem padrão quando não há ambientes
  Position? _userPosition; // Posição atual do usuário
  final FirebaseAuth _auth = FirebaseAuth.instance; // Instância do Firebase Auth
  final LocalAuthentication _localAuth = LocalAuthentication(); // Instância de autenticação local
  bool _biometricAvailable = false; // Flag para verificar disponibilidade de biometria

  @override
  void initState() {
    super.initState(); // Chama o método initState da superclasse
    _getCurrentLocation(); // Obtém a localização atual do usuário
  }

  // Método para autenticar o usuário com biometria
  autentica() async {
    bool canAuthenticateWithBiometrics = await _localAuth.canCheckBiometrics; // Verifica se biometria pode ser usada
    if (canAuthenticateWithBiometrics) {
      final didAuth = await _localAuth.authenticate(
          localizedReason: "Por favor, insira sua credencial"); // Solicita autenticação biométrica
      if (didAuth) {
        _showMessage('Acesso autorizado!'); // Mensagem de sucesso
      }
    }
  }

  // Verifica se o dispositivo suporta biometria
  Future<void> _checkBiometricSupport() async {
    try {
      bool canAuthenticateWithBiometrics = await _localAuth.canCheckBiometrics; // Verifica suporte à biometria
      bool canAuthenticate = await _localAuth.isDeviceSupported(); // Verifica se o dispositivo é suportado
      bool hasBiometrics = await _localAuth
          .getAvailableBiometrics()
          .then((biometrics) => biometrics.isNotEmpty); // Verifica se há biometria disponível

      setState(() {
        _biometricAvailable =
            canAuthenticate && canAuthenticateWithBiometrics && hasBiometrics; // Atualiza a flag
      });

      if (!_biometricAvailable) {
        _showMessage(
            "Este dispositivo não suporta ou não possui biometria registrada."); // Mensagem de erro
      }
    } catch (e) {
      print("Erro ao verificar suporte à biometria: $e"); // Log de erro
      _showMessage("Erro ao verificar suporte à biometria."); // Mensagem de erro
    }
  }

  // Obtém a localização atual do usuário
  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission(); // Verifica permissão de localização
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission(); // Solicita permissão se não foi concedida
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _locationMessage =
            "Permissão negada. Não é possível obter a localização."; // Mensagem se a permissão foi negada
      });
      return; // Retorna se a permissão não foi concedida
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high); // Obtém a posição atual
    setState(() {
      _userPosition = position; // Atualiza a posição do usuário
      _locationMessage =
          "Localização: \nLatitude: ${position.latitude}\nLongitude: ${position.longitude}"; // Atualiza a mensagem de localização
    });

    await _fetchNearbyAmbientes(position.latitude, position.longitude); // Busca ambientes próximos
  }

  // Busca ambientes próximos na base de dados
  Future<void> _fetchNearbyAmbientes(double latitude, double longitude) async {
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('Ambientes').get(); // Obtém os documentos da coleção 'Ambientes'

    List<Map<String, dynamic>> ambientes = []; // Lista para armazenar ambientes próximos

    for (var doc in snapshot.docs) {
      double ambienteLatitude = double.parse(doc['latitude']); // Obtém latitude do ambiente
      double ambienteLongitude = double.parse(doc['longitude']); // Obtém longitude do ambiente
      double distance = Geolocator.distanceBetween(
          latitude, longitude, ambienteLatitude, ambienteLongitude); // Calcula a distância

      // Adiciona o ambiente se estiver a 20 metros ou menos
      if (distance <= 20) {
        ambientes.add({
          'id': doc.id, // ID do documento
          'localizacao': doc['localizacao'], // Localização do ambiente
          'latitude': ambienteLatitude, // Latitude do ambiente
          'longitude': ambienteLongitude, // Longitude do ambiente
          'distance': distance, // Distância do usuário até o ambiente
        });
      }
    }

    // Ordena a lista de ambientes pela distância
    ambientes.sort((a, b) => a['distance'].compareTo(b['distance']));

    setState(() {
      _nearbyAmbientes = ambientes; // Atualiza a lista de ambientes próximos
      _closestAmbiente = ambientes.isNotEmpty
          ? ambientes.first['localizacao'] // Atualiza o ambiente mais próximo
          : "Sem ambientes próximos"; // Mensagem padrão
    });
  }

  // Verifica se o usuário está autorizado a acessar um ambiente específico
  Future<void> _checkAuthorization(String ambienteId) async {
    try {
      String userEmail = _auth.currentUser?.email ?? ""; // Obtém o e-mail do usuário autenticado
      if (userEmail.isEmpty) {
        _showMessage("Usuário não autenticado"); // Mensagem se não há usuário autenticado
        return;
      }

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Ambientes')
          .doc(ambienteId)
          .collection('usuarios_autorizados')
          .doc(userEmail)
          .get(); // Verifica autorização no Firestore

      if (!userDoc.exists) {
        _showMessage("Acesso negado: usuário não autorizado"); // Mensagem de erro se não autorizado
      } else {
        autentica(); // Se autorizado, tenta autenticar
      }
    } catch (e) {
      print("Erro na verificação de autorização: $e"); // Log de erro
      _showMessage("Erro na verificação de autorização."); // Mensagem de erro
    }
  }

  // Exibe uma mensagem em um diálogo
  void _showMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message), // Título do diálogo
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // Fecha o diálogo ao pressionar o botão
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Método de construção da UI
    return Scaffold(
      backgroundColor: Colors.grey[100], // Cor de fundo
      appBar: AppBar(
        title: const Text(
          'Localização do Usuário', // Título da AppBar
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.red[700], // Cor de fundo da AppBar
        elevation: 5, // Elevação da AppBar
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              _closestAmbiente, // Exibe o ambiente mais próximo
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
              itemCount: _nearbyAmbientes.length, // Número de ambientes próximos
              itemBuilder: (context, index) {
                final ambiente = _nearbyAmbientes[index]; // Obtém o ambiente atual
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 4, // Elevação do card
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15), // Bordas arredondadas
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16), // Padding do ListTile
                    leading: const Icon(
                      Icons.business, // Ícone do ambiente
                      color: Colors.red,
                      size: 40,
                    ),
                    title: Text(
                      "${ambiente['id']}", // ID do ambiente
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text(
                      ambiente['localizacao'], // Localização do ambiente
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    trailing: Text(
                      "Distância: ${ambiente['distance'].toStringAsFixed(2)} m", // Distância até o ambiente
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.red[700],
                      ),
                    ),
                    onTap: () {
                      _checkAuthorization(ambiente['id']); // Verifica autorização ao tocar no ambiente
                    },
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.red[50], // Cor de fundo do container
              borderRadius: BorderRadius.circular(12.0), // Bordas arredondadas
              border: Border.all(color: Colors.red[300]!, width: 2), // Borda do container
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _userPosition != null
                      ? "Coordenadas do Usuário:\n"
                          "Latitude: ${_userPosition!.latitude}\n"
                          "Longitude: ${_userPosition!.longitude}" // Exibe coordenadas do usuário
                      : "Localização do usuário não disponível", // Mensagem se a localização não está disponível
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                const Icon(
                  Icons.location_on, // Ícone de localização
                  color: Colors.red,
                  size: 30,
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getCurrentLocation, // Atualiza localização ao pressionar o botão
        tooltip: 'Atualizar Localização',
        backgroundColor: Colors.red[700],
        child: const Icon(Icons.my_location), // Ícone do botão
      ),
    );
  }
}
