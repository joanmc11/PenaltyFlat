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

Stream<List<CodigoMultas>> partesMultasSnapshots(
    String idCasa, String parte) async* {
  final db = FirebaseFirestore.instance;
  final stream = db
      .collection("sesion/$idCasa/codigoMultas")
      .where('parte', isEqualTo: parte)
      .snapshots();
  await for (final listaMultas in stream) {
    final List<CodigoMultas> multas = [];
    for (final multa in listaMultas.docs) {
      multas.add(CodigoMultas.fromFirestre(multa));
    }
    yield multas;
  }
}

Stream<List<CodigoMultas>> searchMultasSnapshots(
    String idCasa, String search) async* {
  final db = FirebaseFirestore.instance;
  final stream = db
      .collection("sesion/$idCasa/codigoMultas")
      .where('titulo', isGreaterThanOrEqualTo: search.toLowerCase())
      .where('titulo',
          isLessThan: search
                  .toLowerCase()
                  .substring(0, search.toLowerCase().length - 1) +
              String.fromCharCode(
                  search.toLowerCase().codeUnitAt(search.length - 1) + 1))
      .snapshots();
  await for (final listaMultas in stream) {
    final List<CodigoMultas> multas = [];
    for (final multa in listaMultas.docs) {
      multas.add(CodigoMultas.fromFirestre(multa));
    }
    yield multas;
  }
}

Stream<List<CodigoMultas>> searchParteMultasSnapshots(
    String idCasa, String search, String parte) async* {
  final db = FirebaseFirestore.instance;
  final stream = db
      .collection("sesion/$idCasa/codigoMultas")
      .where('parte', isEqualTo: parte)
      .where('titulo', isGreaterThanOrEqualTo: search.toLowerCase())
      .where('titulo',
          isLessThan: search
                  .toLowerCase()
                  .substring(0, search.toLowerCase().length - 1) +
              String.fromCharCode(
                  search.toLowerCase().codeUnitAt(search.length - 1) + 1))
      .snapshots();
  await for (final listaMultas in stream) {
    final List<CodigoMultas> multas = [];
    for (final multa in listaMultas.docs) {
      multas.add(CodigoMultas.fromFirestre(multa));
    }
    yield multas;
  }
}

 Stream<CodigoMultas> singleNormaSnapshot(
    String idCasa, String idMulta) async* {
  final db = FirebaseFirestore.instance;
  final stream = db.doc("sesion/$idCasa/codigoMultas/$idMulta").snapshots();

  
  await for (final multa in stream) {
   
   yield CodigoMultas.fromFirestre(multa);
  }
  
  
  }

