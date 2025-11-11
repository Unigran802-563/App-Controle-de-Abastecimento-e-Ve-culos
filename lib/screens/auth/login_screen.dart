import 'package:flutter/material.dart';
import 'package:scav/screens/auth/register_screen.dart';
import 'package:scav/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login'), centerTitle: true),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Adicione uma imagem/logo aqui se desejar
                // Image.asset('assets/logo.png', height: 150),
                const SizedBox(height: 48),

                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Por favor, insira seu e-mail';
                    }
                    if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                      return 'Por favor, insira um e-mail válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Senha',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira sua senha';
                    }
                    if (value.length < 6) {
                      return 'A senha deve ter no mínimo 6 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () async {
                    // Transforme em async
                    if (_formKey.currentState!.validate()) {
                      // Mostra um indicador de carregamento
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Entrando...')),
                      );

                      // Chama o método de login do nosso serviço
                      final user = await _authService
                          .signInWithEmailAndPassword(
                            email: _emailController.text,
                            password: _passwordController.text,
                          );

                      // Remove o indicador de carregamento
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();

                      if (user != null) {
                        // Se o login for bem-sucedido, NAVEGA PARA A TELA PRINCIPAL
                        print('Login bem-sucedido: ${user.uid}');
                        // A lógica de navegação para a HomeScreen virá aqui
                      } else {
                        // Se houver um erro (usuário não encontrado, senha errada), mostra uma mensagem
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('E-mail ou senha inválidos.'),
                            ),
                          );
                        }
                      }
                    }
                  },

                  child: const Text('Entrar'),
                ),
                TextButton(
                  // SUBSTITUA O ONPRESSED ANTIGO POR ESTE
                  onPressed: () {
                    // Este código navega para a tela de cadastro
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const RegisterScreen(),
                      ),
                    );
                  },
                  child: const Text('Não tem uma conta? Cadastre-se'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
