// lib/screens/vehicles_screen.dart

import 'package:flutter/material.dart';
import 'package:scav/models/vehicle.dart';
import 'package:scav/services/firestore_service.dart';
import 'package:scav/screens/widgets/add_vehicle_form.dart';

class VehiclesScreen extends StatefulWidget {
  const VehiclesScreen({super.key});

  @override
  State<VehiclesScreen> createState() => _VehiclesScreenState();
}

class _VehiclesScreenState extends State<VehiclesScreen> {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meus Veículos'), centerTitle: true),
      body: StreamBuilder<List<Vehicle>>(
        stream: _firestoreService.getVehicles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum veículo cadastrado.'));
          }

          final vehicles = snapshot.data!;

          return ListView.builder(
            itemCount: vehicles.length,
            itemBuilder: (context, index) {
              final vehicle = vehicles[index];
              return ListTile(
                leading: const Icon(Icons.directions_car, size: 40),
                title: Text('${vehicle.marca} ${vehicle.modelo}'),
                subtitle: Text('Placa: ${vehicle.placa} - Ano: ${vehicle.ano}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // --- BOTÃO DE EDITAR ---
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      tooltip: 'Editar',
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Editar Veículo'),
                            content: AddVehicleForm(vehicleToEdit: vehicle),
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
                    // --- BOTÃO DE EXCLUIR ---
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      tooltip: 'Excluir',
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Confirmar Exclusão'),
                            content: const Text(
                              'Tem certeza que deseja excluir este veículo?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: const Text('Excluir'),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          await _firestoreService.deleteVehicle(vehicle.id);
                        }
                      },
                    ),
                  ],
                ), // Fim do Row
              ); // Fim do ListTile
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Adicionar Novo Veículo'),
              content:
                  const AddVehicleForm(), // Para ADICIONAR, não passamos vehicleToEdit
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
              ],
            ),
          );
        },
        tooltip: 'Adicionar Veículo',
        child: const Icon(Icons.add),
      ),
    );
  }
}
