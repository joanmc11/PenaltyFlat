import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:penalty_flat_app/screens/penaltyflat/codigo_multas.dart';

import '../../../Styles/colors.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: PageColors.blue,
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CodigoMultas(
                      sesionId: widget.sesionId,
                    ),
                  ));
            },
          ),
          toolbarHeight: 70,
          backgroundColor: PageColors.white,
          title: Center(
            child: Text(
              'Penalty Flat',
              style: TextStyle(color: PageColors.blue),
            ),
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.notifications_none_outlined,
                color: PageColors.blue,
              ),
              padding: const EdgeInsets.only(right: 30),
            )
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
                          Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 0.0, bottom: 4),
                                  child: Text(
                                    "Ponle un título a tu norma:",
                                    style: TiposBlue.body,
                                  ),
                                ),
                              ),
                              TextFormField(
                                //email
                                validator: (val) => val!.isEmpty
                                    ? "Introduce un nombre para la norma"
                                    : null,
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
                                    "Descríbela brevemente:",
                                    style: TiposBlue.body,
                                  ),
                                ),
                              ),
                              TextFormField(
                                validator: (val) => val!.isEmpty
                                    ? "Añade una pequeña descripción"
                                    : null,
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
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 4, right: 16),
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
                                value: 1.0,
                                decimals: 1,
                                step: 0.1,
                                decoration: const InputDecoration(
                                    labelText: 'Cantidad a penalizar',
                                    floatingLabelAlignment:
                                        FloatingLabelAlignment.center,
                                    contentPadding:
                                        EdgeInsets.only(bottom: 8.0)),
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
                                      "Cancelar",
                                      style: TextStyle(color: PageColors.blue),
                                    ),
                                    onPressed: () async {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => CodigoMultas(
                                              sesionId: widget.sesionId,
                                            ),
                                          ));
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
                                      "Crear",
                                      style: TextStyle(color: PageColors.blue),
                                    ),
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        await db
                                            .collection(
                                                'sesion/${widget.sesionId}/codigoMultas')
                                            .add({
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
                                            content: Text(
                                                "¡Norma creada con éxito!"),
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
        ));
  }
}
