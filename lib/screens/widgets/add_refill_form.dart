// lib/screens/widgets/add_refill_form.dart

import 'package:flutter/material.dart';
import 'package:scav/models/refill.dart';
import 'package:scav/models/vehicle.dart';
import 'package:scav/services/firestore_service.dart';

class AddRefillForm extends StatefulWidget {
  final Refill? refillToEdit;

  const AddRefillForm({super.key, this.refillToEdit});

  @override
  State<AddRefillForm> createState() => _AddRefillFormState();
}

class _AddRefillFormState extends State<AddRefillForm> {
  final _formKey = GlobalKey<FormState>();
  final _litrosController = TextEditingController();
  final _valorController = TextEditingController();
  final _kmController = TextEditingController();

  final FirestoreService _firestoreService = FirestoreService();

  Vehicle? _selectedVehicle;
  List<Vehicle> _userVehicles = [];
  bool _isLoadingVehicles = true;

  @override
  void initState() {
    super.initState();
    // Busca os veículos do usuário para preencher o dropdown
    _firestoreService.getVehicles().first.then((vehicles) {
      setState(() {
        _userVehicles = vehicles;
        // Se estamos editando, preenchemos os campos
        if (widget.refillToEdit != null) {
          final refill = widget.refillToEdit!;
          _litrosController.text = refill.quantidadeLitros
              .toString()
              .replaceAll('.', ',');
          _valorController.text = refill.valorPago.toString().replaceAll(
            '.',
            ',',
          );
          _kmController.text = refill.quilometragem.toString();
          // Encontra e pré-seleciona o veículo no dropdown
          // Usamos try-catch para o caso de o veículo ter sido excluído
          try {
            _selectedVehicle = _userVehicles.firstWhere(
              (v) => v.id == refill.veiculoId,
            );
          } catch (e) {
            _selectedVehicle = null;
          }
        }
        _isLoadingVehicles = false;
      });
    });
  }

  @override
  void dispose() {
    _litrosController.dispose();
    _valorController.dispose();
    _kmController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedVehicle == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, selecione um veículo.')),
        );
        return;
      }

      final scaffoldMessenger = ScaffoldMessenger.of(context);

      // Mostra um indicador de carregamento enquanto salva
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      try {
        // Lógica para decidir entre criar um novo ou atualizar um existente
        if (widget.refillToEdit != null) {
          // MODO DE ATUALIZAÇÃO
          final updatedRefill = Refill(
            id: widget.refillToEdit!.id,
            data: widget.refillToEdit!.data,
            quantidadeLitros: double.parse(
              _litrosController.text.replaceAll(',', '.'),
            ),
            valorPago: double.parse(_valorController.text.replaceAll(',', '.')),
            quilometragem: int.parse(_kmController.text),
            tipoCombustivel: _selectedVehicle!.tipoCombustivel,
            veiculoId: _selectedVehicle!.id,
          );
          await _firestoreService.updateRefill(updatedRefill);
        } else {
          // MODO DE ADIÇÃO
          final newRefill = Refill(
            id: '',
            data: DateTime.now(),
            quantidadeLitros: double.parse(
              _litrosController.text.replaceAll(',', '.'),
            ),
            valorPago: double.parse(_valorController.text.replaceAll(',', '.')),
            quilometragem: int.parse(_kmController.text),
            tipoCombustivel: _selectedVehicle!.tipoCombustivel,
            veiculoId: _selectedVehicle!.id,
          );
          await _firestoreService.addRefill(newRefill);
        }

        if (mounted) {
          Navigator.of(context).pop(); // Fecha o indicador de carregamento
          Navigator.of(context).pop(); // Fecha o diálogo do formulário

          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Text(
                widget.refillToEdit == null
                    ? 'Abastecimento registrado com sucesso!'
                    : 'Abastecimento atualizado com sucesso!',
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          Navigator.of(context).pop(); // Fecha o indicador de carregamento
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Text('Erro ao salvar: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
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
            if (_isLoadingVehicles)
              const Center(child: CircularProgressIndicator())
            else if (_userVehicles.isEmpty)
              const Text(
                'Nenhum veículo cadastrado. Por favor, cadastre um veículo primeiro.',
              )
            else
              DropdownButtonFormField<Vehicle>(
                value: _selectedVehicle,
                hint: const Text('Selecione um Veículo'),
                isExpanded: true,
                onChanged: (Vehicle? newValue) {
                  setState(() {
                    _selectedVehicle = newValue;
                  });
                },
                items: _userVehicles.map<DropdownMenuItem<Vehicle>>((
                  Vehicle vehicle,
                ) {
                  return DropdownMenuItem<Vehicle>(
                    value: vehicle,
                    child: Text(
                      '${vehicle.marca} ${vehicle.modelo} (${vehicle.placa})',
                    ),
                  );
                }).toList(),
                validator: (value) =>
                    value == null ? 'Campo obrigatório' : null,
              ),

            TextFormField(
              controller: _litrosController,
              decoration: const InputDecoration(
                labelText: 'Litros Abastecidos',
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
            ),
            TextFormField(
              controller: _valorController,
              decoration: const InputDecoration(labelText: 'Valor Pago (R\$)'),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
            ),
            TextFormField(
              controller: _kmController,
              decoration: const InputDecoration(
                labelText: 'Quilometragem Atual',
              ),
              keyboardType: TextInputType.number,
              validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text(
                widget.refillToEdit == null
                    ? 'Salvar Abastecimento'
                    : 'Atualizar Abastecimento',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
