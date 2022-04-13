// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:icon_badge/icon_badge.dart';
import 'package:penalty_flat_app/screens/penaltyflat/codigo_multas.dart';
import 'package:provider/provider.dart';
import 'package:string_extensions/string_extensions.dart';
import '../../../Styles/colors.dart';
import '../../models/user.dart';
import 'notifications/notifications.dart';

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
                        Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 0.0, bottom: 4),
                                child: Text(
                                  "Título:",
                                  style: TiposBlue.body,
                                ),
                              ),
                            ),
                            editTit
                                ? TextFormField(
                                    validator: (val) => val!.isEmpty
                                        ? "Introduce un nombre para la norma"
                                        : null,
                                    initialValue: titulo.capitalize,
                                    decoration: InputDecoration(
                                        hintText: "Titulo ",
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: PageColors.yellow,
                                                width: 0.5))),
                                    onChanged: (val) {
                                      setState(() {
                                        titulo = val;
                                      });
                                    },
                                  )
                                : Row(
                                    children: [
                                      Flexible(
                                          child: Text(
                                        widget.titulo.capitalize!,
                                        style: TiposBlue.bodyBold,
                                      )),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 16.0),
                                        child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                editTit = true;
                                              });
                                            },
                                            child: Icon(
                                              Icons.edit,
                                              color: PageColors.blue,
                                            )),
                                      )
                                    ],
                                  ),
                          ],
                        ),
                        Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 0, bottom: 4),
                                child: Text(
                                  "Descripción:",
                                  style: TiposBlue.body,
                                ),
                              ),
                            ),
                            editDesc
                                ? TextFormField(
                                    validator: (val) => val!.isEmpty
                                        ? "Añade una descripción"
                                        : null,
                                    initialValue: descripcion.capitalize,
                                    decoration: InputDecoration(
                                        hintText: "Descripción ",
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: PageColors.yellow,
                                                width: 0.5))),
                                    onChanged: (val) {
                                      setState(() {
                                        descripcion = val;
                                      });
                                    },
                                  )
                                : Row(
                                    children: [
                                      Flexible(
                                          child: Text(
                                        widget.descripcion.capitalize!,
                                        style: TiposBlue.bodyBold,
                                      )),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 16.0),
                                        child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                editDesc = true;
                                              });
                                            },
                                            child: Icon(
                                              Icons.edit,
                                              color: PageColors.blue,
                                            )),
                                      )
                                    ],
                                  ),
                          ],
                        ),
                        Row(
                          children: [
                            Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 4, right: 16),
                                child: Text(
                                  "¿Qué parte?",
                                  style: TiposBlue.body,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: StreamBuilder(
                                stream: db
                                    .doc("sesion/${widget.sesionId}")
                                    .snapshots(),
                                builder: (
                                  BuildContext context,
                                  AsyncSnapshot<
                                          DocumentSnapshot<
                                              Map<String, dynamic>>>
                                      snapshot,
                                ) {
                                  if (snapshot.hasError) {
                                    return ErrorWidget(
                                        snapshot.error.toString());
                                  }
                                  if (!snapshot.hasData) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }
                                  List<String> partes = [
                                    'Baño',
                                    'Comedor',
                                    'Cocina',
                                    'Lavadero',
                                    'Otros'
                                  ];

                                  return DropdownButton(
                                    hint: const Text("Selecciona"),
                                    dropdownColor: PageColors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    value: parteCasa,
                                    items: partes.map((valuesItem) {
                                      return DropdownMenuItem(
                                        value: valuesItem,
                                        child: Text(valuesItem),
                                      );
                                    }).toList(),
                                    onChanged: (String? value) {
                                      setState(() {
                                        parteCasa = value!;
                                      });
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          child: SpinBox(
                              max: 10000.0,
                              value: precio.toDouble(),
                              decimals: 1,
                              step: 0.1,
                              decoration: const InputDecoration(
                                  labelText: 'Cantidad a penalizar',
                                  floatingLabelAlignment:
                                      FloatingLabelAlignment.center,
                                  contentPadding: EdgeInsets.only(bottom: 8.0)),
                              onChanged: (value) {
                                setState(() {
                                  precio = value;
                                });
                              }),
                          padding: const EdgeInsets.all(16),
                        ),
                        Row(
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
                                    "Eliminar",
                                    style: TextStyle(color: PageColors.blue),
                                  ),
                                  onPressed: () async {
                                    await showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                              title: const Text(
                                                  "¿Eliminar norma?"),
                                              content:
                                                  const Text("¿Estás seguro?"),
                                              actions: [
                                                FlatButton(
                                                    onPressed: () async {
                                                      Navigator.of(context)
                                                          .pop();
                                                      await db
                                                          .doc(
                                                              "sesion/${widget.sesionId}/codigoMultas/${widget.multaId}")
                                                          .delete();
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                          duration: Duration(
                                                              seconds: 1),
                                                          content: Text(
                                                              "Norma eliminada"),
                                                        ),
                                                      );
                                                      await Future.delayed(
                                                          const Duration(
                                                              milliseconds:
                                                                  300), () {
                                                        Navigator.pushReplacement(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  CodigoMultas(
                                                                sesionId: widget
                                                                    .sesionId,
                                                              ),
                                                            ));
                                                      });
                                                    },
                                                    child: const Text(
                                                      "Si",
                                                      style: TextStyle(
                                                          color: Colors.blue),
                                                    )),
                                                FlatButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text("No",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.blue)))
                                              ],
                                            ),
                                        barrierDismissible: false);

                                    if (seguir = true) {}
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: PageColors.yellow),
                                  child: Text(
                                    "Actualizar",
                                    style: TextStyle(color: PageColors.blue),
                                  ),
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      await db
                                          .doc(
                                              'sesion/${widget.sesionId}/codigoMultas/${widget.multaId}')
                                          .update({
                                        'titulo': titulo.toLowerCase(),
                                        'descripcion':
                                            descripcion.toLowerCase(),
                                        'parte': parteCasa,
                                        'precio': precio,
                                      });

                                      await db
                                          .doc('sesion/${widget.sesionId}')
                                          .update({
                                        "sinMultas": false,
                                      });
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          duration: Duration(seconds: 1),
                                          content: Text("¡Norma actualizada!"),
                                        ),
                                      );
                                      await Future.delayed(
                                          const Duration(milliseconds: 300),
                                          () {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  CodigoMultas(
                                                sesionId: widget.sesionId,
                                              ),
                                            ));
                                      });
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
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
