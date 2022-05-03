import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:penalty_flat_app/screens/display_paginas.dart';
import 'package:provider/provider.dart';
import '../../../Styles/colors.dart';
import '../../../models/user.dart';

class TituloMulta extends StatelessWidget {
  final String idMulta;
  TituloMulta({
    Key? key,
    required this.idMulta,
  }) : super(key: key);
  final db = FirebaseFirestore.instance;

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

        return Center(
          child: multaData['idMultado'] == user?.uid
              ? Text("¡Te han pillado!", style: TiposBlue.title)
              : Text(
                  "¡Han pillado a ${multaData['nomMultado']}!",
                  style: TiposBlue.title,
                ),
        );
      },
    );
  }
}
