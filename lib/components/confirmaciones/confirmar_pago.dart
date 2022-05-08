import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:penalty_flat_app/Styles/colors.dart';
import 'package:penalty_flat_app/models/user.dart';
import 'package:penalty_flat_app/services/sesionProvider.dart';
import 'package:penalty_flat_app/shared/loading.dart';
import 'package:provider/provider.dart';

class BotonesConfirmacion extends StatefulWidget {
  final String notifyId;
  final String userId;
  const BotonesConfirmacion({
    Key? key,
    required this.notifyId,
    required this.userId,
  }) : super(key: key);

  @override
  State<BotonesConfirmacion> createState() => _BotonesConfirmacionState();
}

DateTime dateToday = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,
    DateTime.now().hour, DateTime.now().minute, DateTime.now().second);

class _BotonesConfirmacionState extends State<BotonesConfirmacion> {
  bool pagado = false;
  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;
    final user = Provider.of<MyUser?>(context);
    final idCasa = Provider.of<SesionProvider?>(context)!.sesionCode;

    return StreamBuilder(
      stream: db.collection("sesion/$idCasa/users").orderBy("color", descending: false).snapshots(),
      builder: (
        BuildContext context,
        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
      ) {
        if (snapshot.hasError) {
          return ErrorWidget(snapshot.error.toString());
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final allUsers = snapshot.data!.docs;

        return StreamBuilder(
          stream: db.doc("sesion/$idCasa/users/${widget.userId}").snapshots(),
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

            return StreamBuilder(
              stream: db.doc("sesion/$idCasa/notificaciones/${widget.notifyId}").snapshots(),
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

                Map notifyData = {};
                snapshot.data?.data() != null
                    ? notifyData = snapshot.data!.data()!
                    : notifyData = {};

                return notifyData.isEmpty
                    ? const Loading()
                    : StreamBuilder(
                        stream: db
                            .collection("sesion/$idCasa/multas")
                            .where('fecha', isLessThan: notifyData['fecha'])
                            .where("idMultado", isEqualTo: widget.userId)
                            .snapshots(),
                        builder: (
                          BuildContext context,
                          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
                        ) {
                          if (snapshot.hasError) {
                            return ErrorWidget(snapshot.error.toString());
                          }
                          if (!snapshot.hasData) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          final multasPagadas = snapshot.data!.docs;

                          if (pagado) {
                            for (int i = 0; i < multasPagadas.length; i++) {
                              db.doc('sesion/$idCasa/multas/${multasPagadas[i].id}').update({
                                'pagado': true,
                              });
                            }
                          }

                          return StreamBuilder(
                            stream: db.doc("sesion/$idCasa/users/${user?.uid}").snapshots(),
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
                              final currentUserData = snapshot.data!.data()!;

                              return Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 10.0),
                                        child: ElevatedButton(
                                          style:
                                              ElevatedButton.styleFrom(primary: PageColors.white),
                                          child: Text(
                                            "!No ha pagado!",
                                            style: TextStyle(color: PageColors.blue),
                                          ),
                                          onPressed: () async {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                duration: Duration(seconds: 1),
                                                content: Text("Pago rechazado"),
                                              ),
                                            );
                                            await db
                                                .doc('sesion/$idCasa/users/${widget.userId}')
                                                .update({
                                              'contador': 0,
                                              'pendiente': false,
                                              'dinero': userData['dinero']
                                            });
                                            await db
                                                .doc(
                                                    'sesion/$idCasa/notificaciones/${widget.notifyId}')
                                                .update({
                                              'visto': true,
                                            });
                                            await db
                                                .collection("sesion/$idCasa/notificaciones")
                                                .add({
                                              'mensaje': "Pago rechazado por:",
                                              'subtitulo': "${currentUserData['nombre']}",
                                              'idUsuario': widget.userId,
                                              'fecha': dateToday,
                                              'tipo': "feedback",
                                              'visto': false,
                                              'idNotificador': user?.uid
                                            });
                                            Navigator.pop(context);

                                            await db
                                                .doc(
                                                    "sesion/$idCasa/notificaciones/${widget.notifyId}")
                                                .delete();
                                          },
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 10.0),
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                primary: PageColors.yellow),
                                            child: Text(
                                              "Confirmar pago",
                                              style: TextStyle(color: PageColors.blue),
                                            ),
                                            onPressed: () async {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  duration: Duration(seconds: 1),
                                                  content: Text("Pago confirmado"),
                                                ),
                                              );
                                              setState(() {
                                                pagado = true;
                                              });
                                              if (userData['contador'] == allUsers.length - 1) {
                                                await db
                                                    .collection("sesion/$idCasa/notificaciones")
                                                    .add({
                                                  'mensaje': "Pago aceptado",
                                                  'subtitulo': "Tus compañeros lo han confirmado",
                                                  'idUsuario': widget.userId,
                                                  'fecha': dateToday,
                                                  'tipo': "feedback",
                                                  'visto': false,
                                                });
                                              }
                                              await db
                                                  .doc(
                                                      'sesion/$idCasa/notificaciones/${widget.notifyId}')
                                                  .update({
                                                'visto': true,
                                              });
                                              await db
                                                  .doc('sesion/$idCasa/users/${widget.userId}')
                                                  .update({
                                                'contador': userData['contador'] + 1,
                                                'pendiente':
                                                    (userData['contador'] == allUsers.length - 1)
                                                        ? false
                                                        : userData['pendiente'],
                                                'dinero':
                                                    (userData['contador'] == allUsers.length - 1)
                                                        ? 0
                                                        : userData['dinero']
                                              });

                                              Navigator.pop(context);
                                              await db
                                                  .doc(
                                                      "sesion/$idCasa/notificaciones/${widget.notifyId}")
                                                  .delete();
                                            }),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      );
              },
            );
          },
        );
      },
    );
  }
}
