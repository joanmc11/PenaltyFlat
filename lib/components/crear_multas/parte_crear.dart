import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:penalty_flat_app/screens/display_paginas.dart';
import 'package:provider/provider.dart';

import '../../../Styles/colors.dart';

class ParteCrear extends StatefulWidget {
  final String parteCasa;
  final Function callbackParte;
  const ParteCrear({
    Key? key,
    required this.parteCasa,
    required this.callbackParte,
  }) : super(key: key);

  @override
  _ParteCrearState createState() => _ParteCrearState();
}

class _ParteCrearState extends State<ParteCrear> {
  final db = FirebaseFirestore.instance;
  String parteCasa = "Otros";
  @override
  void initState() {
    super.initState();
    setState(() {
      parteCasa = widget.parteCasa;
    });
  }

  @override
  Widget build(BuildContext context) {
    final idCasa = context.read<CasaID>();
    return Row(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 4, right: 16),
            child: Text(
              "¿Qué parte?",
              style: TiposBlue.body,
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: StreamBuilder(
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
              final casaData = snapshot.data!.data()!;
              List<String> partesCasa = [];
              for (int i = 0; i < casaData.length + 1; i++) {
                partesCasa.add(casaData['partes'][i + 1].toString());
                debugPrint(partesCasa[i]);
              }

              return DropdownButton(
                hint: const Text("Selecciona"),
                dropdownColor: PageColors.white,
                borderRadius: BorderRadius.circular(20),
                value: parteCasa,
                items: partesCasa.map((valuesItem) {
                  return DropdownMenuItem(
                    value: valuesItem,
                    child: Text(valuesItem),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    parteCasa = value!;
                  });
                  widget.callbackParte(parteCasa);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
