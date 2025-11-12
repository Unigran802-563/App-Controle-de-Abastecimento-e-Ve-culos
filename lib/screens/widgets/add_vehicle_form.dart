// lib/screens/widgets/add_vehicle_form.dart

import 'package:flutter/material.dart';
import 'package:scav/models/vehicle.dart';
import 'package:scav/services/firestore_service.dart';

// --- PARTE 1: O WIDGET EM SI ---
// Ele só precisa saber se vai receber um veículo para editar.
class AddVehicleForm extends StatefulWidget {
  final Vehicle? vehicleToEdit;

  const AddVehicleForm({super.key, this.vehicleToEdit});

  @override
  State<AddVehicleForm> createState() => _AddVehicleFormState();
}

// --- PARTE 2: O ESTADO DO WIDGET ---
// Toda a lógica, controladores e a aparência ficam aqui.
class _AddVehicleFormState extends State<AddVehicleForm> {
  final _formKey = GlobalKey<FormState>();
  final _modeloController = TextEditingController();
  final _marcaController = TextEditingController();
  final _placaController = TextEditingController();
  final _anoController = TextEditingController();
  final _tipoCombustivelController = TextEditingController();

  final FirestoreService _firestoreService = FirestoreService();

  // O initState fica DENTRO da classe _AddVehicleFormState
  @override
  void initState() {
    super.initState();
    // Se estamos editando (se widget.vehicleToEdit não for nulo),
    // preenchemos o formulário com os dados existentes.
    if (widget.vehicleToEdit != null) {
      final vehicle = widget.vehicleToEdit!;
      _marcaController.text = vehicle.marca;
      _modeloController.text = vehicle.modelo;
      _placaController.text = vehicle.placa;
      _anoController.text = vehicle.ano.toString();
      _tipoCombustivelController.text = vehicle.tipoCombustivel;
    }
  }

  @override
  void dispose() {
    _modeloController.dispose();
    _marcaController.dispose();
    _placaController.dispose();
    _anoController.dispose();
    _tipoCombustivelController.dispose();
    super.dispose();
  }

  // Função de submit atualizada para lidar com ADICIONAR e EDITAR
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Verifica se estamos em modo de edição
      if (widget.vehicleToEdit != null) {
        final updatedVehicle = Vehicle(
          id: widget.vehicleToEdit!.id, // USA O ID EXISTENTE
          modelo: _modeloController.text,
          marca: _marcaController.text,
          placa: _placaController.text,
          ano: int.tryParse(_anoController.text) ?? 0,
          tipoCombustivel: _tipoCombustivelController.text,
        );
        await _firestoreService.updateVehicle(updatedVehicle);
      } else {
        // Se não, estamos em modo de adição
        final newVehicle = Vehicle(
          id: '', // ID vazio, será gerado pelo Firestore
          modelo: _modeloController.text,
          marca: _marcaController.text,
          placa: _placaController.text,
          ano: int.tryParse(_anoController.text) ?? 0,
          tipoCombustivel: _tipoCombustivelController.text,
        );
        await _firestoreService.addVehicle(newVehicle);
      }

      if (mounted) {
        Navigator.of(context).pop(); // Fecha o diálogo
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
              // O texto do botão muda dependendo se estamos adicionando ou editando
              child: Text(
                widget.vehicleToEdit == null
                    ? 'Salvar Veículo'
                    : 'Atualizar Veículo',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
