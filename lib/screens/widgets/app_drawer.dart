// lib/screens/widgets/app_drawer.dart

import 'package:flutter/material.dart';
import 'package:scav/screens/refills_history_screen.dart';
import 'package:scav/screens/vehicles_screen.dart';
import 'package:scav/services/auth_service.dart';
import 'package:scav/screens/widgets/add_refill_form.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blueAccent),
            child: Text(
              'Menu Principal',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.directions_car),
            title: const Text('Meus Veículos'),
            onTap: () {
              Navigator.of(context).pop(); // Fecha o drawer
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const VehiclesScreen()),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.local_gas_station),
            title: const Text('Registrar Abastecimento'),
            onTap: () {
              Navigator.of(context).pop(); // Fecha o drawer primeiro
              // Mostra o formulário em um diálogo
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Registrar Abastecimento'),
                  content: const AddRefillForm(),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancelar'),
                    ),
                  ],
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Histórico de Abastecimentos'),
            onTap: () {
              Navigator.of(context).pop(); // Fecha o drawer
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const RefillsHistoryScreen(),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sair'),
            onTap: () {
              authService.signOut();
              Navigator.of(context).pop(); // Fecha o drawer
            },
          ),
        ],
      ),
    );
  }
}
