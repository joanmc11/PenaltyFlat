import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:penalty_flat_app/Styles/colors.dart';
import 'package:penalty_flat_app/models/user.dart';
import 'package:provider/provider.dart';

class DineroPagamento extends StatelessWidget {
  final String sesionId;
  const DineroPagamento({Key? key, required this.sesionId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;
    final user = Provider.of<MyUser?>(context);
    return StreamBuilder(
      stream: db.doc("sesion/$sesionId/users/${user!.uid}").snapshots(),
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
        final singleUserdata = snapshot.data!.data()!;

        final num totalUsuario = singleUserdata['dinero'] ?? 0;

        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Column(
                children: [
                  Text("Tienes que pagar: ", style: TiposBlue.bodyBold),
                  Text(
                    "${totalUsuario.toStringAsFixed(2)}€",
                    style: GoogleFonts.nunitoSans(
                      fontSize: MediaQuery.of(context).size.width / 5,
                      textStyle: TextStyle(
                          color: PageColors.blue, fontWeight: FontWeight.w600),
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
