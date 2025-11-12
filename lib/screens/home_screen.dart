// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:scav/screens/widgets/app_drawer.dart'; // Importe o Drawer

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tela Inicial'), centerTitle: true),
      // Adicione o Drawer aqui
      drawer: const AppDrawer(),
      body: const Center(
        // Mantenha uma mensagem de boas-vindas ou adicione uma imagem
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.directions_car_filled,
              size: 100,
              color: Colors.blueAccent,
            ),
            SizedBox(height: 20),
            Text(
              'Bem-vindo ao SCAV!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text('Use o menu para começar.'),
          ],
        ),
      ),
    );
  }
}
