import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:somativa_flutter/login_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _animation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  bool _validateInputs() {
    if (_emailController.text.isEmpty) {
      _showError('Por favor, insira seu email.');
      return false;
    }
    if (_passwordController.text.isEmpty) {
      _showError('Por favor, insira sua senha.');
      return false;
    }
    if (_passwordController.text.length < 6) {
      _showError('A senha deve ter pelo menos 6 caracteres.');
      return false;
    }
    return true;
  }

  void _signup() async {
    if (!_validateInputs()) return;

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
      print('Conta criada: ${userCredential.user?.email}');
    } catch (e) {
      _showError('Erro ao criar conta: ${e.toString()}');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagem de fundo
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/login_flutter.png'), // Caminho da sua imagem de fundo
                fit: BoxFit.cover, // Cobre toda a tela
              ),
            ),
          ),
          // Conteúdo principal
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.transparent, // Fundo transparente
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Tamanho mínimo para a coluna
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 30),
                      const Text(
                        'Cadastre-se',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF004AAD), // Título em azul
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                          prefixIcon: const Icon(Icons.email, color: Color(0xFF004AAD)), // Ícone de email
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Senha',
                          labelStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                          prefixIcon: const Icon(Icons.lock, color: Color(0xFF004AAD)), // Ícone de cadeado
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 20),
                      ScaleTransition(
                        scale: _animation,
                        child: ElevatedButton(
                          onPressed: () {
                            _controller.forward();
                            _signup();
                            _controller.reverse();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red, // Fundo do botão em vermelho
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            shadowColor: Colors.redAccent, // Cor da sombra
                            elevation: 5,
                          ),
                          child: const Text(
                            'Criar conta',
                            style: TextStyle(color: Colors.white), // Texto do botão em branco
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginPage()),
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: ScaleTransition(
                          scale: _animation,
                          child: const Text(
                            'Já tem uma conta? Faça login',
                            style: TextStyle(color: Colors.red), // Texto em vermelho
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
