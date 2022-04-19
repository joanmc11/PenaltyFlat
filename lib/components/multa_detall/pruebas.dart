import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../Styles/colors.dart';

class PruebasDetail extends StatelessWidget {
  final String sesionId;
  final String idMulta;
  PruebasDetail({
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
                      : const Text("Imagen aquí"),
                ),
              ],
            ),
          ],
        );
                },
              );
     
  }
}
