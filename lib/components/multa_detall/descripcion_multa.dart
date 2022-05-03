import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:penalty_flat_app/screens/display_paginas.dart';
import 'package:provider/provider.dart';
import '../../../Styles/colors.dart';
import '../../../models/user.dart';
import 'package:string_extensions/string_extensions.dart';

class DescripcionDetail extends StatelessWidget {
  final String idMulta;
  DescripcionDetail({
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

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              multaData['idMultado'] == user?.uid ? "¿Qué has hecho?" : "¿Qué ha hecho?",
              style: TiposBlue.subtitle,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: PageColors.blue.withOpacity(0.2),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${multaData['titulo']}".capitalize!,
                        style: TiposBlue.bodyBold,
                      ),
                      Text(
                        "${multaData['descripcion']}".capitalize!,
                        style: TiposBlue.body,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
