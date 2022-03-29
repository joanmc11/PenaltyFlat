import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:icon_badge/icon_badge.dart';
import 'package:penalty_flat_app/Styles/colors.dart';
import 'package:penalty_flat_app/screens/multar/usuario_multa.dart';
import 'package:penalty_flat_app/screens/penaltyflat/codigo_multas.dart';
import 'package:penalty_flat_app/screens/penaltyflat/estadisticas/estadisticas_multas.dart';
import 'package:penalty_flat_app/screens/penaltyflat/llista_multas.dart';
import 'package:penalty_flat_app/screens/penaltyflat/notifications/notifications.dart';
import 'package:penalty_flat_app/screens/penaltyflat/profile/profile.dart';
import 'package:penalty_flat_app/shared/verCodigo.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

import '../../models/user.dart';
import '../bottomBar/widgets/tab_item.dart';

import 'llistaMultes/multaDetall.dart';
//import 'package:fl_chart/fl_chart.dart';
import 'package:pie_chart/pie_chart.dart';

class PrincipalScreen extends StatelessWidget {
  final String sesionId;
  PrincipalScreen({Key? key, required this.sesionId}) : super(key: key);

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
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 75,
        backgroundColor: Colors.white,
        leading: Container(),
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
        ],
      ),
      body: StreamBuilder(
        stream: db
            .collection("sesion/$sesionId/multas")
            .where('aceptada', isEqualTo: true)
            .orderBy('fecha', descending: true)
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
          final multasSesion = snapshot.data!.docs;

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

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
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
                                    emptyColor:
                                        PageColors.blue.withOpacity(0.3),
                                    ringStrokeWidth: 10,
                                    centerText: totalMultas.toStringAsFixed(2),
                                    centerTextStyle: TiposBlue.title,
                                    legendOptions: LegendOptions(
                                      showLegendsInRow: false,
                                      legendPosition: LegendPosition.left,
                                      showLegends: true,
                                      legendTextStyle: TiposBlue.body,
                                    ),
                                    chartValuesOptions:
                                        const ChartValuesOptions(
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
                                                            sesionId:
                                                                sesionId)),
                                              );
                                            },
                                            icon: Icon(
                                              Icons.arrow_forward,
                                              color: PageColors.blue,
                                            ))),
                                  ))
                            ],
                          ),
                        ),
                        StreamBuilder(
                          stream: db.doc("sesion/$sesionId").snapshots(),
                          builder: (
                            BuildContext context,
                            AsyncSnapshot<
                                    DocumentSnapshot<Map<String, dynamic>>>
                                snapshot,
                          ) {
                            if (snapshot.hasError) {
                              return ErrorWidget(snapshot.error.toString());
                            }
                            if (!snapshot.hasData) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            final casaData = snapshot.data!.data()!;
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(casaData['casa'],
                                        style: TiposBlue.subtitle),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 16.0),
                                      child: TextButton(
                                          onPressed: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      VerCodigo(
                                                        casa: casaData['casa'],
                                                        codigo:
                                                            casaData['codi'],
                                                      )),
                                            );
                                          },
                                          style: TextButton.styleFrom(
                                              primary: PageColors.blue,
                                              backgroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(10)),
                                                  side: BorderSide(
                                                      color: PageColors.blue
                                                          .withOpacity(0.2))),
                                              minimumSize: const Size(20, 20)),
                                          child: Text(
                                            "Ver código",
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: PageColors.blue
                                                    .withOpacity(0.5)),
                                          )),
                                    )
                                  ],
                                )
                              ],
                            );
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 20.0, top: 0),
                          child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 2,
                                    offset: const Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    ListView.builder(
                                      itemExtent: 55.0,
                                      shrinkWrap: true,
                                      itemCount: multasSesion.isEmpty
                                          ? 1
                                          : multasSesion.length > 3
                                              ? 3
                                              : multasSesion.length,
                                      itemBuilder: (context, index) {
                                        return multasSesion.isEmpty
                                            ? ListTile(
                                                title: Center(
                                                    child: Text(
                                                  "Todavía no hay multas",
                                                  style: TiposBlue.bodyBold,
                                                )),
                                                subtitle: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 32.0),
                                                  child: Center(
                                                      child: Text(
                                                    "¿Serás tu el primero?",
                                                    style: TiposBlue.body,
                                                  )),
                                                ),
                                              )
                                            : ListTile(
                                                leading: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    IconButton(
                                                        onPressed: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        MultaDetall(
                                                                  notifyId:
                                                                      "sinNotificacion",
                                                                  sesionId:
                                                                      sesionId,
                                                                  idMulta:
                                                                      multasSesion[
                                                                              index]
                                                                          .id,
                                                                  idMultado: multasSesion[
                                                                          index]
                                                                      [
                                                                      'idMultado'],
                                                                ),
                                                              ));
                                                        },
                                                        icon: Icon(
                                                            Icons.open_in_full,
                                                            color: PageColors
                                                                .blue)),
                                                  ],
                                                ),
                                                title: Text(
                                                    multasSesion[index]
                                                        ['nomMultado'],
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: PageColors.blue,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                subtitle: Text(
                                                  multasSesion[index]['titulo'],
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: PageColors.blue),
                                                ),
                                                trailing: Text(
                                                    "${multasSesion[index]['precio']}€"),
                                              );
                                      },
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 20, top: 8, bottom: 8),
                                      child: Align(
                                        alignment: Alignment.bottomRight,
                                        child: GestureDetector(
                                            onTap: () async {
                                              await Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        PantallaMultas(
                                                            sesionId:
                                                                sesionId)),
                                              );
                                            },
                                            child: Text(
                                              multasSesion.length > 3
                                                  ? "+ ver mas"
                                                  : "",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                color: PageColors.blue,
                                              ),
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 30.0, top: 10),
                          child: ElevatedButton(
                            style: TextButton.styleFrom(
                                primary: PageColors.blue,
                                backgroundColor: PageColors.yellow,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                minimumSize: const Size(200, 50)),
                            onPressed: () async {
                              await Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CodigoMultas(sesionId: sesionId)),
                              );
                            },
                            child: const Text('Código de Multas',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20)),
                          ),
                        ),
                      ],
                    );
                  },
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
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
                onTap: () {}, child: const TabItem(icon: Icons.home)),
            GestureDetector(
                onTap: () async {
                  Navigator.of(context).push(
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
