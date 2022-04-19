import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:icon_badge/icon_badge.dart';
import 'package:penalty_flat_app/components/app_bar_title.dart';
import 'package:penalty_flat_app/components/crear_multas/cantidad_crear.dart';
import 'package:penalty_flat_app/components/crear_multas/parte_crear.dart';
import 'package:penalty_flat_app/components/editar_multas/botones_edit.dart';
import 'package:penalty_flat_app/components/editar_multas/desc_edit.dart';
import 'package:penalty_flat_app/components/editar_multas/titulo_edit.dart';
import 'package:provider/provider.dart';
import '../../../Styles/colors.dart';
import '../../models/user.dart';
import '../notifications.dart';

class VerMulta extends StatefulWidget {
  final String sesionId;
  final String multaId;
  final String parte;
  final String titulo;
  final String descripcion;
  final num precio;
  const VerMulta(
      {Key? key,
      required this.sesionId,
      required this.multaId,
      required this.parte,
      required this.titulo,
      required this.descripcion,
      required this.precio})
      : super(key: key);

  @override
  _VerMultaState createState() => _VerMultaState();
}

class _VerMultaState extends State<VerMulta> {
  @override
  void initState() {
    super.initState();
    setState(() {
      parteCasa = widget.parte;
      titulo = widget.titulo;
      descripcion = widget.descripcion;
      precio = widget.precio;
    });
  }

  final _formKey = GlobalKey<FormState>();

  String titulo = "";
  String descripcion = "";
  num precio = 0;
  String parteCasa = "Otros";
  bool editTit = false;
  bool editDesc = false;
  bool seguir = false;

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

  callbackPrecio(varPrecio) {
    setState(() {
      precio = varPrecio;
    });
  }

  callbackParte(varParte) {
    setState(() {
      parteCasa = varParte;
    });
  }

  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;
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
        title: const AppBarTitle(),
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
                          builder: (context) => Notificaciones(sesionId: widget.sesionId)),
                    );
                  },
                );
              }),
        ],
      ),
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
                      "Edita esta Multa",
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
                        TituloEdit(titulo: titulo, callbackTitulo: callbackTitulo),
                        DescripcionEdit(descripcion: descripcion, callbackDesc: callbackDesc),
                        ParteCrear(
                            sesionId: widget.sesionId,
                            parteCasa: widget.parte,
                            callbackParte: callbackParte),
                        CantidadCrear(
                            sesionId: widget.sesionId,
                            precio: widget.precio,
                            callbackPrecio: callbackPrecio),
                        BotonesEdit(
                            sesionId: widget.sesionId,
                            multaId: widget.multaId,
                            parte: parteCasa,
                            titulo: titulo,
                            descripcion: descripcion,
                            precio: precio,
                            parteCasa: parteCasa,
                            formKey: _formKey)
                      ],
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
