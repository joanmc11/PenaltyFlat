// ignore_for_file: deprecated_member_use, unnecessary_null_comparison

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:penalty_flat_app/models/multas.dart';
import 'package:penalty_flat_app/models/usersInside.dart';
import 'package:penalty_flat_app/screens/misPenaltyFlats/inici.dart';
import 'dart:math';

import 'package:penalty_flat_app/services/functions.dart';

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

  //Crear Norma
  Future createMulta(
      idCasa, titulo, descripcion, parteCasa, precio, context) async {
    final db = FirebaseFirestore.instance;
    await db.collection('sesion/$idCasa/codigoMultas').add({
      'titulo': titulo.toLowerCase(),
      'descripcion': descripcion.toLowerCase(),
      'parte': parteCasa,
      'precio': precio,
    });

    await db.doc('sesion/$idCasa').update({
      "sinMultas": false,
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        duration: Duration(seconds: 1),
        content: Text("¡Norma creada con éxito!"),
      ),
    );
    await Future.delayed(const Duration(milliseconds: 300), () {
      Navigator.of(context).pop();
    });
  }

  //Editar Norma

  Future editNorma(String idCasa, multaId, String titulo, String descripcion,
      String parteCasa, precio, context) async {
    final db = FirebaseFirestore.instance;

    await db.doc('sesion/$idCasa/codigoMultas/$multaId').update({
      'titulo': titulo.toLowerCase(),
      'descripcion': descripcion.toLowerCase(),
      'parte': parteCasa,
      'precio': precio,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        duration: Duration(seconds: 1),
        content: Text("¡Norma actualizada!"),
      ),
    );
    await Future.delayed(const Duration(milliseconds: 300), () {
      Navigator.of(context).pop();
    });
  }

  //Eliminar Norma
  Future deleteNorma(String idCasa, multaId, context) async {
    final db = FirebaseFirestore.instance;
    await showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: const Text("¿Eliminar norma?"),
              content: const Text("¿Estás seguro?"),
              actions: [
                FlatButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      await db
                          .doc("sesion/$idCasa/codigoMultas/$multaId")
                          .delete();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          duration: Duration(seconds: 1),
                          content: Text("Norma eliminada"),
                        ),
                      );
                      await Future.delayed(const Duration(milliseconds: 300),
                          () {
                        Navigator.of(context).pop();
                      });
                    },
                    child: const Text(
                      "Si",
                      style: TextStyle(color: Colors.blue),
                    )),
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child:
                        const Text("No", style: TextStyle(color: Colors.blue)))
              ],
            ),
        barrierDismissible: false);
  }

  //Cambiar Imagen Perfil
  Future changeProfileImage(
    String idCasa,
  ) async {
    final db = FirebaseFirestore.instance;
    final image = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 25);
    if (image == null) return;
    final imageTemporary = File(image.path);
    await db.doc('sesion/$idCasa/users/$uid').update({
      'imagenPerfil': image.name,
    });
    await FirebaseStorage.instance
        .ref("/images/${image.name}")
        .putFile(imageTemporary);
  }

