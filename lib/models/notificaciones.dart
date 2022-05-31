import 'package:cloud_firestore/cloud_firestore.dart';

class Notificacion {
  String? id;
  String idNotificador;
  String idUsuario;
  String mensaje;
  String subtitulo;
  String tipo;
  bool visto;
  DateTime fecha;
  String idMulta;
  String idPagador;
  String nomPagador;

  Notificacion(
    this.id,
    this.idNotificador,
    this.idUsuario,
    this.tipo,
    this.mensaje,
    this.subtitulo,
    this.visto,
    this.fecha,
    this.idMulta,
    this.idPagador,
    this.nomPagador,
  );

  Notificacion.fromFirestre(DocumentSnapshot<Map<String, dynamic>> docSnap)
      : id = docSnap.id,
        idNotificador = docSnap['tipo'] == 'feedback'
            ? docSnap['mensaje'] == 'Pago aceptado'
                ? ""
                : docSnap['idNotificador']
            : "",
        idUsuario = docSnap['idUsuario'],
        tipo = docSnap['tipo'],
        mensaje = docSnap['tipo'] == 'feedback' ? docSnap['mensaje'] : "",
        subtitulo = docSnap['tipo'] == 'pago' ? "" : docSnap['subtitulo'],
        visto = docSnap['visto'],
        fecha = DateTime.fromMicrosecondsSinceEpoch(
            docSnap['fecha'].microsecondsSinceEpoch),
        idMulta = docSnap['tipo'] == 'multa' ? docSnap['idMulta'] : "",
        idPagador = docSnap['tipo'] == 'pago' ? docSnap['idPagador'] : "",
        nomPagador = docSnap['tipo'] == 'pago' ? docSnap['nomPagador'] : "";
}

Stream<Notificacion> singleNotification(String idCasa, String notifyId) async* {
  final db = FirebaseFirestore.instance;
  final stream = db.doc("sesion/$idCasa/notificaciones/$notifyId").snapshots();

  await for (final notify in stream) {
    yield Notificacion.fromFirestre(notify);
  }
}

Stream<List<Notificacion>> notificacionesNoVistas(String idCasa, uid) async* {
  final db = FirebaseFirestore.instance;
  final stream = db
      .collection("sesion/$idCasa/notificaciones")
      .where('idUsuario', isEqualTo: uid)
      .where('visto', isEqualTo: false)
      .snapshots();
  await for (final listaMultas in stream) {
    final List<Notificacion> listNotify = [];
    for (final notify in listaMultas.docs) {
      listNotify.add(Notificacion.fromFirestre(notify));
    }

    yield listNotify;
  }
}

Stream<List<Notificacion>> notificacionesUsuario(String idCasa, uid) async* {
  final db = FirebaseFirestore.instance;
  final stream = db
      .collection("sesion/$idCasa/notificaciones")
      .where("idUsuario", isEqualTo: uid)
      .orderBy("fecha", descending: true)
      .snapshots();
  await for (final listaMultas in stream) {
    final List<Notificacion> listNotify = [];
    for (final notify in listaMultas.docs) {
      listNotify.add(Notificacion.fromFirestre(notify));
    }

    yield listNotify;
  }
}
