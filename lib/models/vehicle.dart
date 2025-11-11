// lib/models/vehicle.dart

class Vehicle {
  final String id;
  final String modelo;
  final String marca;
  final String placa;
  final int ano;
  final String tipoCombustivel;

  Vehicle({
    required this.id,
    required this.modelo,
    required this.marca,
    required this.placa,
    required this.ano,
    required this.tipoCombustivel,
  });

  // Converte um Documento do Firestore para um objeto Vehicle
  factory Vehicle.fromFirestore(Map<String, dynamic> firestoreDoc, String id) {
    return Vehicle(
      id: id,
      modelo: firestoreDoc['modelo'] ?? '',
      marca: firestoreDoc['marca'] ?? '',
      placa: firestoreDoc['placa'] ?? '',
      ano: firestoreDoc['ano'] ?? 0,
      tipoCombustivel: firestoreDoc['tipoCombustivel'] ?? '',
    );
  }

  // Converte um objeto Vehicle para um Map para salvar no Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'modelo': modelo,
      'marca': marca,
      'placa': placa,
      'ano': ano,
      'tipoCombustivel': tipoCombustivel,
    };
  }
}
