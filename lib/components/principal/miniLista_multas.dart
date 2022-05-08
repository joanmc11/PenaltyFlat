// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:penalty_flat_app/Styles/colors.dart';
import 'package:penalty_flat_app/services/sesionProvider.dart';
import 'package:penalty_flat_app/screens/llistaMultes/llista_multas.dart';
import 'package:provider/provider.dart';
import '../../screens/llistaMultes/multa_detall.dart';

class MiniLista extends StatelessWidget {
  const MiniLista({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;
    final idCasa = Provider.of<SesionProvider?>(context)!.sesionCode;
    return StreamBuilder(
      stream: db
          .collection("sesion/$idCasa/multas")
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

        return Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 0),
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
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
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
                                padding: const EdgeInsets.only(bottom: 32.0),
                                child: Center(
                                    child: Text(
                                  "¿Serás tu el primero?",
                                  style: TiposBlue.body,
                                )),
                              ),
                            )
                          : ListTile(
                              leading: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        Navigator.push(
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
                  Padding(
                    padding: const EdgeInsets.only(right: 20, top: 8, bottom: 8),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: GestureDetector(
                          onTap: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => const PantallaMultas()),
                            );
                          },
                          child: Text(
                            multasSesion.length > 3 ? "+ ver mas" : "",
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
            ),
          ),
        );
      },
    );
  }
}
