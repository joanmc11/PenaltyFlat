import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:penalty_flat_app/services/database.dart';
import 'package:penalty_flat_app/services/sesionProvider.dart';
import 'package:provider/provider.dart';
import '../../../Styles/colors.dart';

class BotonesCrear extends StatelessWidget {
  final String titulo;
  final String parteCasa;
  final String descripcion;
  final num precio;
  final GlobalKey<FormState> formKey;
  BotonesCrear({
    Key? key,
    required this.titulo,
    required this.parteCasa,
    required this.descripcion,
    required this.precio,
    required this.formKey,
  }) : super(key: key);

  //final _formKey = GlobalKey<FormState>();
  final db = FirebaseFirestore.instance;

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
                "Cancelar",
                style: TextStyle(color: PageColors.blue),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: titulo != "" && descripcion != "" ? PageColors.yellow : Colors.grey),
              child: Text(
                "Crear",
                style: TextStyle(color: PageColors.blue),
              ),
              onPressed: () async {
                if (formKey.currentState!.validate()) {

                  DatabaseService(uid: '').createMulta(idCasa, titulo, descripcion, parteCasa, precio, context);
                  
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
