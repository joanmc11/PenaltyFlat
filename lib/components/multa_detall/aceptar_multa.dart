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
                ? Padding(
                  padding: const EdgeInsets.only(bottom:16.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10.0, left: 16, ),
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
                                    Navigator.pop(context);
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0, right: 16, ),
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
                    ),
                )
                : multaData.pagado
                    ? Container(
                      height: 60,
                      color: PageColors.yellow.withOpacity(0.25),
                      child:  Center(
                          child: Text(
                            "Multa pagada",
                            style: TextStyle(
                                color: PageColors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                    )
                    : Container(
                      color: Colors.grey.withOpacity(0.2),
                      height: 60,
                      child: Center(
                          child: Text(
                            "Multa por pagar",
                            style: TextStyle(
                                color: PageColors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                    );
        }
      },
    );
  }
}
