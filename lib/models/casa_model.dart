import 'package:cloud_firestore/cloud_firestore.dart';

class Casa {
  String? id;
  String nombreCasa;
  String idCasa;

  Casa(this.idCasa, 
  this.nombreCasa);

  Casa.fromFirestore(DocumentSnapshot<Map<String, dynamic>> docSnap)
      : id = docSnap.id,
        idCasa = docSnap['idCasa'],
        nombreCasa = docSnap['nombreCasa'];
}

Stream<List<Casa>> casasSnapshots(String idUsuario) async* {
  final db = FirebaseFirestore.instance;
  final stream = db.collection("users/$idUsuario/casas").snapshots();
  await for (final listaCasas in stream) {
    final List<Casa> casas = [];
    for (final casa in listaCasas.docs) {
      casas.add(Casa.fromFirestore(casa));
    }

    yield casas;
  }
}

