import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:penalty_flat_app/Styles/colors.dart';
import 'package:penalty_flat_app/models/user.dart';
import 'package:penalty_flat_app/screens/display_paginas.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class CirculoPagamento extends StatelessWidget {
  const CirculoPagamento({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;
    final user = Provider.of<MyUser?>(context);
    final idCasa = context.read<CasaID>();
    return StreamBuilder(
      stream: db.doc("sesion/$idCasa/users/${user!.uid}").snapshots(),
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

        return StreamBuilder(
          stream:
              db.collection("sesion/$idCasa/users").orderBy("color", descending: false).snapshots(),
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
            String porcentajeMulta = ((totalUsuario / totalMultas) * 100).toStringAsFixed(1);

            return CircularPercentIndicator(
              radius: MediaQuery.of(context).size.width / 6,
              animation: true,
              animationDuration: 1200,
              center:
                  Text(totalUsuario == 0 ? "0%" : "$porcentajeMulta%", style: TiposBlue.subtitle),
              percent: totalUsuario == 0 ? 0 : totalUsuario / totalMultas,
              progressColor: PageColors.yellow,
              lineWidth: MediaQuery.of(context).size.width / 45,
            );
          },
        );
      },
    );
  }
}
