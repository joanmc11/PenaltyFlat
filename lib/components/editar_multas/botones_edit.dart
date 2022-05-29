

import 'package:flutter/material.dart';
import 'package:penalty_flat_app/services/database.dart';
import 'package:penalty_flat_app/services/sesionProvider.dart';
import 'package:provider/provider.dart';
import '../../../Styles/colors.dart';

class BotonesEdit extends StatelessWidget {
  final String multaId;
  final String parte;
  final String titulo;
  final String descripcion;
  final num precio;
  final String parteCasa;
  final GlobalKey<FormState> formKey;
  const BotonesEdit({
    Key? key,
    required this.multaId,
    required this.parte,
    required this.titulo,
    required this.descripcion,
    required this.precio,
    required this.parteCasa,
    required this.formKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final idCasa = Provider.of<SesionProvider?>(context)!.sesionCode;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(primary: PageColors.white),
              child: Text(
                "Eliminar",
                style: TextStyle(color: PageColors.blue),
              ),
              onPressed: () async {
                DatabaseService(uid: '').deleteNorma(idCasa, multaId, context);
              },
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(primary: PageColors.yellow),
              child: Text(
                "Actualizar",
                style: TextStyle(color: PageColors.blue),
              ),
              onPressed: () async {
                if (formKey.currentState!.validate()) {

                  DatabaseService(uid: '').editNorma(idCasa, multaId, titulo, descripcion, parteCasa, precio, context);
                 
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
