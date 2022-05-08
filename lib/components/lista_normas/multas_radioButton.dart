// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:penalty_flat_app/Styles/colors.dart';
import 'package:penalty_flat_app/services/sesionProvider.dart';
import 'package:string_extensions/string_extensions.dart';
import 'package:provider/provider.dart';

class MultasRadio extends StatefulWidget {
  final bool folded;
  final String search;
  final bool todas;
  final String parte;
  final Function callbackMulta;
  const MultasRadio({
    Key? key,
    required this.folded,
    required this.search,
    required this.todas,
    required this.parte,
    required this.callbackMulta,
  }) : super(key: key);

  @override
  _MultasRadioState createState() => _MultasRadioState();
}

class _MultasRadioState extends State<MultasRadio> {
  /*int selectedIndex = 0;
  bool selected = true;
  bool _folded = true;
  bool todas = true;
  String parte = "Todas";
  String search = "";
  String _site = "";
  bool edit = false;*/
  String _site = "";

  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;
    final idCasa = Provider.of<SesionProvider?>(context)!.sesionCode;

    return Flexible(
      child: StreamBuilder(
        stream: !widget.folded && widget.search != ""
            ? widget.todas
                ? db
                    .collection("sesion/$idCasa/codigoMultas")
                    .where('titulo', isGreaterThanOrEqualTo: widget.search.toLowerCase())
                    .where('titulo',
                        isLessThan: widget.search
                                .toLowerCase()
                                .substring(0, widget.search.toLowerCase().length - 1) +
                            String.fromCharCode(
                                widget.search.toLowerCase().codeUnitAt(widget.search.length - 1) +
                                    1))
                    .snapshots()
                : db
                    .collection("sesion/$idCasa/codigoMultas")
                    .where('parte', isEqualTo: widget.parte)
                    .where('titulo', isGreaterThanOrEqualTo: widget.search.toLowerCase())
                    .where('titulo',
                        isLessThan: widget.search
                                .toLowerCase()
                                .substring(0, widget.search.toLowerCase().length - 1) +
                            String.fromCharCode(
                                widget.search.toLowerCase().codeUnitAt(widget.search.length - 1) +
                                    1))
                    .snapshots()
            : widget.todas
                ? db.collection("sesion/$idCasa/codigoMultas").snapshots()
                : db
                    .collection("sesion/$idCasa/codigoMultas")
                    .where('parte', isEqualTo: widget.parte)
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
          final codigoMultas = snapshot.data!.docs;

          return StreamBuilder(
            stream: db.doc("sesion/$idCasa").snapshots(),
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
              return codigoMultas.isEmpty
                  ? Center(
                      child: Text(
                        "No se han encontrado multas.",
                        textAlign: TextAlign.center,
                        style: TiposBlue.body,
                      ),
                    )
                  : ListView.builder(
                      itemCount: codigoMultas.length,
                      itemBuilder: (BuildContext context, int index) {
                        final String? titulo = "${codigoMultas[index]['titulo']}".capitalize;
                        final String? descripcion =
                            "${codigoMultas[index]['descripcion']}".capitalize;

                        return Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                border: Border.all(color: Colors.grey.withOpacity(0.3))),
                            child: ListTile(
                              title: Text(
                                titulo!,
                                style:
                                    TextStyle(color: PageColors.blue, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                descripcion!,
                                style: TextStyle(color: PageColors.blue),
                              ),
                              trailing: Radio(
                                  value: codigoMultas[index].id,
                                  groupValue: _site,
                                  onChanged: (value) async {
                                    setState(() {
                                      _site = value.toString();
                                    });
                                    widget.callbackMulta(_site);
                                  }),
                            ),
                          ),
                        );
                      },
                    );
            },
          );
        },
      ),
    );
  }
}
