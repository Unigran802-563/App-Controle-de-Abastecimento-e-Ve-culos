// lib/models/refill.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class Refill {
  final String id;
  final DateTime data;
  final double quantidadeLitros;
  final double valorPago;
  final int quilometragem;
  final String tipoCombustivel;
  final String veiculoId; // ID do veículo associado
  final String? observacao;
  final double? consumo; // Consumo (km/l), pode ser calculado depois

  Refill({
    required this.id,
    required this.data,
    required this.quantidadeLitros,
    required this.valorPago,
    required this.quilometragem,
    required this.tipoCombustivel,
    required this.veiculoId,
    this.observacao,
    this.consumo,
  });

  // Converte um Documento do Firestore para um objeto Refill
  factory Refill.fromFirestore(Map<String, dynamic> firestoreDoc, String id) {
    return Refill(
      id: id,
      data: (firestoreDoc['data'] as Timestamp).toDate(),
      quantidadeLitros: (firestoreDoc['quantidadeLitros'] as num).toDouble(),
      valorPago: (firestoreDoc['valorPago'] as num).toDouble(),
      quilometragem: firestoreDoc['quilometragem'] ?? 0,
      tipoCombustivel: firestoreDoc['tipoCombustivel'] ?? '',
      veiculoId: firestoreDoc['veiculoId'] ?? '',
      observacao: firestoreDoc['observacao'],
      consumo: (firestoreDoc['consumo'] as num?)?.toDouble(),
    );
  }

  // Converte um objeto Refill para um Map para salvar no Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'data': Timestamp.fromDate(data),
      'quantidadeLitros': quantidadeLitros,
      'valorPago': valorPago,
      'quilometragem': quilometragem,
      'tipoCombustivel': tipoCombustivel,
      'veiculoId': veiculoId,
      'observacao': observacao,
      'consumo': consumo,
    };
  }
}
