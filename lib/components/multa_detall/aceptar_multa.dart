import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:penalty_flat_app/screens/display_paginas.dart';
import 'package:provider/provider.dart';
import '../../../Styles/colors.dart';
import '../../../models/user.dart';

class AceptarMulta extends StatelessWidget {
  final String idMulta;
  final String notifyId;
  AceptarMulta({
    Key? key,
    required this.idMulta,
    required this.notifyId,
  }) : super(key: key);
  final db = FirebaseFirestore.instance;

  final DateTime dateToday = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,
      DateTime.now().hour, DateTime.now().minute, DateTime.now().second);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    final idCasa = context.read<CasaID>();

    return StreamBuilder(
      stream: db.doc("sesion/$idCasa/multas/$idMulta").snapshots(),
      builder: (
        BuildContext context,
        AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot,
      ) {
        if (snapshot.hasError) {
          return ErrorWidget(snapshot.error.toString());
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        Map multaData = {};
        snapshot.data?.data() != null ? multaData = snapshot.data!.data()! : multaData = {};

        return StreamBuilder(
          stream: db.doc("sesion/$idCasa/users/${user!.uid}").snapshots(),
          builder: (
            BuildContext context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot,
          ) {
            if (snapshot.hasError) {
              return ErrorWidget(snapshot.error.toString());
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final userData = snapshot.data!.data()!;
            return !multaData['aceptada']
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(primary: PageColors.white),
                            child: Text(
                              "Rechazar",
                              style: TextStyle(color: PageColors.blue),
                            ),
                            onPressed: () async {
                              await db.collection('sesion/$idCasa/notificaciones').add({
                                'fecha': dateToday,
                                'tipo': "feedback",
                                'mensaje': "${userData['nombre']} ha rechazado la multa",
                                'subtitulo': multaData['titulo'],
                                'visto': false,
                                'idUsuario': multaData['autorId'],
                                'idNotificador': user.uid,
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  duration: Duration(seconds: 2),
                                  content: Text("Multa rechazada"),
                                ),
                              );
                              Navigator.pop(context);
                              await db.doc("sesion/$idCasa/multas/$idMulta").delete();
                              await db.doc("sesion/$idCasa/notificaciones/$notifyId").delete();
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(primary: PageColors.yellow),
                            child: Text(
                              "Aceptar",
                              style: TextStyle(color: PageColors.blue),
                            ),
                            onPressed: () async {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  duration: Duration(seconds: 2),
                                  content: Text("Multa aceptada"),
                                ),
                              );
                              await db.doc('sesion/$idCasa/multas/$idMulta').update({
                                'aceptada': true,
                              });
                              await db.doc('sesion/$idCasa/users/${user.uid}').update({
                                'dinero': userData['dinero'] == null
                                    ? multaData['precio']
                                    : userData['dinero'] + multaData['precio'],
                              });
                              await db.collection('sesion/$idCasa/notificaciones').add({
                                'fecha': dateToday,
                                'tipo': "feedback",
                                'mensaje': "${userData['nombre']} ha aceptado la multa",
                                'subtitulo': multaData['titulo'],
                                'visto': false,
                                'idUsuario': multaData['autorId'],
                                'idNotificador': user.uid,
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  )
                : multaData['pagado']
                    ? const Center(
                        child: Text(
                          "Multa pagada",
                          style: TextStyle(
                              color: Colors.green, fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      )
                    : const Center(
                        child: Text(
                          "Multa por pagar",
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      );
          },
        );
      },
    );
  }
}
