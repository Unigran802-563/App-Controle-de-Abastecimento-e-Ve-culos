// lib/services/firestore_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scav/models/vehicle.dart';
import 'package:scav/models/refill.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Obtém o UID do usuário logado
  String? get _uid => _auth.currentUser?.uid;

  // Adicionar um novo veículo
  Future<void> addVehicle(Vehicle vehicle) async {
    if (_uid == null) return; // Não faz nada se não houver usuário logado

    // Acessa a coleção do usuário (pelo UID) e a subcoleção 'veiculos'
    await _db
        .collection('users')
        .doc(_uid)
        .collection('veiculos')
        .add(vehicle.toFirestore());
  }

  // Obter a lista de veículos do usuário em tempo real
  Stream<List<Vehicle>> getVehicles() {
    if (_uid == null)
      return Stream.value([]); // Retorna lista vazia se não houver usuário

    return _db
        .collection('users')
        .doc(_uid)
        .collection('veiculos')
        .snapshots() // snapshots() nos dá as atualizações em tempo real
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Vehicle.fromFirestore(doc.data(), doc.id))
              .toList(),
        );
  }

  // Excluir um veículo
  Future<void> deleteVehicle(String vehicleId) async {
    if (_uid == null) return;

    await _db
        .collection('users')
        .doc(_uid)
        .collection('veiculos')
        .doc(vehicleId)
        .delete();
  }

  Future<void> updateVehicle(Vehicle vehicle) async {
    if (_uid == null) return;

    // Acessa o documento específico pelo ID do veículo e atualiza seus dados
    await _db
        .collection('users')
        .doc(_uid)
        .collection('veiculos')
        .doc(vehicle.id)
        .update(vehicle.toFirestore());
  }

  Future<void> addRefill(Refill refill) async {
    if (_uid == null) return;

    // Salva na subcoleção 'abastecimentos' do usuário
    await _db
        .collection('users')
        .doc(_uid)
        .collection('abastecimentos')
        .add(refill.toFirestore());
  }

  // Obter a lista de abastecimentos do usuário em tempo real
  Stream<List<Refill>> getRefills() {
    if (_uid == null) return Stream.value([]);

    return _db
        .collection('users')
        .doc(_uid)
        .collection('abastecimentos')
        .orderBy('data', descending: true) // Ordena pelos mais recentes
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Refill.fromFirestore(doc.data(), doc.id))
              .toList(),
        );
  }

  Future<void> updateRefill(Refill refill) async {
    if (_uid == null) return;

    await _db
        .collection('users')
        .doc(_uid)
        .collection('abastecimentos')
        .doc(refill.id)
        .update(refill.toFirestore());
  }

  Future<void> deleteRefill(String refillId) async {
    if (_uid == null) return;

    await _db
        .collection('users')
        .doc(_uid)
        .collection('abastecimentos')
        .doc(refillId)
        .delete();
  }
}
