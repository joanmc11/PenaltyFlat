import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:penalty_flat_app/Styles/colors.dart';
import 'package:penalty_flat_app/screens/penaltyflat/llistaMultes/calendari_multes.dart';
import 'package:penalty_flat_app/screens/penaltyflat/llistaMultes/multa_detall.dart';
import 'package:provider/provider.dart';
import '../../models/user.dart';

class PantallaMultas extends StatefulWidget {
  final String sesionId;

  const PantallaMultas({
    Key? key,
    required this.sesionId,
  }) : super(key: key);

  @override
  _PantallaMultasState createState() => _PantallaMultasState();
}

class _PantallaMultasState extends State<PantallaMultas> {
  String selectedMonth = "Todas";
  int monthValue = 0;
  int yearValue = 0;
  bool mount = true;
  bool selected = true;
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;
    final user = Provider.of<MyUser?>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: PageColors.blue,
          onPressed: () async {
            Navigator.pop(context);
          },
        ),
        toolbarHeight: 70,
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            'Penalty Flat',
            style: TextStyle(color: PageColors.blue),
          ),
        ),
        actions: <Widget>[
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text("Multas de: ", style: TiposBlue.title),
          ),
          StreamBuilder(
              stream:
                  db.collection("sesion/${widget.sesionId}/multas").snapshots(),
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
                List<String>? monthsYearsStrings = ["Todas"];
                List<int>? mValues = [0];
                List<int> yValues = [0];
                for (int i = 0; i < multasData.length; i++) {
                  DateTime date = DateTime.fromMicrosecondsSinceEpoch(
                      multasData[i]['fecha'].microsecondsSinceEpoch);

                  String dateString =
                      DateFormat("MMMM yyy", "es_ES").format(date);
                  int year = int.parse(DateFormat('yyyy').format(date));
                  int month = int.parse(DateFormat('MM').format(date));

                  monthsYearsStrings.contains(dateString)
                      ? null
                      : monthsYearsStrings.add(dateString);

                  if (!mValues.contains(month) || !yValues.contains(year)) {
                    yValues.add(year);
                    mValues.add(month);
                  }
                }

                return DropdownButton(
                  hint: const Text("Selecciona"),
                  dropdownColor: PageColors.white,
                  borderRadius: BorderRadius.circular(20),
                  value: selectedMonth,
                  items: monthsYearsStrings.map((valuesItem) {
                    int index = monthsYearsStrings.indexOf(valuesItem);

                    return DropdownMenuItem(
                      onTap: () {
                        setState(() {
                          currentIndex = index;
                          mount = false;
                        });
                      },
                      value: valuesItem,
                      child: Text(valuesItem),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      selectedMonth = value!;
                      yearValue = yValues[currentIndex];
                      monthValue = mValues[currentIndex];
                    });
                  },
                );
              }),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0, top: 4.0),
            child: IconButton(
                icon: Icon(Icons.calendar_month, color: PageColors.blue),
                onPressed: () async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Calendario(
                          sesionId: widget.sesionId,
                        ),
                      ));
                },
                iconSize: 40),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selected = true;
                    });
                  },
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 50),
                      child: Text(
                        "Todos",
                        style: TextStyle(
                            color: PageColors.yellow,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: (selected ? PageColors.blue : Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selected = false;
                    });
                  },
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 50),
                      child: Text(
                        "Propio",
                        style: TextStyle(
                            color: PageColors.yellow,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: (!selected ? PageColors.blue : Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          StreamBuilder(
              stream: selected
                  ? db
                      .collection("sesion/${widget.sesionId}/multas")
                      .where('aceptada', isEqualTo: true)
                      .where('fecha',
                          isGreaterThanOrEqualTo: DateTime(
                              selectedMonth == "Todas" ? 2020 : yearValue,
                              monthValue,
                              01))
                      .where('fecha',
                          isLessThan: DateTime(
                              selectedMonth == "Todas" ? 2160 : yearValue,
                              monthValue + 1,
                              01))
                      .orderBy('fecha', descending: true)
                      .snapshots()
                  : db
                      .collection("sesion/${widget.sesionId}/multas")
                      .where('aceptada', isEqualTo: true)
                      .where('idMultado', isEqualTo: user!.uid)
                      .where('fecha',
                          isGreaterThanOrEqualTo: DateTime(
                              selectedMonth == "Todas" ? 2020 : yearValue,
                              monthValue,
                              01))
                      .where('fecha',
                          isLessThan: DateTime(
                              selectedMonth == "Todas" ? 2160 : yearValue,
                              monthValue + 1,
                              01))
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
                return Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 20.0),
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemExtent: 55.0,
                      itemCount: multasSesion.isEmpty ? 1 : multasSesion.length,
                      itemBuilder: (context, index) {
                        return multasSesion.isEmpty
                            ? Align(
                                alignment: Alignment.bottomCenter,
                                child: Text(
                                  currentIndex == 0
                                      ? "Aún no tienes multas"
                                      : "No tienes multas para esta fecha",
                                  style: TiposBlue.body,
                                ))
                            : ListTile(
                                leading: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                        onPressed: () async {
                                          await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    MultaDetall(
                                                  notifyId: "sinNotificacion",
                                                  sesionId: widget.sesionId,
                                                  idMulta:
                                                      multasSesion[index].id,
                                                  idMultado: multasSesion[index]
                                                      ['idMultado'],
                                                ),
                                              ));
                                        },
                                        icon: Icon(Icons.open_in_full,
                                            color: PageColors.blue)),
                                  ],
                                ),
                                title: Text(multasSesion[index]['nomMultado'],
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: PageColors.blue,
                                        fontWeight: FontWeight.bold)),
                                subtitle: Text(
                                  multasSesion[index]['titulo'],
                                  style: TextStyle(
                                      fontSize: 14, color: PageColors.blue),
                                ),
                                trailing:
                                    Text("${multasSesion[index]['precio']}€"),
                              );
                      },
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
