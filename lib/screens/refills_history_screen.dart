// lib/screens/refills_history_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scav/models/refill.dart';
import 'package:scav/screens/widgets/add_refill_form.dart';
import 'package:scav/services/firestore_service.dart';

class RefillsHistoryScreen extends StatelessWidget {
  const RefillsHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FirestoreService firestoreService = FirestoreService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Abastecimentos'),
        centerTitle: true,
      ),
      body: StreamBuilder<List<Refill>>(
        stream: firestoreService.getRefills(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Nenhum abastecimento registrado.'),
            );
          }

          final refills = snapshot.data!;

          return ListView.builder(
            itemCount: refills.length,
            itemBuilder: (context, index) {
              final refill = refills[index];
              final formattedDate = DateFormat(
                'dd/MM/yyyy',
              ).format(refill.data);

              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blueAccent.withOpacity(0.1),
                    child: const Icon(
                      Icons.local_gas_station,
                      color: Colors.blueAccent,
                    ),
                  ),
                  title: Text(
                    '${refill.quantidadeLitros.toStringAsFixed(2)} L - ${refill.tipoCombustivel}',
                  ),
                  subtitle: Text(
                    'Data: $formattedDate - Km: ${refill.quilometragem}',
                  ),
                  trailing: Text(
                    'R\$ ${refill.valorPago.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.green,
                    ),
                  ),
                  // AÇÃO DE EDITAR: Toque simples no item
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Editar Abastecimento'),
                        content: AddRefillForm(refillToEdit: refill),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cancelar'),
                          ),
                        ],
                      ),
                    );
                  },
                  // AÇÃO DE EXCLUIR: Toque longo no item
                  onLongPress: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Confirmar Exclusão'),
                        content: const Text(
                          'Tem certeza que deseja excluir este registro de abastecimento?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                            child: const Text('Excluir'),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      await firestoreService.deleteRefill(refill.id);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Abastecimento excluído com sucesso.',
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
