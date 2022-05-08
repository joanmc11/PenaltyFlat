import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:penalty_flat_app/services/sesionProvider.dart';
import 'package:provider/provider.dart';
import '../../../Styles/colors.dart';

class PrecioDetail extends StatelessWidget {
  final String idMulta;
  PrecioDetail({Key? key, required this.idMulta}) : super(key: key);
  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final idCasa = Provider.of<SesionProvider?>(context)!.sesionCode;
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
              "Precio a pagar",
              style: TiposBlue.subtitle,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "${multaData['precio']}€",
                style: TiposBlue.title,
              ),
            )
          ],
        );
      },
    );
  }
}
