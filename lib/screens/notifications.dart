import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:penalty_flat_app/components/notificacions/notify_pic.dart';
import 'package:provider/provider.dart';
import 'package:string_extensions/string_extensions.dart';
import '../../Styles/colors.dart';
import '../../models/user.dart';
import 'llistaMultes/multa_detall.dart';
import 'pagamentos/confirmaciones.dart';

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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: PageColors.blue,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
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
                    notifyData[index]['tipo'] == "feedback"
                        ? notifyData[index]['mensaje'] == "Pago aceptado"
                            ? null
                            : debugPrint('este es el id:' + notifyData[index]['idNotificador'])
                        : null;
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
                                              'sesion/$sesionId/notificaciones/${notifyData[index].id}')
                                          .update({
                                        "visto": true,
                                      });

                                      await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => MultaDetall(
                                              notifyId: notifyData[index].id,
                                              sesionId: sesionId,
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
                                                  sesionId: sesionId,
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
                                      child: NotifyPic(sesionId: sesionId, notificadorId: notifyData[index]
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
                                                    sesionId: sesionId,
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
                                                  'sesion/$sesionId/notificaciones/${notifyData[index].id}')
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
