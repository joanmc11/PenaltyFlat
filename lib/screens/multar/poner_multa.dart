import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:penalty_flat_app/Styles/colors.dart';
import 'package:penalty_flat_app/components/app_bar/penalty_flat_app_bar.dart';
import 'package:penalty_flat_app/components/multar/botones_multar.dart';
import 'package:penalty_flat_app/components/multar/detalles_multa.dart';
import 'package:penalty_flat_app/components/multar/persona_multada.dart';
import 'package:penalty_flat_app/components/multar/prueba_multa.dart';
import 'package:penalty_flat_app/screens/display_paginas.dart';
import 'package:penalty_flat_app/shared/multa_screen.dart';
import 'package:provider/provider.dart';

class PonerMulta extends StatefulWidget {
  final String idMultado;
  final String multaId;
  const PonerMulta({
    Key? key,
    required this.idMultado,
    required this.multaId,
  }) : super(key: key);

  @override
  _PonerMultaState createState() => _PonerMultaState();
}

final db = FirebaseFirestore.instance;
bool multado = false;
String imgPath = "";
File? imgFile;

class _PonerMultaState extends State<PonerMulta> {
  callbackMultado(varMultado) {
    setState(() {
      multado = varMultado;
    });
  }

  callbackImgPath(varImgPath, varImgFile) {
    setState(() {
      imgPath = varImgPath;
      imgFile = varImgFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    final idCasa = context.read<CasaID>();
    return multado
        ? StreamBuilder(
            stream: db.doc("sesion/$idCasa/users/${widget.idMultado}").snapshots(),
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
              final userData = snapshot.data!.data()!;
              Future.delayed(
                const Duration(milliseconds: 1500),
                () async {
                  setState(() {
                    multado = false;
                  });

                  await Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DisplayPaginas(),
                    ),
                  );
                },
              );

              return MultadoPage(nombre: userData['nombre']);
            },
          )
        : Scaffold(
            appBar: PenaltyFlatAppBar(),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text("Estás a punto de multar", style: TiposBlue.title),
                ),
                PersonaMultaDetalle(idMultado: widget.idMultado),
                DetalleMultar(multaId: widget.multaId),
                PruebaMultar(
                  idMultado: widget.idMultado,
                  multaId: widget.multaId,
                  callbackImgPath: callbackImgPath,
                ),
                BotonesMultar(
                  idMultado: widget.idMultado,
                  multaId: widget.multaId,
                  callbackMultado: callbackMultado,
                  imgName: imgPath,
                  imgFile: imgFile,
                )
              ],
            ),
          );
  }
}
