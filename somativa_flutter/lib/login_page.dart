import 'package:flutter/material.dart'; // Importa o pacote Material do Flutter para construção de UI
import 'package:firebase_auth/firebase_auth.dart'; // Importa o Firebase Auth para autenticação de usuários
import 'package:somativa_flutter/home_page.dart'; // Importa a página inicial após login
import 'signup_page.dart'; // Importa a página de registro

// Classe principal da página de login
class LoginPage extends StatefulWidget {
  const LoginPage({super.key}); // Construtor da classe LoginPage

  @override
  _LoginPageState createState() => _LoginPageState(); // Cria o estado associado à LoginPage
}

// Estado da página de login
class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController(); // Controlador para o campo de email
  final _passwordController = TextEditingController(); // Controlador para o campo de senha
  final FirebaseAuth _auth = FirebaseAuth.instance; // Instância do Firebase Auth
  late AnimationController _controller; // Controlador de animação
  late Animation<double> _animation; // Animação de escala

  @override
  void initState() {
    super.initState();
    // Inicializa o controlador de animação
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200), // Duração da animação
      vsync: this, // Define o estado atual como vsync
    );

    // Define a animação de escala de 1.0 a 0.9
    _animation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut), // Curva da animação
    );
  }

  // Método para mostrar mensagens de erro
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message), // Mensagem do SnackBar
        backgroundColor: Colors.red, // Cor de fundo do SnackBar
        duration: const Duration(seconds: 3), // Duração do SnackBar
      ),
    );
  }

  // Valida os campos de entrada
  bool _validateInputs() {
    if (_emailController.text.isEmpty) {
      _showError('Por favor, insira seu email.'); // Erro se email estiver vazio
      return false; // Retorna false se não é válido
    }
    if (_passwordController.text.isEmpty) {
      _showError('Por favor, insira sua senha.'); // Erro se senha estiver vazia
      return false; // Retorna false se não é válido
    }
    return true; // Retorna true se ambos os campos estão preenchidos
  }

  // Método para realizar o login
  void _login() async {
    if (!_validateInputs()) return; // Valida os inputs antes de prosseguir

    try {
      // Tenta autenticar com email e senha
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(), // Email do controlador
        password: _passwordController.text.trim(), // Senha do controlador
      );
      // Navega para a página inicial em caso de sucesso
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
      print('Login realizado: ${userCredential.user?.email}'); // Log do usuário logado
    } catch (e) {
      // Exibe erro se falhar na autenticação
      _showError('Erro ao realizar login: ${e.toString()}');
    }
  }

  @override
  void dispose() {
    _controller.dispose(); // Destrói o controlador ao sair da página
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Método de construção da UI
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
                    borderRadius: BorderRadius.circular(16), // Bordas arredondadas
                  ),
                  child: Column(
                    mainAxisSize:
                        MainAxisSize.min, // Tamanho mínimo para a coluna
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 30),
                      const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 28, // Tamanho da fonte do título
                          fontWeight: FontWeight.bold, // Negrito
                          color: Color(0xFF004AAD), // Cor do título
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      // Campo de entrada para email
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email', // Texto do rótulo
                          labelStyle: const TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0)), // Cor do rótulo
                          prefixIcon: const Icon(Icons.email,
                              color: Color(0xFF004AAD)), // Ícone de email
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10), // Bordas arredondadas
                            borderSide: const BorderSide(color: Colors.red), // Cor da borda
                          ),
                          filled: true,
                          fillColor: Colors.grey[200], // Cor de fundo do campo
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10), // Padding interno
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Campo de entrada para senha
                      TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Senha', // Texto do rótulo
                          labelStyle: const TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0)), // Cor do rótulo
                          prefixIcon: const Icon(Icons.lock,
                              color: Color(0xFF004AAD)), // Ícone de cadeado
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10), // Bordas arredondadas
                            borderSide: const BorderSide(color: Colors.red), // Cor da borda
                          ),
                          filled: true,
                          fillColor: Colors.grey[200], // Cor de fundo do campo
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10), // Padding interno
                        ),
                        obscureText: true, // Oculta texto da senha
                      ),
                      const SizedBox(height: 10),
                      // Botão para recuperação de senha
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
                          style: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0)), // Texto em preto
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Botão de login com animação
                      ScaleTransition(
                        scale: _animation,
                        child: ElevatedButton(
                          onPressed: () {
                            _controller.forward(); // Inicia a animação
                            _login(); // Tenta realizar login
                            _controller.reverse(); // Reverte a animação
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.red, // Cor de fundo do botão
                            padding: const EdgeInsets.symmetric(vertical: 16), // Padding do botão
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10), // Bordas arredondadas
                            ),
                            shadowColor: Colors.redAccent, // Cor da sombra
                            elevation: 5, // Elevação do botão
                          ),
                          child: const Text(
                            'Login',
                            style: TextStyle(
                                color: Colors.white), // Texto do botão em branco
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Botões de login social
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ScaleTransition(
                            scale: _animation,
                            child: IconButton(
                              icon: const Icon(Icons.facebook,
                                  color: Colors.blue), // Ícone do Facebook
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
                              icon: const Icon(Icons.email,
                                  color: Colors.red), // Ícone do Google
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
                              icon: const Icon(Icons.apple,
                                  color: Colors.black), // Ícone da Apple
                              iconSize: 40,
                              onPressed: () {
                                // Login com Apple
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Botão para criar nova conta
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignupPage()), // Navega para a página de registro
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16), // Padding do botão
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), // Bordas arredondadas
                          ),
                        ),
                        child: ScaleTransition(
                          scale: _animation,
                          child: const Text(
                            'Criar conta',
                            style: TextStyle(
                                color: Colors.red), // Texto em vermelho
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
