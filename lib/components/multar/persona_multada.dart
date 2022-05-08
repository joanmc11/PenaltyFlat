import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:penalty_flat_app/Styles/colors.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:penalty_flat_app/services/sesionProvider.dart';
import 'package:provider/provider.dart';

class PersonaMultaDetalle extends StatelessWidget {
  final String idMultado;
  PersonaMultaDetalle({
    Key? key,
    required this.idMultado,
  }) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    final storage = FirebaseStorage.instance;
    final idCasa = Provider.of<SesionProvider?>(context)!.sesionCode;
    return StreamBuilder(
        stream: db.doc("sesion/$idCasa/users/$idMultado").snapshots(),
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
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("¿A quién?", style: TiposBlue.subtitle),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: DottedBorder(
                      radius: const Radius.circular(8),
                      borderType: BorderType.Circle,
                      dashPattern: const [5],
                      color: colors[userData['color']],
                      strokeWidth: 1,
                      child: userData['imagenPerfil'] == ""
                          ? Icon(
                              Icons.account_circle_rounded,
                              color: colors[userData['color']],
                              size: 80,
                            )
                          : FutureBuilder(
                              future: storage
                                  .ref("/images/${userData['imagenPerfil']}")
                                  .getDownloadURL(),
                              builder: (context, AsyncSnapshot<String> snapshot) {
                                if (!snapshot.hasData) {
                                  return const CircularProgressIndicator();
                                }
                                debugPrint(snapshot.data!);
                                return Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: CircleAvatar(
                                    radius: 38,
                                    backgroundColor: colors[userData['color']],
                                    child: CircleAvatar(
                                      radius: 37,
                                      backgroundImage: NetworkImage(
                                        snapshot.data!,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ),
                  Text(
                    userData['nombre'],
                    style: TiposBlue.bodyBold,
                  ),
                ],
              ),
            ],
          );
        });
  }
}
