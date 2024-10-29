import 'package:flutter/material.dart'; // Importa o pacote Material do Flutter para a interface do usuário
import 'package:firebase_auth/firebase_auth.dart'; // Importa o Firebase Auth para autenticação de usuários
import 'package:somativa_flutter/login_page.dart'; // Importa a página de login

// Classe principal para a página de cadastro
class SignupPage extends StatefulWidget {
  const SignupPage({super.key}); // Construtor da classe SignupPage

  @override
  _SignupPageState createState() => _SignupPageState(); // Cria o estado da página
}

// Classe que mantém o estado da SignupPage
class _SignupPageState extends State<SignupPage>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController(); // Controlador para o campo de email
  final _passwordController = TextEditingController(); // Controlador para o campo de senha
  final FirebaseAuth _auth = FirebaseAuth.instance; // Instância do FirebaseAuth
  late AnimationController _controller; // Controlador de animação
  late Animation<double> _animation; // Animação que será usada para efeito de botão

  @override
  void initState() {
    super.initState();
    _controller = AnimationController( // Inicializa o controlador de animação
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    // Define a animação de escala
    _animation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  // Função para mostrar mensagens de erro
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Valida os inputs do usuário
  bool _validateInputs() {
    if (_emailController.text.isEmpty) {
      _showError('Por favor, insira seu email.'); // Mensagem de erro se o email estiver vazio
      return false;
    }
    if (_passwordController.text.isEmpty) {
      _showError('Por favor, insira sua senha.'); // Mensagem de erro se a senha estiver vazia
      return false;
    }
    if (_passwordController.text.length < 6) {
      _showError('A senha deve ter pelo menos 6 caracteres.'); // Mensagem de erro se a senha for muito curta
      return false;
    }
    return true; // Retorna true se todas as validações passarem
  }

  // Função para criar um novo usuário
  void _signup() async {
    if (!_validateInputs()) return; // Verifica se os inputs são válidos

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword( // Cria uma nova conta com email e senha
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // Redireciona para a página de login após o cadastro
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
      print('Conta criada: ${userCredential.user?.email}'); // Exibe no console o email da nova conta
    } catch (e) {
      _showError('Erro ao criar conta: ${e.toString()}'); // Mostra mensagem de erro em caso de falha
    }
  }

  @override
  void dispose() {
    _controller.dispose(); // Libera os recursos do controlador de animação
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Método de construção da interface do usuário
    return Scaffold(
      body: Stack(
        children: [
          // Imagem de fundo
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/login_flutter.png'), // Caminho da imagem de fundo
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
                        'Cadastre-se', // Título da página
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF004AAD), // Cor do título
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      // Campo de email
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: const TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0)),
                          prefixIcon: const Icon(Icons.email,
                              color: Color(0xFF004AAD)), // Ícone de email
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Campo de senha
                      TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Senha',
                          labelStyle: const TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0)),
                          prefixIcon: const Icon(Icons.lock,
                              color: Color(0xFF004AAD)), // Ícone de cadeado
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                        ),
                        obscureText: true, // Oculta o texto da senha
                      ),
                      const SizedBox(height: 20),
                      // Botão para criar conta
                      ScaleTransition(
                        scale: _animation,
                        child: ElevatedButton(
                          onPressed: () {
                            _controller.forward(); // Inicia a animação
                            _signup(); // Tenta criar a conta
                            _controller.reverse(); // Reverte a animação
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red, // Cor do botão
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            shadowColor: Colors.redAccent, // Cor da sombra
                            elevation: 5,
                          ),
                          child: const Text(
                            'Criar conta', // Texto do botão
                            style: TextStyle(
                                color: Colors.white), // Cor do texto
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Botão para redirecionar para a página de login
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()),
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
                            'Já tem uma conta? Faça login', // Texto do botão
                            style: TextStyle(
                                color: Colors.red), // Cor do texto
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
