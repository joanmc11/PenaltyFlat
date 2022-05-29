import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:penalty_flat_app/models/multas.dart';
import 'package:penalty_flat_app/models/usersInside.dart';
import 'package:penalty_flat_app/services/database.dart';
import 'package:penalty_flat_app/services/sesionProvider.dart';
import 'package:provider/provider.dart';
import '../../../Styles/colors.dart';
import '../../../models/user.dart';

class AceptarMulta extends StatelessWidget {
  final Multa multaData;
  final String notifyId;
  AceptarMulta({
    Key? key,
    required this.multaData,
    required this.notifyId,
  }) : super(key: key);
  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    final idCasa = Provider.of<SesionProvider?>(context)!.sesionCode;

    return StreamBuilder(
      stream: singleUserData(idCasa, user!.uid),
      builder: (
        BuildContext context,
        AsyncSnapshot<InsideUser> snapshot,
      ) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.done:
            throw "Stream is none or done!!!";
          case ConnectionState.waiting:
            return const Center(
              child: CircularProgressIndicator(),
            );
          case ConnectionState.active:
            final userData = snapshot.data!;

            return !multaData.aceptada
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: PageColors.white),
                            child: Text(
                              "Rechazar",
                              style: TextStyle(color: PageColors.blue),
                            ),
                            onPressed: () async {
                              DatabaseService(uid: user.uid).rejectMulta(idCasa,
                                  userData, multaData, notifyId, context);
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: PageColors.yellow),
                            child: Text(
                              "Aceptar",
                              style: TextStyle(color: PageColors.blue),
                            ),
                            onPressed: () async {
                              DatabaseService(uid: user.uid).acceptMulta(
                                idCasa,
                                multaData,
                                userData,
                                context,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  )
                : multaData.pagado
                    ? const Center(
                        child: Text(
                          "Multa pagada",
                          style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      )
                    : const Center(
                        child: Text(
                          "Multa por pagar",
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      );
        }
      },
    );
  }
}
