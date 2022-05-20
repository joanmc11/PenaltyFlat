import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:penalty_flat_app/screens/misPenaltyFlats/inici.dart';
import 'dart:math';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  //collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future updateUserdata(String nombre) async {
    return await userCollection.doc(uid).set({
      'nombre': nombre,
    });
  }

  Future updateUserFlats(String nombreCasa, String idCasa) async {
    return await userCollection.doc(uid).collection('casas').add({
      'nombreCasa': nombreCasa,
      'idCasa': idCasa,
    });
  }

  //Create House

  Future createHouse(String casa, String apodo, context) async {
    //Get Random String
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnPpQqRrSsTtUuVvWwXxYyZz123456789';
    final Random _rnd = Random();
    final db = FirebaseFirestore.instance;
    String getRandomString(int length) =>
        String.fromCharCodes(Iterable.generate(
            length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

    final sesionSnap = await db.collection('/sesion').add({
      "codi": getRandomString(5),
      "casa": casa,
      "partes": ["Todas", "Baño", "Comedor", "Cocina", "Lavadero", "Otros"],
      "sinMultas": true,
    });
    await db.doc('/sesion/${sesionSnap.id}/users/$uid').set({
      "nombre": apodo,
      "color": 0,
      "id": uid,
      "isAdmin": true,
      "imagenPerfil": "",
      "dinero": 0,
      "pendiente": false,
      'contador': 1,
    });

    db.collection('/sesion/${sesionSnap.id}/notificaciones');

    //creo la collection de casas (inicialment buida)
    await DatabaseService(uid: uid).updateUserFlats(casa, sesionSnap.id);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        duration: Duration(seconds: 1),
        content: Text("¡Has creado un PenaltyFlat!"),
      ),
    );
    await Future.delayed(const Duration(milliseconds: 300), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Inicio(),
          ));
    });
  }

//Join House

  Future joinHouse(codi, apodo, context) async {
    final db = FirebaseFirestore.instance;
    final sesionSnap =
        await db.collection('sesion').where('codi', isEqualTo: codi).get();

    if (sesionSnap.docs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 1),
          content: Text("¡Código inexistente!"),
        ),
      );
    } else {
      //id de la sesio
      final sesionId = sesionSnap.docs[0].id;

      //Comprovo si l'usuari ja hi és a la sesió
      final userIn = await db
          .collection('sesion/$sesionId/users')
          .where('id', isEqualTo: uid)
          .get();

      //si no hi és l'afageixo
      if (userIn.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 1),
            content:
                Text("Ya perteneces a está sesión, no puedes entrar dos veces"),
          ),
        );
      } else {
        //Afageixo un color per defecte a l'usuari segons la llargaria dels usuaris
        final userLen = await db.collection('sesion/$sesionId/users').get();

        await db.doc('/sesion/$sesionId/users/$uid').set({
          "nombre": apodo,
          "color": userLen.docs.length,
          "id": uid,
          "isAdmin": false,
          "imagenPerfil": "",
          "dinero": 0,
          "pendiente": false,
          'contador': 1,
        });

        //Busco el nom de la casa
        final casa = await db.doc('sesion/$sesionId').get();
        final String casaNombre = casa['casa'];
        //creo la collection de casas de l'usuari (inicialment buida)
        await DatabaseService(uid: uid).updateUserFlats(casaNombre, sesionId);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 1),
            content: Text("¡Te has unido a la PenaltyFlat!"),
          ),
        );
        await Future.delayed(const Duration(milliseconds: 300), () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Inicio(),
              ));
        });
      }
    }
  }
}
