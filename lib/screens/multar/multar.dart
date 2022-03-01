import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:penalty_flat_app/Styles/colors.dart';
import 'package:penalty_flat_app/screens/multar/escojer_multa.dart';
import 'package:penalty_flat_app/screens/multar/usuario_multa.dart';
import 'package:penalty_flat_app/screens/penaltyflat/principal.dart';
import 'package:provider/provider.dart';
import 'package:string_extensions/string_extensions.dart';

import '../../main.dart';
import 'package:dotted_border/dotted_border.dart';

import '../../models/user.dart';
import '../widgets/tab_item.dart';

class Multar extends StatelessWidget {
  final String sesionId;
  final String idMultado;
  final String multaId;
  Multar({
    Key? key,
    required this.sesionId,
    required this.idMultado,
    required this.multaId,
  }) : super(key: key);

  final db = FirebaseFirestore.instance;
  final List<Color> colors = [
    Colors.blue,
    Colors.red,
    Colors.yellow,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.indigo,
    Colors.pinkAccent,
    Colors.amber,
    Colors.deepOrange,
    Colors.brown,
    Colors.cyan,
  ];
  final String imgPath = "";
  DateTime dateToday =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: PageColors.blue,
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => EscojerMulta(
                    sesionId: sesionId,
                    idMultado: idMultado,
                  ),
                ));
          },
        ),
        toolbarHeight: 70,
        backgroundColor: Colors.white,
        title: const Center(
          child: Text(
            'Penalty Flat',
            style: TextStyle(color: Color.fromARGB(255, 45, 52, 96)),
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
      body: StreamBuilder(
          stream: db.doc("sesion/$sesionId/users/$idMultado").snapshots(),
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
            return StreamBuilder(
                stream: db
                    .doc("sesion/$sesionId/codigoMultas/$multaId")
                    .snapshots(),
                builder: (
                  BuildContext context,
                  AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                      snapshot,
                ) {
                  if (snapshot.hasError) {
                    return ErrorWidget(snapshot.error.toString());
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final multaData = snapshot.data!.data()!;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text("Resumen", style: TiposBlue.title),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("¿Quién?", style: TiposBlue.subtitle),
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4.0),
                                child: DottedBorder(
                                  radius: Radius.circular(8),
                                  borderType: BorderType.Circle,
                                  dashPattern: [5],
                                  color: colors[userData['color']],
                                  strokeWidth: 1,
                                  child: Icon(
                                    Icons.account_circle_rounded,
                                    color: colors[userData['color']],
                                    size: 80,
                                  ),
                                ),
                              ),
                              Text(
                                userData['nombre'],
                                style: TiposBlue.bodyBold,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 40),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Text("¿Que ha hecho?",
                                      style: TiposBlue.subtitle),
                                ),
                                Text("${multaData['titulo']}".capitalize!,
                                    style: TiposBlue.bodyBold),
                                Text("${multaData['descripcion']}".capitalize!,
                                    style: TiposBlue.body),
                                Text("${multaData['precio']}€",
                                    style: TiposBlue.body),
                              ],
                            ),
                          ),
                          Container()
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 40),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "¿Tienes Pruebas?",
                                  style: TiposBlue.subtitle,
                                ),
                                Material(
                                  color: Colors.white.withOpacity(0.0),
                                  child: InkWell(
                                    splashColor:
                                        Theme.of(context).primaryColorLight,
                                    onTap: () async {
                                      final image = await ImagePicker()
                                          .pickImage(
                                              source: ImageSource.camera);
                                      if (image == null) return;
                                      final imageTemporary = File(image.path);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: DottedBorder(
                                        radius: Radius.circular(8),
                                        borderType: BorderType.RRect,
                                        dashPattern: [5],
                                        color: PageColors.blue,
                                        strokeWidth: 0.5,
                                        child: Container(
                                          height: 80,
                                          width: 80,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(
                                              Icons.add_a_photo,
                                              size: 40,
                                              color: Color.fromARGB(
                                                  255, 45, 52, 96),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                  primary: PageColors.blue,
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      side: BorderSide(
                                          color:
                                              Colors.black.withOpacity(0.5))),
                                  minimumSize: const Size(120, 20)),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EscojerMulta(
                                        sesionId: sesionId,
                                        idMultado: idMultado,
                                      ),
                                    ));
                              },
                              child: const Text('Cancelar',
                                  style: TextStyle(fontSize: 15)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                  primary: PageColors.blue,
                                  backgroundColor: PageColors.yellow,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  minimumSize: const Size(120, 25)),
                              onPressed: () async {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    duration: Duration(seconds: 1),
                                    content: Text(
                                        "${userData['nombre']} ha sido multado/a"),
                                  ),
                                );
                                await db
                                    .collection('sesion/$sesionId/multas')
                                    .add({
                                  'titulo': multaData['titulo'],
                                  'descripcion': multaData['descripcion'],
                                  'autorId': user!.uid,
                                  'precio': multaData['precio'],
                                  'nomMultado': userData['nombre'],
                                  'idMultado': userData['id'],
                                  'imagen': imgPath,
                                  'parte': multaData['parte'],
                                  'fecha': dateToday,
                                });
                                 await db.doc('sesion/$sesionId/users/$idMultado').update({
                                  'dinero': userData['dinero']==null ? multaData['precio'] : userData['dinero']+multaData['precio'],
                                });
                                
                               print(idMultado);
                                await Future.delayed(
                                    const Duration(milliseconds: 1000), () {Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          PrincipalScreen(sesionId: sesionId),
                                    ));});
                              },
                              child: const Text('Multar',
                                  style: TextStyle(fontSize: 15)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                });
          }),
     
    );
  }

  
}
