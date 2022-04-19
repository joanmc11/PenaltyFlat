import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:penalty_flat_app/Styles/colors.dart';
import 'package:string_extensions/string_extensions.dart';

class DetalleMultar extends StatelessWidget {
  final String sesionId;
  final String multaId;
  DetalleMultar({
    Key? key,
    required this.sesionId,
    required this.multaId,
  }) : super(key: key);

  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: db.doc("sesion/$sesionId/codigoMultas/$multaId").snapshots(),
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
          final multaData = snapshot.data!.data()!;
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text("¿Que ha hecho?", style: TiposBlue.subtitle),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: PageColors.blue.withOpacity(0.2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Column(
                          crossAxisAlignment:
                        CrossAxisAlignment.start,
                          children: [
                            Text("${multaData['titulo']}".capitalize!,
                                style: TiposBlue.bodyBold),
                                 Text("${multaData['descripcion']}".capitalize!,
                        style: TiposBlue.body),
                        
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text("Precio a pagar:", style: TiposBlue.subtitle),
                    ),
                    Text("${multaData['precio']}€",
                        style: TiposBlue.body),
                   
                    
                  ],
                ),
              ),
              Container()
            ],
          );
        });
  }
}
