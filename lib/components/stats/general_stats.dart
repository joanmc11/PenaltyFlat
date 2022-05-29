
import 'package:flutter/material.dart';
import 'package:penalty_flat_app/Styles/colors.dart';
import 'package:penalty_flat_app/models/colors_model.dart';
import 'package:penalty_flat_app/models/user.dart';
import 'package:penalty_flat_app/models/usersInside.dart';
import 'package:penalty_flat_app/services/functions.dart';
import 'package:penalty_flat_app/services/sesionProvider.dart';
import 'package:penalty_flat_app/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:pie_chart/pie_chart.dart';



class GeneralStats extends StatelessWidget {
  const GeneralStats({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final colors = UserColors().colors;
    final user = Provider.of<MyUser?>(context);
    final idCasa = Provider.of<SesionProvider?>(context)!.sesionCode;
    return user == null
        ? const Loading()
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
                          chartValueStyle:
                              TextStyle(color: PageColors.blue, fontSize: 12),
                          chartValueBackgroundColor:
                              PageColors.yellow.withOpacity(0.8)),
                    ),
                  );
              }
            },
          );
  }
}
