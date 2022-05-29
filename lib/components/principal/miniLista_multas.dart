// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:penalty_flat_app/Styles/colors.dart';
import 'package:penalty_flat_app/models/multas.dart';
import 'package:penalty_flat_app/services/sesionProvider.dart';
import 'package:penalty_flat_app/screens/llistaMultes/llista_multas.dart';
import 'package:provider/provider.dart';
import '../../screens/llistaMultes/multa_detall.dart';

class MiniLista extends StatelessWidget {
  const MiniLista({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final idCasa = Provider.of<SesionProvider?>(context)!.sesionCode;
    return StreamBuilder(
      stream: miniListaSnapshots(idCasa),
      builder: (
        BuildContext context,
        AsyncSnapshot<List<Multa>> snapshot,
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
            final listMultas = snapshot.data!;

            return Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ListView.builder(
                        itemExtent: 55.0,
                        shrinkWrap: true,
                        itemCount: listMultas.isEmpty
                            ? 1
                            : listMultas.length > 3
                                ? 3
                                : listMultas.length,
                        itemBuilder: (context, index) {
                          return listMultas.isEmpty
                              ? const SinMultas()
                              : ListTile(
                                  leading: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      MultaDetall(
                                                    notifyId: "sinNotificacion",
                                                    idMulta: listMultas[index]
                                                        .id
                                                        .toString(),
                                                    idMultado: listMultas[index]
                                                        .idMultado,
                                                  ),
                                                ));
                                          },
                                          icon: Icon(Icons.open_in_full,
                                              color: PageColors.blue)),
                                    ],
                                  ),
                                  title: Text(listMultas[index].nomMultado,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: PageColors.blue,
                                          fontWeight: FontWeight.bold)),
                                  subtitle: Text(
                                    listMultas[index].titulo,
                                    style: TextStyle(
                                        fontSize: 14, color: PageColors.blue),
                                  ),
                                  trailing:
                                      Text("${listMultas[index].precio}€"),
                                );
                        },
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(right: 20, top: 8, bottom: 8),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: GestureDetector(
                              onTap: () async {
                                await Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const PantallaMultas()),
                                );
                              },
                              child: Text(
                                listMultas.length > 3 ? "+ ver mas" : "",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: PageColors.blue,
                                ),
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
        }
      },
    );
  }
}

class SinMultas extends StatelessWidget {
  const SinMultas({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Center(
          child: Text(
        "Todavía no hay multas",
        style: TiposBlue.bodyBold,
      )),
      subtitle: Padding(
        padding: const EdgeInsets.only(bottom: 32.0),
        child: Center(
            child: Text(
          "¿Serás tu el primero?",
          style: TiposBlue.body,
        )),
      ),
    );
  }
}
