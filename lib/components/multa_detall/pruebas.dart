import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:penalty_flat_app/screens/display_paginas.dart';
import 'package:provider/provider.dart';
import '../../../Styles/colors.dart';

class PruebasDetail extends StatelessWidget {
  final String idMulta;
  PruebasDetail({
    Key? key,
    required this.idMulta,
  }) : super(key: key);
  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final storage = FirebaseStorage.instance;
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

        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Pruebas",
                  style: TiposBlue.subtitle,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: multaData['imagen'] == ""
                      ? Text(
                          "No se dispone de pruebas",
                          style: TiposBlue.body,
                        )
                      : FutureBuilder(
                          future:
                              storage.ref("/images/multas/${multaData['imagen']}").getDownloadURL(),
                          builder: (context, AsyncSnapshot<String> snapshot) {
                            if (!snapshot.hasData) {
                              return const CircularProgressIndicator();
                            }
                            debugPrint(snapshot.data!);
                            return SizedBox(
                              height: 220,
                              width: 450,
                              child: Image.network(snapshot.data!, fit: BoxFit.scaleDown),
                            );
                          },
                        ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
