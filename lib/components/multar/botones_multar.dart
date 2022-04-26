import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:penalty_flat_app/Styles/colors.dart';
import 'package:provider/provider.dart';
import '../../models/user.dart';

class BotonesMultar extends StatelessWidget {
  final String sesionId;
  final String idMultado;
  final String multaId;
  final Function callbackMultado;
  final String imgName;
  final File? imgFile;
  BotonesMultar(
      {Key? key,
      required this.sesionId,
      required this.idMultado,
      required this.multaId,
      required this.callbackMultado,
      required this.imgName,
      required this.imgFile})
      : super(key: key);

  final db = FirebaseFirestore.instance;
  final List<Color> colors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.indigo,
    Colors.pinkAccent,
    Colors.amber,
    Colors.deepOrange,
    Colors.brown,
    Colors.cyan,
    Colors.yellow,
  ];

  final DateTime dateToday = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      DateTime.now().hour,
      DateTime.now().minute,
      DateTime.now().second);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    return StreamBuilder(
        stream: db.doc("sesion/$sesionId/users/$idMultado").snapshots(),
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
              stream:
                  db.doc("sesion/$sesionId/codigoMultas/$multaId").snapshots(),
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
                final multaData = snapshot.data!.data()!;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextButton(
                        style: TextButton.styleFrom(
                            primary: PageColors.blue,
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                side: BorderSide(
                                    color: Colors.black.withOpacity(0.5))),
                            minimumSize: const Size(120, 20)),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancelar',
                            style: TextStyle(fontSize: 15)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextButton(
                        style: TextButton.styleFrom(
                            primary: PageColors.blue,
                            backgroundColor: PageColors.yellow,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            minimumSize: const Size(120, 25)),
                        onPressed: () async {
                          
                          var multaActual = await db
                              .collection('sesion/$sesionId/multas')
                              .add({
                            'titulo': multaData['titulo'],
                            'descripcion': multaData['descripcion'],
                            'autorId': user!.uid,
                            'precio': multaData['precio'],
                            'nomMultado': userData['nombre'],
                            'idMultado': userData['id'],
                            'imagen': imgName,
                            'parte': multaData['parte'],
                            'fecha': dateToday,
                            'aceptada': false,
                            'pagado': false
                          });

                          imgFile == null
                              ? null
                              : await FirebaseStorage.instance
                                  .ref("/images/multas/$imgName")
                                  .putFile(imgFile as File);

                          await db
                              .collection('sesion/$sesionId/notificaciones')
                              .add({
                            'subtitulo': multaData['titulo'],
                            'idMulta': multaActual.id,
                            'idUsuario': userData['id'],
                            'tipo': "multa",
                            'fecha': dateToday,
                            'visto': false,
                          });

                          callbackMultado(true);

                          

                          // debugPrint(widget.idMultado);
                        },
                        child: const Text('Multar',
                            style: TextStyle(fontSize: 15)),
                      ),
                    ),
                  ],
                );
              });
        });
  }
}
