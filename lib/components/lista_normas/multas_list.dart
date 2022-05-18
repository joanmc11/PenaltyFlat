// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:penalty_flat_app/Styles/colors.dart';
import 'package:penalty_flat_app/components/lista_normas/sin_normas.dart';
import 'package:penalty_flat_app/models/codigo_multas.dart';
import 'package:penalty_flat_app/services/sesionProvider.dart';
import 'package:provider/provider.dart';
import 'package:string_extensions/string_extensions.dart';

import '../../screens/crearMulta/editar_multa.dart';

class MultasList extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;
    final idCasa = Provider.of<SesionProvider?>(context)!.sesionCode;

    return Flexible(
      child: StreamBuilder(
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
              ? const SinNormas()
              : StreamBuilder(
                  stream: folded
                      ? todas
                          ? codigoMultasSnapshots(idCasa)
                          : partesMultasSnapshots(idCasa, parte)
                      : search == ""
                          ? codigoMultasSnapshots(idCasa)
                          : todas
                              ? searchMultasSnapshots(idCasa, search)
                              : searchParteMultasSnapshots(
                                  idCasa, search, parte),
                  builder: (
                    BuildContext context,
                    AsyncSnapshot<List<CodigoMultas>> snapshot,
                  ) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.done:
                        throw "Stream is none or done!!!";
                      case ConnectionState.waiting:
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      case ConnectionState.active:
                        final listCodigoMultas = snapshot.data!;
                        return _Llista(
                          listCodigoMultas: listCodigoMultas,
                          edit: edit,
                        );
                    }
                  },
                );
        },
      ),
    );
  }
}

class _Llista extends StatelessWidget {
  const _Llista({
    Key? key,
    required this.edit,
    required this.listCodigoMultas,
  }) : super(key: key);

  final bool edit;
  final List<CodigoMultas> listCodigoMultas;

  @override
  Widget build(BuildContext context) {
    return listCodigoMultas.isEmpty
        ? Center(
            child: Text(
              "No se han encontrado multas.",
              textAlign: TextAlign.center,
              style: TiposBlue.body,
            ),
          )
        : ListView.builder(
            itemCount: listCodigoMultas.length,
            itemBuilder: (BuildContext context, int index) {
              final multa = listCodigoMultas[index];
              return Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                      border: Border.all(color: Colors.grey.withOpacity(0.3))),
                  child: ListTile(
                    leading: edit
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
                                        multaId: multa.id.toString(),
                                        parte: multa.parte,
                                        titulo: multa.titulo,
                                        descripcion: multa.descripcion,
                                        precio: multa.precio,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          )
                        : null,
                    title: Text(
                      multa.titulo.capitalize!,
                      style: TextStyle(
                          color: PageColors.blue, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      multa.descripcion.capitalize!,
                      style: TextStyle(color: PageColors.blue),
                    ),
                    trailing: Text("${multa.precio} €"),
                  ),
                ),
              );
            },
          );
  }
}
