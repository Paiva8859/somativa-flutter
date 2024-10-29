import 'package:flutter/material.dart'; // Importa o pacote Material do Flutter para construir a interface do usuário
import 'package:firebase_core/firebase_core.dart'; // Importa o Firebase Core para inicialização do Firebase
import 'login_page.dart'; // Importa a página de login

// Função principal do aplicativo
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Garante que as operações do Flutter estejam ligadas antes de qualquer inicialização
  await Firebase.initializeApp(); // Inicializa o Firebase antes de rodar o aplicativo
  runApp(const MyApp()); // Executa o aplicativo passando a classe MyApp
}

// Classe principal do aplicativo
class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Construtor da classe MyApp

  @override
  Widget build(BuildContext context) {
    // Método de construção da UI
    return MaterialApp(
      title: 'Flutter Firebase Auth', // Título do aplicativo
      theme: ThemeData(
        primarySwatch: Colors.blue, // Define a cor primária do tema
      ),
      home: const LoginPage(), // Define a página inicial como a LoginPage
    );
  }
}
