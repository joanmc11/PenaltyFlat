import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:penalty_flat_app/Styles/colors.dart';
import 'package:penalty_flat_app/models/user.dart';
import 'package:penalty_flat_app/services/sesionProvider.dart';
import 'package:penalty_flat_app/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import 'package:pie_chart/pie_chart.dart';

/*Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Estadisticas generales:",
                              style: TiposBlue.subtitle,
                            ),*/

class GeneralStats extends StatelessWidget {
  GeneralStats({Key? key}) : super(key: key);
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

              return Center(
                child: PieChart(
                  dataMap: sectionsChart,
                  animationDuration: const Duration(milliseconds: 800),
                  chartLegendSpacing: 32,
                  chartRadius: MediaQuery.of(context).size.width / 3.1,
                  colorList: colors,
                  initialAngleInDegree: -90,
                  chartType: ChartType.ring,
                  emptyColor: PageColors.blue.withOpacity(0.3),
                  ringStrokeWidth: 10,
                  centerText: "${totalMultas.toStringAsFixed(2)}€",
                  centerTextStyle: TiposBlue.title,
                  legendOptions: LegendOptions(
                    showLegendsInRow: false,
                    legendPosition: LegendPosition.right,
                    showLegends: true,
                    legendTextStyle: TiposBlue.body,
                  ),
                  chartValuesOptions: ChartValuesOptions(
                      showChartValueBackground: true,
                      showChartValues: true,
                      showChartValuesInPercentage: false,
                      showChartValuesOutside: true,
                      decimalPlaces: 2,
                      chartValueStyle: TextStyle(color: PageColors.blue, fontSize: 12),
                      chartValueBackgroundColor: PageColors.yellow.withOpacity(0.8)),
                ),
              );
            },
          );
  }
}
