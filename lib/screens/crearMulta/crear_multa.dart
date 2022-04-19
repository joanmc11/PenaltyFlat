import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:icon_badge/icon_badge.dart';
import 'package:penalty_flat_app/components/crear_multas/botones_crear.dart';
import 'package:penalty_flat_app/components/crear_multas/cantidad_crear.dart';
import 'package:penalty_flat_app/components/crear_multas/descripcion_crear.dart';
import 'package:penalty_flat_app/components/crear_multas/parte_crear.dart';
import 'package:penalty_flat_app/components/crear_multas/titulo_crear.dart';
import 'package:provider/provider.dart';

import '../../../Styles/colors.dart';
import '../../../models/user.dart';
import '../notifications.dart';

class CrearMulta extends StatefulWidget {
  final String sesionId;
  const CrearMulta({
    Key? key,
    required this.sesionId,
  }) : super(key: key);

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
    final user = Provider.of<MyUser?>(context);
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: PageColors.blue,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          toolbarHeight: 70,
          backgroundColor: PageColors.white,
          title: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/LogoCabecera.png',
                  height: 70,
                  width: 70,
                ),
                Text('PENALTY FLAT',
                    style: TextStyle(
                        fontFamily: 'BasierCircle',
                        fontSize: 18,
                        color: PageColors.blue,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          actions: <Widget>[
            StreamBuilder(
                stream: db
                    .collection("sesion/${widget.sesionId}/notificaciones")
                    .where('idUsuario', isEqualTo: user?.uid)
                    .where('visto', isEqualTo: false)
                    .snapshots(),
                builder: (
                  BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
                ) {
                  if (snapshot.hasError) {
                    return ErrorWidget(snapshot.error.toString());
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final notifyData = snapshot.data!.docs;

                  return IconBadge(
                    icon: Icon(
                      Icons.notifications_none_outlined,
                      color: PageColors.blue,
                      size: 35,
                    ),
                    itemCount: notifyData.length,
                    badgeColor: Colors.red,
                    itemColor: Colors.white,
                    hideZero: true,
                    top: 11,
                    right: 9,
                    onTap: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) =>
                                Notificaciones(sesionId: widget.sesionId)),
                      );
                    },
                  );
                }),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height / 1.2,
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
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
                          TituloCrear(
                              sesionId: widget.sesionId,
                              callbackTitulo: callbackTitulo),
                          DescripcionCrear(
                              sesionId: widget.sesionId,
                              callbackDesc: callbackDesc),
                          ParteCrear(
                              sesionId: widget.sesionId,
                              parteCasa: "Otros",
                              callbackParte: callbackParte),
                          CantidadCrear(
                              sesionId: widget.sesionId,
                              precio: 1,
                              callbackPrecio: callbackPrecio),
                          BotonesCrear(
                            sesionId: widget.sesionId,
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
