import 'package:cloud_firestore/cloud_firestore.dart';

class CodigoMultas {
  String? id;
  String descripcion;
  String parte;
  double precio;
  String titulo;

  CodigoMultas(
    this.titulo,
    this.parte,
    this.descripcion,
    this.precio,
  );

  CodigoMultas.fromFirestre(DocumentSnapshot<Map<String, dynamic>> docSnap)
      : id = docSnap.id,
        descripcion = docSnap['descripcion'],
        parte = docSnap['parte'],
        precio = docSnap['precio'],
        titulo = docSnap['titulo'];
}

Stream<List<CodigoMultas>> codigoMultasSnapshots(String idCasa) async* {
  final db = FirebaseFirestore.instance;
  final stream = db.collection("sesion/$idCasa/codigoMultas").snapshots();
  await for (final listaMultas in stream) {
    final List<CodigoMultas> multas = [];
    for (final multa in listaMultas.docs) {
      multas.add(CodigoMultas.fromFirestre(multa));
    }
    yield multas;
  }
}
