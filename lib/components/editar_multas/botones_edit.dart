// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
    final db = FirebaseFirestore.instance;
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
                await showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                          title: const Text("¿Eliminar norma?"),
                          content: const Text("¿Estás seguro?"),
                          actions: [
                            FlatButton(
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                  await db.doc("sesion/$idCasa/codigoMultas/$multaId").delete();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      duration: Duration(seconds: 1),
                                      content: Text("Norma eliminada"),
                                    ),
                                  );
                                  await Future.delayed(const Duration(milliseconds: 300), () {
                                    /* Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CodigoMultas(
                                          ),
                                        ));*/
                                    Navigator.of(context).pop();
                                  });
                                },
                                child: const Text(
                                  "Si",
                                  style: TextStyle(color: Colors.blue),
                                )),
                            FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("No", style: TextStyle(color: Colors.blue)))
                          ],
                        ),
                    barrierDismissible: false);
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
                  await db.doc('sesion/$idCasa/codigoMultas/$multaId').update({
                    'titulo': titulo.toLowerCase(),
                    'descripcion': descripcion.toLowerCase(),
                    'parte': parteCasa,
                    'precio': precio,
                  });

                  await db.doc('sesion/$idCasa').update({
                    "sinMultas": false,
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      duration: Duration(seconds: 1),
                      content: Text("¡Norma actualizada!"),
                    ),
                  );
                  await Future.delayed(const Duration(milliseconds: 300), () {
                    Navigator.of(context).pop();
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
