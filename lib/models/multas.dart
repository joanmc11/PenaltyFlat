import 'package:cloud_firestore/cloud_firestore.dart';

class Multa {
  String? id;
  String autorId;
  String desripcion;
  String idMultado;
  String imagen;
  String nomMultado;
  bool pagado;
  String parte;
  num precio;
  String titulo;
  bool aceptada;
  DateTime fecha;

  Multa(
    this.id,
    this.autorId,
    this.idMultado,
    this.titulo,
    this.desripcion,
    this.precio,
    this.nomMultado,
    this.imagen,
    this.parte,
    this.pagado,
    this.aceptada,
    this.fecha,
  );

  Multa.fromFirestre(DocumentSnapshot<Map<String, dynamic>> docSnap)
      : id = docSnap.id,
        autorId = docSnap['autorId'],
        idMultado = docSnap['idMultado'],
        titulo = docSnap['titulo'],
        desripcion = docSnap['descripcion'],
        precio = docSnap['precio'],
        nomMultado = docSnap['nomMultado'],
        imagen = docSnap['imagen'],
        parte = docSnap['parte'],
        pagado = docSnap['pagado'],
        aceptada = docSnap['aceptada'],
        fecha = DateTime.fromMicrosecondsSinceEpoch(
            docSnap['fecha'].microsecondsSinceEpoch);
}

Stream<List<Multa>> miniListaSnapshots(String idCasa) async* {
  final db = FirebaseFirestore.instance;
  final stream = db
      .collection("sesion/$idCasa/multas")
      .where('aceptada', isEqualTo: true)
      .orderBy('fecha', descending: true)
      .snapshots();
  await for (final listaMultas in stream) {
    final List<Multa> multas = [];
    for (final multa in listaMultas.docs) {
      multas.add(Multa.fromFirestre(multa));
    }

    yield multas;
  }
}

Stream<List<Multa>> listaMultasSnapshots(
  String idCasa,
  bool selected,
  String selectedMonth,
  int monthValue,
  int yearValue,
  String userId,
) async* {
  final db = FirebaseFirestore.instance;
  final stream = selected
      ? db
          .collection("sesion/$idCasa/multas")
          .where('aceptada', isEqualTo: true)
          .where('fecha',
              isGreaterThanOrEqualTo: DateTime(
                  selectedMonth == "Todas" ? 2020 : yearValue, monthValue, 01))
          .where('fecha',
              isLessThan: DateTime(selectedMonth == "Todas" ? 2160 : yearValue,
                  monthValue + 1, 01))
          .orderBy('fecha', descending: true)
          .snapshots()
      : db
          .collection("sesion/$idCasa/multas")
          .where('aceptada', isEqualTo: true)
          .where('idMultado', isEqualTo: userId)
          .where('fecha',
              isGreaterThanOrEqualTo: DateTime(
                  selectedMonth == "Todas" ? 2020 : yearValue, monthValue, 01))
          .where('fecha',
              isLessThan: DateTime(selectedMonth == "Todas" ? 2160 : yearValue,
                  monthValue + 1, 01))
          .orderBy('fecha', descending: true)
          .snapshots();
  await for (final listaMultas in stream) {
    final List<Multa> multas = [];
    for (final multa in listaMultas.docs) {
      multas.add(Multa.fromFirestre(multa));
    }

    yield multas;
  }
}

Stream<Multa> singleMultaSnapshot(String idCasa, String idMulta) async* {
  final db = FirebaseFirestore.instance;
  final stream = db.doc("sesion/$idCasa/multas/$idMulta").snapshots();

  await for (final multa in stream) {
    yield Multa.fromFirestre(multa);
  }
}


Stream<List<Multa>> multasAceptadas(String idCasa) async* {
  final db = FirebaseFirestore.instance;
  final stream = db
      .collection("sesion/$idCasa/multas")
      .where('aceptada', isEqualTo: true)
      .orderBy('fecha', descending: true)
      .snapshots();
  await for (final listaMultas in stream) {
    final List<Multa> multas = [];
    for (final multa in listaMultas.docs) {
      multas.add(Multa.fromFirestre(multa));
    }

    yield multas;
  }
}
