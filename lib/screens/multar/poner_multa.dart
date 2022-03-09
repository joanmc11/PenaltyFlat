import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:penalty_flat_app/Styles/colors.dart';
import 'package:penalty_flat_app/screens/penaltyflat/principal.dart';
import 'package:penalty_flat_app/shared/multaScreen.dart';
import 'package:provider/provider.dart';
import 'package:string_extensions/string_extensions.dart';

import 'package:dotted_border/dotted_border.dart';

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
final List<Color> colors = [
  Colors.blue,
  Colors.red,
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
  Colors.yellow,
];
bool multado = false;

const String imgPath = "";
DateTime dateToday = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
    DateTime.now().hour,
    DateTime.now().minute,
    DateTime.now().second);

class _PonerMultaState extends State<PonerMulta> {
  @override
  Widget build(BuildContext context) {
    final storage = FirebaseStorage.instance;
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
                stream: db
                    .doc("sesion/${widget.sesionId}/users/${widget.idMultado}")
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
                  final userData = snapshot.data!.data()!;
                  return StreamBuilder(
                      stream: db
                          .doc(
                              "sesion/${widget.sesionId}/codigoMultas/${widget.multaId}")
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
                          return const Center(
                              child: CircularProgressIndicator());
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
                                      padding:
                                          const EdgeInsets.only(bottom: 4.0),
                                      child: DottedBorder(
                                        radius: const Radius.circular(8),
                                        borderType: BorderType.Circle,
                                        dashPattern: [5],
                                        color: colors[userData['color']],
                                        strokeWidth: 1,
                                        child: userData['imagenPerfil'] == ""
                                            ? Icon(
                                                Icons.account_circle_rounded,
                                                color:
                                                    colors[userData['color']],
                                                size: 80,
                                              )
                                            : FutureBuilder(
                                                future: storage
                                                    .ref(
                                                        "/images/${userData['imagenPerfil']}")
                                                    .getDownloadURL(),
                                                builder: (context,
                                                    AsyncSnapshot<String>
                                                        snapshot) {
                                                  if (!snapshot.hasData) {
                                                    return const CircularProgressIndicator();
                                                  }
                                                  debugPrint(snapshot.data!);
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: CircleAvatar(
                                                      radius: 38,
                                                      backgroundColor: colors[
                                                          userData['color']],
                                                      child: CircleAvatar(
                                                        radius: 37,
                                                        backgroundImage:
                                                            NetworkImage(
                                                          snapshot.data!,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child: Text("¿Que ha hecho?",
                                            style: TiposBlue.subtitle),
                                      ),
                                      Text("${multaData['titulo']}".capitalize!,
                                          style: TiposBlue.bodyBold),
                                      Text(
                                          "${multaData['descripcion']}"
                                              .capitalize!,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "¿Tienes Pruebas?",
                                        style: TiposBlue.subtitle,
                                      ),
                                      Material(
                                        color: Colors.white.withOpacity(0.0),
                                        child: InkWell(
                                          splashColor: Theme.of(context)
                                              .primaryColorLight,
                                          onTap: () async {
                                            final image = await ImagePicker()
                                                .pickImage(
                                                    source: ImageSource.camera);
                                            if (image == null) return;
                                            final imageTemporary =
                                                File(image.path);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: DottedBorder(
                                              radius: const Radius.circular(8),
                                              borderType: BorderType.RRect,
                                              dashPattern: const [5],
                                              color: PageColors.blue,
                                              strokeWidth: 0.5,
                                              child: SizedBox(
                                                height: 80,
                                                width: 80,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Icon(
                                                    Icons.add_a_photo,
                                                    size: 40,
                                                    color: PageColors.blue,
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
                                                const BorderRadius.all(
                                                    Radius.circular(10)),
                                            side: BorderSide(
                                                color: Colors.black
                                                    .withOpacity(0.5))),
                                        minimumSize: const Size(120, 20)),
                                    onPressed: () {
                                      Navigator.pop(context);
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
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        minimumSize: const Size(120, 25)),
                                    onPressed: () async {
                                      var multaActual= await db
                                          .collection(
                                              'sesion/${widget.sesionId}/multas')
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
                                      await db
                                          .doc(
                                              'sesion/${widget.sesionId}/users/${widget.idMultado}')
                                          .update({
                                        'dinero': userData['dinero'] == null
                                            ? multaData['precio']
                                            : userData['dinero'] +
                                                multaData['precio'],
                                      });
                                      await db
                                          .collection(
                                              'sesion/${widget.sesionId}/notificaciones')
                                          .add({
                                        
                                        'subtitulo': multaData['titulo'],
                                        'idMulta': multaActual.id,
                                        'idUsuario': userData['id'],
                                        'tipo': "multa",
                                        'fecha': dateToday,
                                      });
                                      setState(() {
                                        multado = true;
                                      });

                                      print(widget.idMultado);
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
