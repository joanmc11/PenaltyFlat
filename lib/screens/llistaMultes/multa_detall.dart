import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:penalty_flat_app/components/app_bar/penalty_flat_app_bar.dart';
import 'package:penalty_flat_app/components/multa_detall/aceptar_multa.dart';
import 'package:penalty_flat_app/components/multa_detall/descripcion_multa.dart';
import 'package:penalty_flat_app/components/multa_detall/image_detail.dart';
import 'package:penalty_flat_app/components/multa_detall/precio_multa.dart';
import 'package:penalty_flat_app/components/multa_detall/pruebas.dart';
import 'package:penalty_flat_app/components/multa_detall/title_multa.dart';
import 'package:penalty_flat_app/shared/loading.dart';

class MultaDetall extends StatelessWidget {
  final String sesionId;
  final String idMulta;
  final String idMultado;
  final String notifyId;
  MultaDetall({
    Key? key,
    required this.sesionId,
    required this.idMulta,
    required this.idMultado,
    required this.notifyId,
  }) : super(key: key);
  final db = FirebaseFirestore.instance;
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PenaltyFlatAppBar(sesionId: sesionId),
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height*1.1,
            child: StreamBuilder(
              stream: db.doc("sesion/$sesionId/multas/$idMulta").snapshots(),
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
                Map multaData = {};
                snapshot.data?.data() != null
                    ? multaData = snapshot.data!.data()!
                    : multaData = {};
        
                return multaData.isEmpty
                    ? const Loading()
                    : Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex:1, 
                                child: TituloMulta(sesionId: sesionId, idMulta: idMulta)),
                              ImagenMultado(
                                  sesionId: sesionId, idMultado: idMultado),
                              Expanded(
                                flex:4,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    DescripcionDetail(
                                        sesionId: sesionId, idMulta: idMulta),
                                    PruebasDetail(
                                        sesionId: sesionId, idMulta: idMulta),
                                    PrecioDetail(
                                        sesionId: sesionId, idMulta: idMulta),
                                    AceptarMulta(
                                        sesionId: sesionId,
                                        idMulta: idMulta,
                                        notifyId: notifyId),
                                  ],
                                ),
                              ),
                            ]),
                      );
              },
            ),
          ),
        ));
  }
}
