// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

class InsideUser {
  String? id;
  num color;
  String nombre;
  num dinero;
  num contador;
  String imagenPerfil;
  bool isAdmin;
  bool pendiente;

  InsideUser(
    this.id,
    this.color,
    this.nombre,
    this.dinero,
    this.contador,
    this.imagenPerfil,
    this.pendiente,
    this.isAdmin,
  );

  InsideUser.fromFirestre(DocumentSnapshot<Map<String, dynamic>> docSnap)
      : id = docSnap.id,
        color = docSnap['color'],
        nombre = docSnap['nombre'],
        dinero = docSnap['dinero'],
        contador = docSnap['contador'],
        imagenPerfil = docSnap['imagenPerfil'],
        pendiente = docSnap['pendiente'],
        isAdmin = docSnap['isAdmin'];
}

Stream<List<InsideUser>> simpleUsersSnapshot(String idCasa) async* {
  final db = FirebaseFirestore.instance;
  final stream = db
      .collection("sesion/$idCasa/users")
      .orderBy("color", descending: false)
      .snapshots();
  await for (final listaUsers in stream) {
    final List<InsideUser> users = [];
    for (final user in listaUsers.docs) {
      users.add(InsideUser.fromFirestre(user));
    }

    yield users;
  }
}

Stream<List<InsideUser>> usersMultarSnapshot(
    String idCasa, String userId) async* {
  final db = FirebaseFirestore.instance;
  final stream = db
      .collection("sesion/$idCasa/users")
      .where('id', isNotEqualTo: userId)
      .snapshots();
  await for (final listaUsers in stream) {
    final List<InsideUser> users = [];
    for (final user in listaUsers.docs) {
      users.add(InsideUser.fromFirestre(user));
    }

    yield users;
  }
}


Stream<InsideUser> singleUserData(
    String idCasa, String userId) async* {
  final db = FirebaseFirestore.instance;
  final stream = db
      .doc("sesion/$idCasa/users/$userId")
      .snapshots();
  await for (final user in stream) {
   
   yield InsideUser.fromFirestre(user);
  }
  }

  

