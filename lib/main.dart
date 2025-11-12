// lib/main.dart

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:scav/auth_check.dart';
import 'package:scav/core/app_theme.dart'; // Importa o nosso arquivo de tema

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SCAV - Controle de Veículos',

      // --- CONFIGURAÇÃO DO TEMA ---
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,

      // Força o aplicativo a usar o tema escuro sempre
      themeMode: ThemeMode.dark,

      debugShowCheckedModeBanner: false,
      home: const AuthCheck(),
    );
  }
}
