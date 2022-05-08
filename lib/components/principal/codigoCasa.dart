// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:penalty_flat_app/Styles/colors.dart';
import 'package:penalty_flat_app/services/sesionProvider.dart';
import 'package:penalty_flat_app/shared/ver_codigo.dart';
import 'package:provider/provider.dart';

class CodigoCasa extends StatelessWidget {
  const CodigoCasa({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;
    final idCasa = Provider.of<SesionProvider?>(context)!.sesionCode;

    return StreamBuilder(
      stream: db.doc("sesion/$idCasa").snapshots(),
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
        final casaData = snapshot.data!.data()!;
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(casaData['casa'], style: TiposBlue.subtitle),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => VerCodigo(
                                casa: casaData['casa'],
                                codigo: casaData['codi'],
                              )),
                    );
                  },
                  style: TextButton.styleFrom(
                      primary: PageColors.blue,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          side: BorderSide(color: PageColors.blue.withOpacity(0.2))),
                      minimumSize: const Size(20, 20)),
                  child: Text(
                    "Ver código",
                    style: TextStyle(fontSize: 10, color: PageColors.blue.withOpacity(0.5)),
                  )),
            )
          ],
        );
      },
    );
  }
}
