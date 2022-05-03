import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:penalty_flat_app/components/app_bar/penalty_flat_app_bar.dart';
import 'package:penalty_flat_app/components/crear_multas/botones_crear.dart';
import 'package:penalty_flat_app/components/crear_multas/cantidad_crear.dart';
import 'package:penalty_flat_app/components/crear_multas/descripcion_crear.dart';
import 'package:penalty_flat_app/components/crear_multas/parte_crear.dart';
import 'package:penalty_flat_app/components/crear_multas/titulo_crear.dart';
import '../../../Styles/colors.dart';

class CrearMulta extends StatefulWidget {
  const CrearMulta({Key? key}) : super(key: key);

  @override
  _CrearMultaState createState() => _CrearMultaState();
}

class _CrearMultaState extends State<CrearMulta> {
  final _formKey = GlobalKey<FormState>();
  final db = FirebaseFirestore.instance;
  String parteCasa = "Otros";
  String titulo = "";
  String descripcion = "";
  num precio = 1.0;

  callbackTitulo(varTitulo) {
    setState(() {
      titulo = varTitulo;
    });
  }

  callbackDesc(varDesc) {
    setState(() {
      descripcion = varDesc;
    });
  }

  callbackParte(varParte) {
    setState(() {
      parteCasa = varParte;
    });
  }

  callbackPrecio(varPrecio) {
    setState(() {
      precio = varPrecio;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PenaltyFlatAppBar(),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height / 1.2,
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                          child: Text(
                        "Crea tu propia multa",
                        style: TiposBlue.title,
                      )),
                    ],
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TituloCrear(callbackTitulo: callbackTitulo),
                          DescripcionCrear(callbackDesc: callbackDesc),
                          ParteCrear(
                            parteCasa: "Otros",
                            callbackParte: callbackParte,
                          ),
                          CantidadCrear(precio: 1, callbackPrecio: callbackPrecio),
                          BotonesCrear(
                            titulo: titulo,
                            parteCasa: parteCasa,
                            descripcion: descripcion,
                            precio: precio,
                            formKey: _formKey,
                          ),
                        ],
                      )),
                )
              ],
            ),
          ),
        ));
  }
}
