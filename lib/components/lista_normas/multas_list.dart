// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:penalty_flat_app/Styles/colors.dart';
import 'package:penalty_flat_app/services/sesionProvider.dart';
import 'package:provider/provider.dart';
import 'package:string_extensions/string_extensions.dart';

import '../../screens/crearMulta/editar_multa.dart';

class MultasList extends StatefulWidget {
  final bool folded;
  final String search;
  final bool todas;
  final String parte;
  final bool edit;
  const MultasList({
    Key? key,
    required this.folded,
    required this.search,
    required this.todas,
    required this.parte,
    required this.edit,
  }) : super(key: key);

  @override
  _MultasListState createState() => _MultasListState();
}

class _MultasListState extends State<MultasList> {
  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;
    final idCasa = Provider.of<SesionProvider?>(context)!.sesionCode;

    return Flexible(
      child: StreamBuilder(
        stream: !widget.folded && widget.search != ""
            ? widget.todas
                ? db
                    .collection("sesion/$idCasa/codigoMultas")
                    .where('titulo', isGreaterThanOrEqualTo: widget.search.toLowerCase())
                    .where('titulo',
                        isLessThan: widget.search
                                .toLowerCase()
                                .substring(0, widget.search.toLowerCase().length - 1) +
                            String.fromCharCode(
                                widget.search.toLowerCase().codeUnitAt(widget.search.length - 1) +
                                    1))
                    .snapshots()
                : db
                    .collection("sesion/$idCasa/codigoMultas")
                    .where('parte', isEqualTo: widget.parte)
                    .where('titulo', isGreaterThanOrEqualTo: widget.search.toLowerCase())
                    .where('titulo',
                        isLessThan: widget.search
                                .toLowerCase()
                                .substring(0, widget.search.toLowerCase().length - 1) +
                            String.fromCharCode(
                                widget.search.toLowerCase().codeUnitAt(widget.search.length - 1) +
                                    1))
                    .snapshots()
            : widget.todas
                ? db.collection("sesion/$idCasa/codigoMultas").snapshots()
                : db
                    .collection("sesion/$idCasa/codigoMultas")
                    .where('parte', isEqualTo: widget.parte)
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
          final codigoMultas = snapshot.data!.docs;

          return StreamBuilder(
            stream: db.doc("sesion/$idCasa").snapshots(),
            builder: (
              BuildContext context,
              AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot,
            ) {
              if (snapshot.hasError) {
                return ErrorWidget(snapshot.error.toString());
              }
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final casaData = snapshot.data!.data()!;
              return casaData['sinMultas']
                  ? SingleChildScrollView(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height / 1.5,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Center(
                                  child: Text(
                                    "Todavía no hay normas en tu código de multas",
                                    textAlign: TextAlign.center,
                                    style: TiposBlue.subtitle,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Center(
                                  child: Text(
                                    "Todos los intengrantes de esta casa pueden añadir y eliminar normas. Poneros de acuerdo y rellenad este vacío con todo lo que se os ocurra.",
                                    textAlign: TextAlign.center,
                                    style: TiposBlue.body,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0, top: 4.0, right: 8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                      border: Border.all(color: Colors.grey.withOpacity(0.3))),
                                  child: ListTile(
                                    title: Text(
                                      "Carretera en el lavabo",
                                      style: TextStyle(
                                          color: PageColors.blue, fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                      "Dejar un rastro negro en el WC",
                                      style: TextStyle(color: PageColors.blue),
                                    ),
                                    trailing:
                                        GestureDetector(onTap: () {}, child: const Text('0.5€')),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                      border: Border.all(color: Colors.grey.withOpacity(0.3))),
                                  child: ListTile(
                                    title: Text(
                                      "Platos con telarañas",
                                      style: TextStyle(
                                          color: PageColors.blue, fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                      "Platos más de dos dias sin lavar",
                                      style: TextStyle(color: PageColors.blue),
                                    ),
                                    trailing:
                                        GestureDetector(onTap: () {}, child: const Text('2€')),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  "Esto son ejemplos. Ten en cuenta que se borrarán al añadir una norma.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 14, color: PageColors.blue),
                                ),
                              ),
                            ]),
                      ),
                    )
                  : codigoMultas.isEmpty
                      ? Center(
                          child: Text(
                            "No se han encontrado multas.",
                            textAlign: TextAlign.center,
                            style: TiposBlue.body,
                          ),
                        )
                      : ListView.builder(
                          itemCount: codigoMultas.length,
                          itemBuilder: (BuildContext context, int index) {
                            final String? titulo = "${codigoMultas[index]['titulo']}".capitalize;
                            final String? descripcion =
                                "${codigoMultas[index]['descripcion']}".capitalize;

                            return Padding(
                              padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    border: Border.all(color: Colors.grey.withOpacity(0.3))),
                                child: Padding(
                                  padding: widget.edit
                                      ? const EdgeInsets.all(4.0)
                                      : const EdgeInsets.all(0),
                                  child: ListTile(
                                    leading: widget.edit
                                        ? Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              IconButton(
                                                icon: Icon(Icons.edit, color: PageColors.blue),
                                                onPressed: () async {
                                                  await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => VerMulta(
                                                        multaId: codigoMultas[index].id,
                                                        parte: codigoMultas[index]['parte'],
                                                        titulo: codigoMultas[index]['titulo'],
                                                        descripcion: codigoMultas[index]
                                                            ['descripcion'],
                                                        precio: codigoMultas[index]['precio'],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          )
                                        : null,
                                    title: Text(
                                      titulo!,
                                      style: TextStyle(
                                          color: PageColors.blue, fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                      descripcion!,
                                      style: TextStyle(color: PageColors.blue),
                                    ),
                                    trailing: Text('${codigoMultas[index]['precio']}€'),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
            },
          );
        },
      ),
    );
  }
}
