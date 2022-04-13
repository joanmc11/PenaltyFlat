import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:icon_badge/icon_badge.dart';
import 'package:penalty_flat_app/Styles/colors.dart';
import 'package:penalty_flat_app/models/user.dart';
import 'package:penalty_flat_app/screens/multar/usuario_multa.dart';
import 'package:penalty_flat_app/screens/penaltyflat/principal.dart';
import 'package:penalty_flat_app/screens/penaltyflat/profile/profile.dart';
import 'package:penalty_flat_app/shared/loading.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import 'package:pie_chart/pie_chart.dart';
import '../../bottomBar/widgets/tab_item.dart';
import '../notifications/notifications.dart';

class EstadisticaMultas extends StatelessWidget {
  final String sesionId;
  EstadisticaMultas({Key? key, required this.sesionId}) : super(key: key);
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
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: PageColors.blue,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/LogoCabecera.png',
                height: 70,
                width: 70,
              ),
              Text('PENALTY FLAT',
                  style: TextStyle(
                      fontFamily: 'BasierCircle',
                      fontSize: 18,
                      color: PageColors.blue,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        actions: <Widget>[
          StreamBuilder(
              stream: db
                  .collection("sesion/$sesionId/notificaciones")
                  .where('idUsuario', isEqualTo: user?.uid)
                  .where('visto', isEqualTo: false)
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
                final notifyData = snapshot.data!.docs;

                return IconBadge(
                  icon: Icon(
                    Icons.notifications_none_outlined,
                    color: PageColors.blue,
                    size: 35,
                  ),
                  itemCount: notifyData.length,
                  badgeColor: Colors.red,
                  itemColor: Colors.white,
                  hideZero: true,
                  top: 11,
                  right: 9,
                  onTap: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) =>
                              Notificaciones(sesionId: sesionId)),
                    );
                  },
                );
              }),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.notifications_none_outlined,
              color: PageColors.blue,
            ),
            padding: const EdgeInsets.only(right: 30),
          )
        ],
      ),
      body: user == null
          ? const Loading()
          : StreamBuilder(
              stream: db.doc("sesion/$sesionId/users/${user.uid}").snapshots(),
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
                      .collection("sesion/$sesionId/multas")
                      .orderBy("fecha", descending: false)
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
                          .collection("sesion/$sesionId/users")
                          .orderBy("color", descending: false)
                          .snapshots(),
                      builder: (
                        BuildContext context,
                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                            snapshot,
                      ) {
                        if (snapshot.hasError) {
                          return ErrorWidget(snapshot.error.toString());
                        }
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
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
                        String porcentajeMulta =
                            ((totalUsuario / totalMultas) * 100)
                                .toStringAsFixed(1);

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Estadisticas generales:",
                              style: TiposBlue.subtitle,
                            ),
                            Center(
                              child: PieChart(
                                dataMap: sectionsChart,
                                animationDuration:
                                    const Duration(milliseconds: 800),
                                chartLegendSpacing: 32,
                                chartRadius:
                                    MediaQuery.of(context).size.width / 3.1,
                                colorList: colors,
                                initialAngleInDegree: -90,
                                chartType: ChartType.ring,
                                emptyColor: PageColors.blue.withOpacity(0.3),
                                ringStrokeWidth: 10,
                                centerText:
                                    "${totalMultas.toStringAsFixed(2)}€",
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
                                    chartValueStyle: TextStyle(
                                        color: PageColors.blue, fontSize: 12),
                                    chartValueBackgroundColor:
                                        PageColors.yellow.withOpacity(0.8)),
                              ),
                            ),
                            Text(
                              "Estadisticas propias:",
                              style: TiposBlue.subtitle,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Row(
                                      children: [
                                        Text("Dinero acumulado: ",
                                            style: TiposBlue.body),
                                        Text(
                                            "${totalUsuario.toStringAsFixed(2)}€",
                                            style: TiposBlue.subtitle)
                                      ],
                                    ),
                                  ),
                                  LinearPercentIndicator(
                                    width: MediaQuery.of(context).size.width /
                                        1.15,
                                    lineHeight: 15,
                                    animation: true,
                                    animationDuration: 1200,
                                    center: Text(
                                        totalUsuario == 0
                                            ? "0%"
                                            : "$porcentajeMulta%",
                                        style: TextStyle(
                                          color: PageColors.blue,
                                        )),
                                    percent: totalUsuario == 0
                                        ? 0
                                        : totalUsuario / totalMultas,
                                    progressColor: PageColors.yellow,
                                  ),
                                ],
                              ),
                            ),
                            StreamBuilder(
                                stream: db
                                    .collection("sesion/$sesionId/multas")
                                    .where('idMultado', isEqualTo: user.uid)
                                    .snapshots(),
                                builder: (
                                  BuildContext context,
                                  AsyncSnapshot<
                                          QuerySnapshot<Map<String, dynamic>>>
                                      snapshot,
                                ) {
                                  if (snapshot.hasError) {
                                    return ErrorWidget(
                                        snapshot.error.toString());
                                  }
                                  if (!snapshot.hasData) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }
                                  final userMultas = snapshot.data!.docs;

                                  return Padding(
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Row(
                                            children: [
                                              Text("Multas recibidas: ",
                                                  style: TiposBlue.body),
                                              Text("${userMultas.length}",
                                                  style: TiposBlue.subtitle)
                                            ],
                                          ),
                                        ),
                                        LinearPercentIndicator(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              1.15,
                                          lineHeight: 15,
                                          animation: true,
                                          animationDuration: 1200,
                                          center: Text(
                                              multasData.isEmpty
                                                  ? "0%"
                                                  : ((userMultas.length /
                                                                  multasData
                                                                      .length) *
                                                              100)
                                                          .toStringAsFixed(0) +
                                                      "%",
                                              style: TextStyle(
                                                color: PageColors.blue,
                                              )),
                                          percent: userMultas.isEmpty
                                              ? 0
                                              : userMultas.length /
                                                  multasData.length,
                                          progressColor: PageColors.yellow,
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                            StreamBuilder(
                                stream: db
                                    .collection("sesion/$sesionId/multas")
                                    .where('autorId', isEqualTo: user.uid)
                                    .snapshots(),
                                builder: (
                                  BuildContext context,
                                  AsyncSnapshot<
                                          QuerySnapshot<Map<String, dynamic>>>
                                      snapshot,
                                ) {
                                  if (snapshot.hasError) {
                                    return ErrorWidget(
                                        snapshot.error.toString());
                                  }
                                  if (!snapshot.hasData) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }
                                  final userMultasEnv = snapshot.data!.docs;

                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16.0, bottom: 16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Row(
                                            children: [
                                              Text("Multas enviadas: ",
                                                  style: TiposBlue.body),
                                              Text("${userMultasEnv.length}",
                                                  style: TiposBlue.subtitle)
                                            ],
                                          ),
                                        ),
                                        LinearPercentIndicator(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              1.15,
                                          lineHeight: 15,
                                          animation: true,
                                          animationDuration: 1200,
                                          center: Text(
                                              multasData.isEmpty
                                                  ? "0%"
                                                  : ((userMultasEnv.length /
                                                                  multasData
                                                                      .length) *
                                                              100)
                                                          .toStringAsFixed(0) +
                                                      "%",
                                              style: TextStyle(
                                                color: PageColors.blue,
                                              )),
                                          percent: userMultasEnv.isEmpty
                                              ? 0
                                              : userMultasEnv.length /
                                                  multasData.length,
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
              }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => PersonaMultada(sesionId: sesionId)),
          );
        },
        child: Icon(
          Icons.gavel,
          color: PageColors.yellow,
        ),
        backgroundColor: PageColors.blue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomTab(context),
    );
  }

  _buildBottomTab(context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20.0),
        topRight: Radius.circular(20.0),
      ),
      child: BottomAppBar(
        color: PageColors.blue,
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
                onTap: () async {
                  await Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) =>
                            PrincipalScreen(sesionId: sesionId)),
                  );
                },
                child: const TabItem(icon: Icons.home)),
            GestureDetector(
                onTap: () async {
                  await Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => ProfilePage(sesionId: sesionId)),
                  );
                },
                child: const TabItem(icon: Icons.account_circle))
          ],
        ),
      ),
    );
  }
}
