import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:penalty_flat_app/Styles/colors.dart';
import 'package:penalty_flat_app/models/codigo_multas.dart';
import 'package:penalty_flat_app/services/sesionProvider.dart';
import 'package:provider/provider.dart';
import 'package:string_extensions/string_extensions.dart';

class DetalleMultar extends StatelessWidget {
  final String multaId;
  DetalleMultar({
    Key? key,
    required this.multaId,
  }) : super(key: key);

  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final idCasa = Provider.of<SesionProvider?>(context)!.sesionCode;

    return StreamBuilder(
      stream: singleNormaSnapshot(idCasa, multaId),
      builder: (
        BuildContext context,
        AsyncSnapshot<CodigoMultas> snapshot,
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(multaData.titulo.capitalize!,
                                style: TiposBlue.bodyBold),
                            Text(multaData.descripcion.capitalize!,
                                style: TiposBlue.body),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text("Precio a pagar:", style: TiposBlue.subtitle),
                    ),
                    Text("${multaData.precio}€", style: TiposBlue.body),
                  ],
                ),
              ),
              Container()
            ],
          );
        }});
  }
}
