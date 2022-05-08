import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:penalty_flat_app/Styles/colors.dart';
import 'package:penalty_flat_app/services/sesionProvider.dart';
import 'package:penalty_flat_app/screens/llistaMultes/multa_detall.dart';
import 'package:provider/provider.dart';
import '../../models/user.dart';

class ListaMultasUsuarios extends StatelessWidget {
  final int monthValue;
  final String selectedMonth;
  final int yearValue;
  final bool selected;
  final int currentIndex;

  const ListaMultasUsuarios({
    Key? key,
    required this.monthValue,
    required this.selectedMonth,
    required this.yearValue,
    required this.selected,
    required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;
    final user = Provider.of<MyUser?>(context);
    final idCasa = Provider.of<SesionProvider?>(context)!.sesionCode;
    return StreamBuilder(
        stream: selected
            ? db
                .collection("sesion/$idCasa/multas")
                .where('aceptada', isEqualTo: true)
                .where('fecha',
                    isGreaterThanOrEqualTo:
                        DateTime(selectedMonth == "Todas" ? 2020 : yearValue, monthValue, 01))
                .where('fecha',
                    isLessThan:
                        DateTime(selectedMonth == "Todas" ? 2160 : yearValue, monthValue + 1, 01))
                .orderBy('fecha', descending: true)
                .snapshots()
            : db
                .collection("sesion/$idCasa/multas")
                .where('aceptada', isEqualTo: true)
                .where('idMultado', isEqualTo: user!.uid)
                .where('fecha',
                    isGreaterThanOrEqualTo:
                        DateTime(selectedMonth == "Todas" ? 2020 : yearValue, monthValue, 01))
                .where('fecha',
                    isLessThan:
                        DateTime(selectedMonth == "Todas" ? 2160 : yearValue, monthValue + 1, 01))
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
              padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
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
                                          builder: (context) => MultaDetall(
                                            notifyId: "sinNotificacion",
                                            idMulta: multasSesion[index].id,
                                            idMultado: multasSesion[index]['idMultado'],
                                          ),
                                        ));
                                  },
                                  icon: Icon(Icons.open_in_full, color: PageColors.blue)),
                            ],
                          ),
                          title: Text(multasSesion[index]['nomMultado'],
                              style: TextStyle(
                                  fontSize: 14,
                                  color: PageColors.blue,
                                  fontWeight: FontWeight.bold)),
                          subtitle: Text(
                            multasSesion[index]['titulo'],
                            style: TextStyle(fontSize: 14, color: PageColors.blue),
                          ),
                          trailing: Text("${multasSesion[index]['precio']}€"),
                        );
                },
              ),
            ),
          );
        });
  }
}
