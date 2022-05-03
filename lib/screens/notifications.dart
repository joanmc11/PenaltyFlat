import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:penalty_flat_app/components/app_bar/app_bar_title.dart';
import 'package:penalty_flat_app/components/notificacions/notify_pic.dart';
import 'package:penalty_flat_app/screens/display_paginas.dart';
import 'package:provider/provider.dart';
import 'package:string_extensions/string_extensions.dart';
import '../../Styles/colors.dart';
import '../../models/user.dart';
import 'llistaMultes/multa_detall.dart';
import 'pagamentos/confirmaciones.dart';

class Notificaciones extends StatelessWidget {
  const Notificaciones({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;
    final user = Provider.of<MyUser?>(context);
    final idCasa = context.read<CasaID>();

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: PageColors.blue, //change your color here
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: const [
            AppBarTitle(),
          ],
        ),
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
                  .collection("sesion/$idCasa/notificaciones")
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
                                leading: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: PageColors.blue,
                                  ),
                                  width: 40,
                                  child: Center(
                                    child: Icon(
                                      Icons.gavel,
                                      color: PageColors.yellow,
                                      size: 22,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  "¡Te han pillado!",
                                  style: TiposBlue.bodyBold,
                                ),
                                subtitle: Text(
                                  "${notifyData[index]['subtitulo']}".capitalize!,
                                  style: TiposBlue.body,
                                ),
                                trailing: IconButton(
                                    onPressed: () async {
                                      await db
                                          .doc(
                                              'sesion/$idCasa/notificaciones/${notifyData[index].id}')
                                          .update({
                                        "visto": true,
                                      });

                                      await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => MultaDetall(
                                              notifyId: notifyData[index].id,
                                              idMulta: notifyData[index]['idMulta'],
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
                                    leading: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: PageColors.blue,
                                      ),
                                      width: 40,
                                      child: Center(
                                        child: Icon(
                                          Icons.payment,
                                          color: PageColors.yellow,
                                          size: 22,
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      "Confirma el pago de:",
                                      style: TiposBlue.bodyBold,
                                    ),
                                    subtitle: Text(
                                      notifyData[index]['nomPagador'],
                                      style: TiposBlue.body,
                                    ),
                                    trailing: IconButton(
                                        onPressed: () async {
                                          await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Confirmaciones(
                                                  notifyId: notifyData[index].id,
                                                  userId: notifyData[index]['idPagador'],
                                                ),
                                              ));
                                        },
                                        icon: Icon(
                                          Icons.add,
                                          color: PageColors.blue,
                                        )),
                                  )
                                : ListTile(
                                    leading:
                                        /*Center(
                                      child: NotifyPic(idCasa: idCasa, notificadorId: notifyData[index]
                                                    ['idUsuario'],)
                                    ),*/
                                        notifyData[index]['mensaje'] == "Pago aceptado"
                                            ? Container(
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: PageColors.blue,
                                                ),
                                                width: 40,
                                                child: Center(
                                                  child: Icon(
                                                    Icons.group,
                                                    color: PageColors.yellow,
                                                    size: 22,
                                                  ),
                                                ),
                                              )
                                            : SizedBox(
                                                width: 40,
                                                child: Center(
                                                  child: NotifyPic(
                                                    notificadorId: notifyData[index]
                                                        ['idNotificador'],
                                                  ),
                                                ),
                                              ),
                                    title: Text(
                                      notifyData[index]['mensaje'],
                                      style: TiposBlue.bodyBold,
                                    ),
                                    subtitle: Text(
                                      notifyData[index]['subtitulo'],
                                      style: TiposBlue.body,
                                    ),
                                    trailing: IconButton(
                                        onPressed: () async {
                                          await db
                                              .doc(
                                                  'sesion/$idCasa/notificaciones/${notifyData[index].id}')
                                              .update({
                                            'visto': true,
                                          });
                                        },
                                        icon: notifyData[index]['visto']
                                            ? Container()
                                            : Icon(Icons.check, color: PageColors.blue)),
                                  );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
