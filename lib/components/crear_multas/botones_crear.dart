import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../Styles/colors.dart';

class BotonesCrear extends StatelessWidget {
  final String sesionId;
  final String titulo;
  final String parteCasa;
  final String descripcion;
  final num precio;
  final GlobalKey<FormState> formKey;
  BotonesCrear({
    Key? key,
    required this.sesionId,
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: PageColors.white),
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
                  primary:
                      titulo != "" && descripcion != ""
                          ? PageColors.yellow
                          : Colors.grey),
              child: Text(
                "Crear",
                style: TextStyle(color: PageColors.blue),
              ),
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  await db
                      .collection(
                          'sesion/$sesionId/codigoMultas')
                      .add({
                    'titulo': titulo.toLowerCase(),
                    'descripcion':
                        descripcion.toLowerCase(),
                    'parte': parteCasa,
                    'precio': precio,
                  });

                  await db
                      .doc('sesion/$sesionId')
                      .update({
                    "sinMultas": false,
                  });
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                      duration: Duration(seconds: 1),
                      content: Text(
                          "¡Norma creada con éxito!"),
                    ),
                  );
                  await Future.delayed(
                      const Duration(milliseconds: 300),
                      () {
                   /* Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CodigoMultas(
                            sesionId: sesionId,
                          ),
                        ));*/
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
