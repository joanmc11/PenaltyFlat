import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:penalty_flat_app/Styles/colors.dart';
import 'package:penalty_flat_app/models/user.dart';
import 'package:penalty_flat_app/services/sesionProvider.dart';
import 'package:penalty_flat_app/shared/loading.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class OwnStats extends StatelessWidget {
  OwnStats({Key? key}) : super(key: key);
  final List<Color> colors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.indigo,
    Colors.pinkAccent,
    Colors.amber,
    Colors.deepOrange,
    Colors.brown,
    Colors.cyan,
    Colors.yellow,
  ];
  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;
    final user = Provider.of<MyUser?>(context);
    final idCasa = Provider.of<SesionProvider?>(context)!.sesionCode;
    return user == null
        ? const Loading()
        : StreamBuilder(
            stream: db.doc("sesion/$idCasa/users/${user.uid}").snapshots(),
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
              final multasUsuario = snapshot.data!.data()!;

              final num totalUsuario = multasUsuario['dinero'] ?? 0;

              return StreamBuilder(
                stream: db
                    .collection("sesion/$idCasa/multas")
                    .orderBy("fecha", descending: false)
                    .where('aceptada', isEqualTo: true)
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
                  final multasData = snapshot.data!.docs;

                  return StreamBuilder(
                    stream: db
                        .collection("sesion/$idCasa/users")
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

                      Map<String, double> sectionsChart = {};
                      final List<num> dineroMultas = [];
                      for (int i = 0; i < usersData.length; i++) {
                        dineroMultas.add(usersData[i]['dinero']);
                        sectionsChart[usersData[i]['nombre']] = usersData[i]['dinero'].toDouble();
                      }
                      final num totalMultas = dineroMultas.sum;
                      String porcentajeMulta =
                          ((totalUsuario / totalMultas) * 100).toStringAsFixed(1);

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Row(
                                    children: [
                                      Text("Dinero acumulado: ", style: TiposBlue.body),
                                      Text("${totalUsuario.toStringAsFixed(2)}€",
                                          style: TiposBlue.subtitle)
                                    ],
                                  ),
                                ),
                                LinearPercentIndicator(
                                  width: MediaQuery.of(context).size.width / 1.15,
                                  lineHeight: 15,
                                  animation: true,
                                  animationDuration: 1200,
                                  center: Text(totalUsuario == 0 ? "0%" : "$porcentajeMulta%",
                                      style: TextStyle(
                                        color: PageColors.blue,
                                      )),
                                  percent: totalUsuario == 0 ? 0 : totalUsuario / totalMultas,
                                  progressColor: PageColors.yellow,
                                ),
                              ],
                            ),
                          ),
                          StreamBuilder(
                              stream: db
                                  .collection("sesion/$idCasa/multas")
                                  .where('idMultado', isEqualTo: user.uid)
                                  .where('aceptada', isEqualTo: true)
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
                                final userMultas = snapshot.data!.docs;

                                return Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8.0),
                                        child: Row(
                                          children: [
                                            Text("Multas recibidas: ", style: TiposBlue.body),
                                            Text("${userMultas.length}", style: TiposBlue.subtitle)
                                          ],
                                        ),
                                      ),
                                      LinearPercentIndicator(
                                        width: MediaQuery.of(context).size.width / 1.15,
                                        lineHeight: 15,
                                        animation: true,
                                        animationDuration: 1200,
                                        center: Text(
                                            multasData.isEmpty
                                                ? "0%"
                                                : ((userMultas.length / multasData.length) * 100)
                                                        .toStringAsFixed(0) +
                                                    "%",
                                            style: TextStyle(
                                              color: PageColors.blue,
                                            )),
                                        percent: userMultas.isEmpty
                                            ? 0
                                            : userMultas.length / multasData.length,
                                        progressColor: PageColors.yellow,
                                      ),
                                    ],
                                  ),
                                );
                              }),
                          StreamBuilder(
                              stream: db
                                  .collection("sesion/$idCasa/multas")
                                  .where('autorId', isEqualTo: user.uid)
                                  .where('aceptada', isEqualTo: true)
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
                                final userMultasEnv = snapshot.data!.docs;

                                return Padding(
                                  padding: const EdgeInsets.only(left: 16.0, bottom: 16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8.0),
                                        child: Row(
                                          children: [
                                            Text("Multas enviadas: ", style: TiposBlue.body),
                                            Text("${userMultasEnv.length}",
                                                style: TiposBlue.subtitle)
                                          ],
                                        ),
                                      ),
                                      LinearPercentIndicator(
                                        width: MediaQuery.of(context).size.width / 1.15,
                                        lineHeight: 15,
                                        animation: true,
                                        animationDuration: 1200,
                                        center: Text(
                                            multasData.isEmpty
                                                ? "0%"
                                                : ((userMultasEnv.length / multasData.length) * 100)
                                                        .toStringAsFixed(0) +
                                                    "%",
                                            style: TextStyle(
                                              color: PageColors.blue,
                                            )),
                                        percent: userMultasEnv.isEmpty
                                            ? 0
                                            : userMultasEnv.length / multasData.length,
                                        progressColor: PageColors.yellow,
                                      ),
                                    ],
                                  ),
                                );
                              }),
                        ],
                      );
                    },
                  );
                },
              );
            });
  }
}
