import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../Styles/colors.dart';

class PrecioDetail extends StatelessWidget {
  final String sesionId;
  final String idMulta;
  PrecioDetail({
    Key? key,
    required this.sesionId,
    required this.idMulta,
  }) : super(key: key);
  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: db.doc("sesion/$sesionId/multas/$idMulta").snapshots(),
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
        snapshot.data?.data() != null
            ? multaData = snapshot.data!.data()!
            : multaData = {};

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Sale a Pagar",
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
