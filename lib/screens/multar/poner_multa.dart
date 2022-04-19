import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:icon_badge/icon_badge.dart';
import 'package:penalty_flat_app/Styles/colors.dart';
import 'package:penalty_flat_app/components/multar/botones_multar.dart';
import 'package:penalty_flat_app/components/multar/detalles_multa.dart';
import 'package:penalty_flat_app/components/multar/persona_multada.dart';
import 'package:penalty_flat_app/components/multar/prueba_multa.dart';
import 'package:penalty_flat_app/screens/notifications.dart';
import 'package:penalty_flat_app/screens/principal.dart';
import 'package:penalty_flat_app/shared/multa_screen.dart';
import 'package:provider/provider.dart';
import '../../models/user.dart';

class PonerMulta extends StatefulWidget {
  final String sesionId;
  final String idMultado;
  final String multaId;
  const PonerMulta({
    Key? key,
    required this.sesionId,
    required this.idMultado,
    required this.multaId,
  }) : super(key: key);

  @override
  _PonerMultaState createState() => _PonerMultaState();
}

final db = FirebaseFirestore.instance;
bool multado = false;
String imgPath="";
class _PonerMultaState extends State<PonerMulta> {
  callbackMultado(varMultado) {
    setState(() {
      multado = varMultado;
    });
  }

  callbackImgPath(varImgPath){
    setState(() {
      imgPath=varImgPath;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    return multado
        ? StreamBuilder(
            stream: db
                .doc("sesion/${widget.sesionId}/users/${widget.idMultado}")
                .snapshots(),
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
              final userData = snapshot.data!.data()!;
              Future.delayed(const Duration(milliseconds: 800), () async {
                setState(() {
                  multado = false;
                });

                await Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PrincipalScreen(sesionId: widget.sesionId),
                    ));
              });

              return MultadoPage(nombre: userData['nombre']);
            },
          )
        : Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                color: PageColors.blue,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              toolbarHeight: 70,
              backgroundColor: Colors.white,
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
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot,
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
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child:
                      Text("Estás a punto de multar", style: TiposBlue.title),
                ),
                PersonaMultaDetalle(
                    sesionId: widget.sesionId, idMultado: widget.idMultado),
                DetalleMultar(
                    sesionId: widget.sesionId, multaId: widget.multaId),
                PruebaMultar(
                    sesionId: widget.sesionId,
                    idMultado: widget.idMultado,
                    multaId: widget.multaId,
                    callbackImgPath: callbackImgPath,),
                BotonesMultar(
                  sesionId: widget.sesionId,
                  idMultado: widget.idMultado,
                  multaId: widget.multaId,
                  callbackMultado: callbackMultado,
                  imgPath: imgPath,
                )
              ],
            ),
          );
  }
}
