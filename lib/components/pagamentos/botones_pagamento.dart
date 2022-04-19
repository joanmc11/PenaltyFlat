import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:penalty_flat_app/Styles/colors.dart';
import 'package:penalty_flat_app/models/user.dart';
import 'package:provider/provider.dart';

class BotonesPagamento extends StatelessWidget {
  final String sesionId;
  BotonesPagamento({Key? key, required this.sesionId}) : super(key: key);

  final DateTime dateToday = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
    DateTime.now().hour,
    DateTime.now().minute,
    DateTime.now().second,
  );

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

        return StreamBuilder(
          stream: db
              .collection("sesion/$sesionId/users")
              .orderBy("color", descending: false)
              .snapshots(),
          builder: (
            BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
          ) {
            if (snapshot.hasError) {
              return ErrorWidget(snapshot.error.toString());
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final usersData = snapshot.data!.docs;

            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
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
                              "Atrás",
                              style: TextStyle(color: PageColors.blue),
                            ),
                            onPressed: () async {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: singleUserdata['pendiente'] == false
                                    ? singleUserdata['dinero']==0? Colors.grey: PageColors.yellow
                                    : Colors.grey),
                            child: Text(
                              singleUserdata['pendiente'] == false
                                  ? "Pagar"
                                  : "Pendiente",
                              style: TextStyle(color: PageColors.blue),
                            ),
                            onPressed: () async {
                              if (singleUserdata['dinero'] == 0) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    duration: Duration(milliseconds: 800),
                                    content: Text("Nada que pagar"),
                                  ),
                                );
                              } else if (singleUserdata['pendiente'] == false) {
                                if (singleUserdata['pendiente'] == false) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      duration: Duration(milliseconds: 800),
                                      content: Text(
                                          "Espera a que tus compañeros confirmen el pago"),
                                    ),
                                  );
                                  for (int i = 0; i < usersData.length; i++) {
                                    if (usersData[i]['id'] != user.uid) {
                                      await db
                                          .collection(
                                              'sesion/$sesionId/notificaciones')
                                          .add({
                                        'nomPagador': singleUserdata['nombre'],
                                        'idPagador': user.uid,
                                        'idUsuario': usersData[i]['id'],
                                        'tipo': "pago",
                                        'fecha': dateToday,
                                        'visto': false,
                                      });
                                      await db
                                          .doc(
                                              'sesion/$sesionId/users/${user.uid}')
                                          .update({
                                        'contador': 1,
                                        'pendiente': true
                                      });
                                    }
                                  }
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    duration: Duration(milliseconds: 800),
                                    content: Text(
                                        "Espera a que tus compañeros confirmen el pago"),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
