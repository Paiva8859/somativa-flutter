import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:somativa_flutter/home_page.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
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

  void _login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
      print('Login realizado: ${userCredential.user?.email}');
    } catch (e) {
      print(e);
      // Exiba uma mensagem de erro ao usuário
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
                        'Login',
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
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          // Ação de esqueci a senha
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          alignment: Alignment.centerLeft,
                        ),
                        child: const Text(
                          'Esqueci minha senha?',
                          style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)), // Texto em preto
                        ),
                      ),
                      const SizedBox(height: 20),
                      ScaleTransition(
                        scale: _animation,
                        child: ElevatedButton(
                          onPressed: () {
                            _controller.forward();
                            _login();
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
                            'Login',
                            style: TextStyle(color: Colors.white), // Texto do botão em branco
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ScaleTransition(
                            scale: _animation,
                            child: IconButton(
                              icon: const Icon(Icons.facebook, color: Colors.blue), // Ícone do Facebook
                              iconSize: 40,
                              onPressed: () {
                                // Login com Facebook
                              },
                            ),
                          ),
                          const SizedBox(width: 20),
                          ScaleTransition(
                            scale: _animation,
                            child: IconButton(
                              icon: const Icon(Icons.email, color: Colors.red), // Ícone do Google
                              iconSize: 40,
                              onPressed: () {
                                // Login com Google
                              },
                            ),
                          ),
                          const SizedBox(width: 20),
                          ScaleTransition(
                            scale: _animation,
                            child: IconButton(
                              icon: const Icon(Icons.apple, color: Colors.black), // Ícone da Apple
                              iconSize: 40,
                              onPressed: () {
                                // Login com Apple
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SignupPage()),
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
                            'Criar conta',
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
