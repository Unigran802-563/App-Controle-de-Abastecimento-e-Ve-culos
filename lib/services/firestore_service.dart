// lib/services/firestore_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scav/models/vehicle.dart';

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
}
