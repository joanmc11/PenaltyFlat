import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:penalty_flat_app/components/app_bar/penalty_flat_app_bar.dart';
import 'package:penalty_flat_app/components/multa_detall/aceptar_multa.dart';
import 'package:penalty_flat_app/components/multa_detall/descripcion_multa.dart';
import 'package:penalty_flat_app/components/multa_detall/image_detail.dart';
import 'package:penalty_flat_app/components/multa_detall/precio_multa.dart';
import 'package:penalty_flat_app/components/multa_detall/pruebas.dart';
import 'package:penalty_flat_app/components/multa_detall/title_multa.dart';
import 'package:penalty_flat_app/models/multas.dart';
import 'package:penalty_flat_app/services/sesionProvider.dart';
import 'package:provider/provider.dart';

class MultaDetall extends StatelessWidget {
  final String idMulta;
  final String idMultado;
  final String notifyId;
  MultaDetall({
    Key? key,
    required this.idMulta,
    required this.idMultado,
    required this.notifyId,
  }) : super(key: key);
  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final idCasa = Provider.of<SesionProvider?>(context)!.sesionCode;
    return Scaffold(
        appBar: PenaltyFlatAppBar(),
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 1.1,
            child: StreamBuilder(
              stream: singleMultaSnapshot(idCasa, idMulta),
              builder: (
                BuildContext context,
                AsyncSnapshot<Multa> snapshot,
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
                    final multaData = snapshot.data!;

                    return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              flex: 1, child: TituloMulta(idMulta: idMulta)),
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                            child: ImagenMultado(idMultado: idMultado),
                          ),
                          Expanded(
                            flex: 4,
                            child: Column(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 30),
                                  child: DescripcionDetail(multaData: multaData),
                                ),
                                Padding(
                                 padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                                  child: PruebasDetail(multaData: multaData),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                                  child: PrecioDetail(multaData: multaData),
                                ),
                                AceptarMulta(
                                    multaData: multaData, notifyId: notifyId),
                              ],
                            ),
                          ),
                        ]);
                }
              },
            ),
          ),
        ));
  }
}