//Rechazar Multa

  Future rejectMulta(
    String idCasa,
    InsideUser userData,
    Multa multaData,
    String notifyId,
    context,
  ) async {
    final dateToday = FunctionService().takeDate();
    final db = FirebaseFirestore.instance;
    await db.collection('sesion/$idCasa/notificaciones').add({
      'fecha': dateToday,
      'tipo': "feedback",
      'mensaje': "${userData.nombre} ha rechazado la multa",
      'subtitulo': multaData.titulo,
      'visto': false,
      'idUsuario': multaData.autorId,
      'idNotificador': uid,
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        duration: Duration(seconds: 2),
        content: Text("Multa rechazada"),
      ),
    );

    await db.doc("sesion/$idCasa/multas/${multaData.id}").delete();
    await db.doc("sesion/$idCasa/notificaciones/$notifyId").delete();
  }

  //Aceptar Multa
  Future acceptMulta(
    String idCasa,
    Multa multaData,
    InsideUser userData,
    context,
  ) async {
    final dateToday = FunctionService().takeDate();
    final db = FirebaseFirestore.instance;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        duration: Duration(seconds: 2),
        content: Text("Multa aceptada"),
      ),
    );
    await db.doc('sesion/$idCasa/multas/${multaData.id}').update({
      'aceptada': true,
    });
    await db.doc('sesion/$idCasa/users/$uid').update({
      'dinero': userData.dinero == null
          ? multaData.precio
          : userData.dinero + multaData.precio,
    });
    await db.collection('sesion/$idCasa/notificaciones').add({
      'fecha': dateToday,
      'tipo': "feedback",
      'mensaje': "${userData.nombre} ha aceptado la multa",
      'subtitulo': multaData.titulo,
      'visto': false,
      'idUsuario': multaData.autorId,
      'idNotificador': uid,
    });
  }

  //Envio de notificaciones en pagamentos

  Future pagamentos(singleUserData, usersData, context, idCasa) async {
    final db = FirebaseFirestore.instance;
    if (singleUserData.dinero == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(milliseconds: 800),
          content: Text("Nada que pagar"),
        ),
      );
    } else if (singleUserData.pendiente == false) {
      if (singleUserData.pendiente == false) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(milliseconds: 800),
            content: Text("Espera a que tus compañeros confirmen el pago"),
          ),
        );
        for (int i = 0; i < usersData.length; i++) {
          if (usersData[i].id != uid) {
            await db.collection('sesion/$idCasa/notificaciones').add({
              'nomPagador': singleUserData.nombre,
              'idPagador': uid,
              'idUsuario': usersData[i].id,
              'tipo': "pago",
              'fecha': FunctionService().takeDate(),
              'visto': false,
            });
            await db
                .doc('sesion/$idCasa/users/$uid')
                .update({'contador': 1, 'pendiente': true});
          }
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(milliseconds: 800),
          content: Text("Espera a que tus compañeros confirmen el pago"),
        ),
      );
    }
  }

  //Set Multas pagadas
  Future multasPagadas(List<Multa> multasPagadas, String idCasa) async {
    final db = FirebaseFirestore.instance;
    for (int i = 0; i < multasPagadas.length; i++) {
      await db.doc('sesion/$idCasa/multas/${multasPagadas[i].id}').update({
        'pagado': true,
      });
    }
  }

  //Rechazar pago ajeno
  Future rechazarPago(
    String idCasa,
    context,
    userData,
    userId,
    currentUserData,
    notifyId,
  ) async {
    final db = FirebaseFirestore.instance;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        duration: Duration(seconds: 1),
        content: Text("Pago rechazado"),
      ),
    );
    await db
        .doc('sesion/$idCasa/users/$userId')
        .update({'contador': 0, 'pendiente': false, 'dinero': userData.dinero});
    await db.doc('sesion/$idCasa/notificaciones/$notifyId').update({
      'visto': true,
    });
    await db.collection("sesion/$idCasa/notificaciones").add({
      'mensaje': "Pago rechazado por:",
      'subtitulo': currentUserData.nombre,
      'idUsuario': userId,
      'fecha': FunctionService().takeDate(),
      'tipo': "feedback",
      'visto': false,
      'idNotificador': uid
    });

    await db.doc("sesion/$idCasa/notificaciones/$notifyId").delete();
  }

  //Aceptar pago ajeno
  Future aceptarPago(
    String idCasa,
    context,
    userData,
    userId,
    currentUserData,
    notifyId,
    allUsers,
  ) async {
    final db = FirebaseFirestore.instance;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        duration: Duration(seconds: 1),
        content: Text("Pago confirmado"),
      ),
    );

    if (userData.contador == allUsers.length - 1) {
      await db.collection("sesion/$idCasa/notificaciones").add({
        'mensaje': "Pago aceptado",
        'subtitulo': "Tus compañeros lo han confirmado",
        'idUsuario': userId,
        'fecha': FunctionService().takeDate(),
        'tipo': "feedback",
        'visto': false,
      });
    }
    await db.doc('sesion/$idCasa/notificaciones/$notifyId').update({
      'visto': true,
    });
    await db.doc('sesion/$idCasa/users/$userId').update({
      'contador': userData.contador + 1,
      'pendiente': (userData.contador == allUsers.length - 1)
          ? false
          : userData.pendiente,
      'dinero': (userData.contador == allUsers.length - 1) ? 0 : userData.dinero
    });

    Navigator.pop(context);
    await db.doc("sesion/$idCasa/notificaciones/$notifyId").delete();
  }

  //Poner una multa
  Future ponerMulta(multaData, userData, imgName, imgFile, idCasa) async {
    final db = FirebaseFirestore.instance;
    var multaActual = await db.collection('sesion/$idCasa/multas').add({
      'titulo': multaData.titulo,
      'descripcion': multaData.descripcion,
      'autorId': uid,
      'precio': multaData.precio,
      'nomMultado': userData.nombre,
      'idMultado': userData.id,
      'imagen': imgName,
      'parte': multaData.parte,
      'fecha': FunctionService().takeDate(),
      'aceptada': false,
      'pagado': false
    });

    imgFile == null
        ? null
        : await FirebaseStorage.instance
            .ref("/images/multas/$imgName")
            .putFile(imgFile as File);

    await db.collection('sesion/$idCasa/notificaciones').add({
      'subtitulo': multaData.titulo,
      'idMulta': multaActual.id,
      'idUsuario': userData.id,
      'tipo': "multa",
      'fecha': FunctionService().takeDate(),
      'visto': false,
    });

    // debugPrint(widget.idMultado);
  }
}
