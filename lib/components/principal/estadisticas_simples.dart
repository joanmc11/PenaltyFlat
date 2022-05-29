import 'package:flutter/material.dart';
import 'package:penalty_flat_app/Styles/colors.dart';
import 'package:penalty_flat_app/models/colors_model.dart';
import 'package:penalty_flat_app/models/usersInside.dart';
import 'package:penalty_flat_app/services/functions.dart';
import 'package:penalty_flat_app/services/sesionProvider.dart';

import 'package:provider/provider.dart';
//import 'package:fl_chart/fl_chart.dart';
import 'package:pie_chart/pie_chart.dart';
import '../../../../models/user.dart';
import '../../screens/estadisticas_multas.dart';

class EstadisticasSimples extends StatelessWidget {
  const EstadisticasSimples({Key? key}) : super(key: key);

  get dataMap => null;

  @override
  Widget build(BuildContext context) {
    final colors = UserColors().colors;
    final user = Provider.of<MyUser?>(context);
    final idCasa = Provider.of<SesionProvider?>(context)!.sesionCode;

    return user == null
        ? Container()
        : StreamBuilder(
            stream: simpleUsersSnapshot(idCasa),
            builder: (
              BuildContext context,
              AsyncSnapshot<List<InsideUser>> snapshot,
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
                  final usersData = snapshot.data!;

                  final Map<String, double> sectionsChart =
                      FunctionService().sectionChart(usersData);

                  final num totalMultas =
                      FunctionService().dineroMultas(usersData);

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
                                              const EstadisticaMultas(),
                                        ),
                                      );
                                    },
                                    icon: Icon(
                                      Icons.arrow_forward,
                                      color: PageColors.blue,
                                    ))),
                          ),
                        )
                      ],
                    ),
                  );
              }
            },
          );
  }
}
