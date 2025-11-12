// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:scav/screens/widgets/app_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tela Inicial'), centerTitle: true),
      drawer: const AppDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ícone agora usa a cor primária do tema
            Icon(
              Icons.directions_car_filled,
              size: 100,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 20),
            const Text(
              'Bem-vindo ao SCAV!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text('Use o menu para começar.'),
          ],
        ),
      ),
    );
  }
}
