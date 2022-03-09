import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:string_extensions/string_extensions.dart';
import '../../../Styles/colors.dart';
import '../../../models/user.dart';
import '../llistaMultes/multaDetall.dart';

class Notificaciones extends StatelessWidget {
  final String sesionId;
  const Notificaciones({Key? key, required this.sesionId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;
    final user = Provider.of<MyUser?>(context);
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          backgroundColor: Colors.white,
          title: Center(
            child: Text('Penalty Flat', style: TiposBlue.title),
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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 32.0, left: 16),
              child: Text(
                "Notificaciones",
                style: TiposBlue.subtitle,
              ),
            ),
            Flexible(
              child: StreamBuilder(
                stream: db
                    .collection("sesion/$sesionId/notificaciones")
                    .where("idUsuario", isEqualTo: user!.uid)
                    .orderBy("fecha", descending: true)
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

                  return ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemExtent: 55.0,
                      itemCount: notifyData.isEmpty ? 1 : notifyData.length,
                      itemBuilder: (context, index) {
                        return notifyData.isEmpty
                            ? Padding(
                                padding: const EdgeInsets.only(top: 32.0),
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Text(
                                    "No tienes notificaciones",
                                    style: TiposBlue.body,
                                  ),
                                ),
                              )
                            : notifyData[index]['tipo'] == "multa"
                                ? ListTile(
                                    title: Text(
                                      "¡Te han pillado!",
                                      style: TiposBlue.bodyBold,
                                    ),
                                    subtitle: Text(
                                      "${notifyData[index]['subtitulo']}"
                                          .capitalize!,
                                      style: TiposBlue.body,
                                    ),
                                    trailing: IconButton(
                                        onPressed: () async {
                                          await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    MultaDetall(
                                                  sesionId: sesionId,
                                                  idMulta: notifyData[index]
                                                      ['idMulta'],
                                                  idMultado: user.uid,
                                                ),
                                              ));
                                        },
                                        icon: Icon(
                                          Icons.add,
                                          color: PageColors.blue,
                                        )),
                                  )
                                : notifyData[index]['tipo'] == "pago"
                                    ? ListTile(
                                        title: Text(
                                          "Confirma el pago de:",
                                          style: TiposBlue.bodyBold,
                                        ),
                                        subtitle: Text(
                                          notifyData[index]['nomPagador'],
                                          style: TiposBlue.body,
                                        ),
                                        trailing: IconButton(
                                            onPressed: () {},
                                            icon: const Icon(Icons.add)),
                                      )
                                    : ListTile(
                                        title: Text(
                                          notifyData[index]['mensaje'],
                                          style: TiposBlue.bodyBold,
                                        ),
                                        subtitle: Text(
                                          notifyData[index]['subtitulo'],
                                          style: TiposBlue.body,
                                        ),
                                        trailing: IconButton(
                                            onPressed: () {},
                                            icon: const Icon(Icons.add)),
                                      );
                      });
                },
              ),
            )
          ],
        ));
  }
}
