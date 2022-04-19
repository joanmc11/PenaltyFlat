import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:penalty_flat_app/Styles/colors.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
//import 'package:fl_chart/fl_chart.dart';
import 'package:pie_chart/pie_chart.dart';
import '../../../../models/user.dart';
import '../../screens/estadisticas_multas.dart';

class EstadisticasSimples extends StatelessWidget {
  final String sesionId;
  EstadisticasSimples({Key? key, required this.sesionId}) : super(key: key);

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

  get dataMap => null;

  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;
    final user = Provider.of<MyUser?>(context);
    

        return user == null
            ? Container()
            : StreamBuilder(
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

                  Map<String, double> sectionsChart = {};
                  final List<num> dineroMultas = [];
                  for (int i = 0; i < usersData.length; i++) {
                    dineroMultas.add(usersData[i]['dinero']);
                    sectionsChart[usersData[i]['nombre']] =
                        usersData[i]['dinero'].toDouble();
                  }
                  final num totalMultas = dineroMultas.sum;

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: Center(
                            child: PieChart(
                              dataMap: sectionsChart,
                              animationDuration:
                                  const Duration(milliseconds: 800),
                              chartLegendSpacing: 10,
                              chartRadius:
                                  MediaQuery.of(context).size.width / 3.1,
                              colorList: colors,
                              initialAngleInDegree: 0,
                              chartType: ChartType.ring,
                              emptyColor: PageColors.blue.withOpacity(0.3),
                              ringStrokeWidth: 10,
                              centerText: totalMultas.toStringAsFixed(2),
                              centerTextStyle: TiposBlue.title,
                              legendOptions: LegendOptions(
                                showLegendsInRow: false,
                                legendPosition: LegendPosition.left,
                                showLegends: true,
                                legendTextStyle: TiposBlue.body,
                              ),
                              chartValuesOptions: const ChartValuesOptions(
                                showChartValueBackground: false,
                                showChartValues: false,
                                showChartValuesInPercentage: false,
                                showChartValuesOutside: false,
                                decimalPlaces: 1,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: IconButton(
                                      onPressed: () async {
                                        await Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EstadisticaMultas(
                                                      sesionId: sesionId)),
                                        );
                                      },
                                      icon: Icon(
                                        Icons.arrow_forward,
                                        color: PageColors.blue,
                                      ))),
                            ))
                      ],
                    ),
                  );
                },
              );
      }
}
