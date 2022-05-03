import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:penalty_flat_app/Styles/colors.dart';
import 'package:penalty_flat_app/screens/display_paginas.dart';
import 'package:provider/provider.dart';

class CantidadConfirmacion extends StatelessWidget {
  final String userId;
  const CantidadConfirmacion({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;
    final idCasa = context.read<CasaID>();

    return StreamBuilder(
      stream: db.doc("sesion/$idCasa/users/$userId").snapshots(),
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

        final num totalUsuario = userData['dinero'];

        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Column(
                children: [
                  Text("¿${userData['nombre']} ha pagado su parte?", style: TiposBlue.bodyBold),
                  Text(
                    "${totalUsuario.toStringAsFixed(2)}€",
                    style: GoogleFonts.nunitoSans(
                      fontSize: MediaQuery.of(context).size.width / 5,
                      textStyle: TextStyle(color: PageColors.blue, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
