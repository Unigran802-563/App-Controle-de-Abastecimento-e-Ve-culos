import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scav/screens/auth/login_screen.dart';
import 'package:scav/screens/home_screen.dart';

class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    // O StreamBuilder fica "ouvindo" as mudanças no estado de autenticação
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Se estiver carregando (verificando o status), mostra um indicador de progresso
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Se o snapshot tem dados (ou seja, o 'User' não é nulo), o usuário está logado
        if (snapshot.hasData) {
          return const HomeScreen(); // Mostra a tela principal
        }

        // Se não tem dados, o usuário não está logado
        return const LoginScreen(); // Mostra a tela de login
      },
    );
  }
}
