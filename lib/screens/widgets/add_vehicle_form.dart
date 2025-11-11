// lib/screens/widgets/add_vehicle_form.dart

import 'package:flutter/material.dart';
import 'package:scav/models/vehicle.dart';
import 'package:scav/services/firestore_service.dart';

class AddVehicleForm extends StatefulWidget {
  const AddVehicleForm({super.key});

  @override
  State<AddVehicleForm> createState() => _AddVehicleFormState();
}

class _AddVehicleFormState extends State<AddVehicleForm> {
  final _formKey = GlobalKey<FormState>();
  final _modeloController = TextEditingController();
  final _marcaController = TextEditingController();
  final _placaController = TextEditingController();
  final _anoController = TextEditingController();
  final _tipoCombustivelController = TextEditingController();

  final FirestoreService _firestoreService = FirestoreService();

  @override
  void dispose() {
    _modeloController.dispose();
    _marcaController.dispose();
    _placaController.dispose();
    _anoController.dispose();
    _tipoCombustivelController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final newVehicle = Vehicle(
        id: '', // O ID será gerado pelo Firestore
        modelo: _modeloController.text,
        marca: _marcaController.text,
        placa: _placaController.text,
        ano: int.tryParse(_anoController.text) ?? 0,
        tipoCombustivel: _tipoCombustivelController.text,
      );

      await _firestoreService.addVehicle(newVehicle);

      if (mounted) {
        Navigator.of(context).pop(); // Fecha o diálogo após adicionar
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _marcaController,
              decoration: const InputDecoration(labelText: 'Marca'),
              validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
            ),
            TextFormField(
              controller: _modeloController,
              decoration: const InputDecoration(labelText: 'Modelo'),
              validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
            ),
            TextFormField(
              controller: _placaController,
              decoration: const InputDecoration(labelText: 'Placa'),
              validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
            ),
            TextFormField(
              controller: _anoController,
              decoration: const InputDecoration(labelText: 'Ano'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value!.isEmpty) return 'Campo obrigatório';
                if (int.tryParse(value) == null)
                  return 'Insira um número válido';
                return null;
              },
            ),
            TextFormField(
              controller: _tipoCombustivelController,
              decoration: const InputDecoration(
                labelText: 'Tipo de Combustível',
              ),
              validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              child: const Text('Salvar Veículo'),
            ),
          ],
        ),
      ),
    );
  }
}
