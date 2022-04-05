import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:penalty_flat_app/screens/multar/poner_multa.dart';
import 'package:penalty_flat_app/shared/loading.dart';
import 'package:provider/provider.dart';
import '../../../Styles/colors.dart';
import '../../../models/user.dart';
import 'package:string_extensions/string_extensions.dart';

class MultaDetall extends StatelessWidget {
  final String sesionId;
  final String idMulta;
  final String idMultado;
  final String notifyId;
  MultaDetall({
    Key? key,
    required this.sesionId,
    required this.idMulta,
    required this.idMultado,
    required this.notifyId,
  }) : super(key: key);
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

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    final storage = FirebaseStorage.instance;
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: PageColors.blue,
            onPressed: () async {
              Navigator.pop(context);
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
        body: StreamBuilder(
          stream: db.doc("sesion/$sesionId/multas/$idMulta").snapshots(),
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
            Map multaData = {};
            snapshot.data?.data() != null
                ? multaData = snapshot.data!.data()!
                : multaData = {};

            return multaData.isEmpty
                ? const Loading()
                : StreamBuilder(
                    stream: db
                        .doc("sesion/$sesionId/users/${user!.uid}")
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
                      return Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Center(
                                  child: multaData['idMultado'] == user.uid
                                      ? Text("¡Te han pillado!",
                                          style: TiposBlue.title)
                                      : Text(
                                          "¡Han pillado a ${multaData['nomMultado']}!",
                                          style: TiposBlue.title,
                                        ),
                                ),
                              ),
                              StreamBuilder(
                                stream: db
                                    .doc("sesion/$sesionId/users/$idMultado")
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
                                  final userData = snapshot.data!.data()!;

                                  return Center(
                                    child: DottedBorder(
                                      borderType: BorderType.Circle,
                                      dashPattern: const [5],
                                      color: colors[userData['color']],
                                      strokeWidth: 1,
                                      child: userData['imagenPerfil'] == ""
                                          ? Icon(
                                              Icons.account_circle_rounded,
                                              size: 85,
                                              color: colors[userData['color']],
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
                                                      const EdgeInsets.all(5.0),
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
                                  );
                                },
                              ),
                              Expanded(
                                flex: 4,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          multaData['idMultado'] == user.uid
                                              ? "¿Qué has hecho?"
                                              : "¿Qué ha hecho?",
                                          style: TiposBlue.subtitle,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: PageColors.blue
                                                  .withOpacity(0.2),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${multaData['titulo']}"
                                                        .capitalize!,
                                                    style: TiposBlue.bodyBold,
                                                  ),
                                                  Text(
                                                    "${multaData['descripcion']}"
                                                        .capitalize!,
                                                    style: TiposBlue.body,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Pruebas",
                                          style: TiposBlue.subtitle,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: multaData['imagen'] == ""
                                              ? Text(
                                                  "No se dispone de pruebas",
                                                  style: TiposBlue.body,
                                                )
                                              : const Text("Imagen aquí"),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Sale a Pagar",
                                          style: TiposBlue.subtitle,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Text(
                                            "${multaData['precio']}€",
                                            style: TiposBlue.title,
                                          ),
                                        )
                                      ],
                                    ),
                                    !multaData['aceptada']
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 10.0),
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            primary: PageColors
                                                                .white),
                                                    child: Text(
                                                      "Rechazar",
                                                      style: TextStyle(
                                                          color:
                                                              PageColors.blue),
                                                    ),
                                                    onPressed: () async {
                                                      await db
                                                          .collection(
                                                              'sesion/$sesionId/notificaciones')
                                                          .add({
                                                        'fecha': dateToday,
                                                        'tipo': "feedback",
                                                        'mensaje':
                                                            "${userData['nombre']} ha rechazado la multa",
                                                        'subtitulo':
                                                            multaData['titulo'],
                                                        'visto': false,
                                                        'idUsuario': multaData[
                                                            'autorId'],
                                                      });
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                          duration: Duration(
                                                              seconds: 2),
                                                          content: Text(
                                                              "Multa rechazada"),
                                                        ),
                                                      );
                                                      Navigator.pop(context);
                                                      await db
                                                          .doc(
                                                              "sesion/$sesionId/multas/$idMulta")
                                                          .delete();
                                                      await db
                                                          .doc(
                                                              "sesion/$sesionId/notificaciones/$notifyId")
                                                          .delete();
                                                    },
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0),
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            primary: PageColors
                                                                .yellow),
                                                    child: Text(
                                                      "Aceptar",
                                                      style: TextStyle(
                                                          color:
                                                              PageColors.blue),
                                                    ),
                                                    onPressed: () async {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                          duration: Duration(
                                                              seconds: 2),
                                                          content: Text(
                                                              "Multa aceptada"),
                                                        ),
                                                      );
                                                      await db
                                                          .doc(
                                                              'sesion/$sesionId/multas/$idMulta')
                                                          .update({
                                                        'aceptada': true,
                                                      });
                                                      await db
                                                          .doc(
                                                              'sesion/$sesionId/users/${user.uid}')
                                                          .update({
                                                        'dinero': userData[
                                                                    'dinero'] ==
                                                                null
                                                            ? multaData[
                                                                'precio']
                                                            : userData[
                                                                    'dinero'] +
                                                                multaData[
                                                                    'precio'],
                                                      });
                                                      await db
                                                          .collection(
                                                              'sesion/$sesionId/notificaciones')
                                                          .add({
                                                        'fecha': dateToday,
                                                        'tipo': "feedback",
                                                        'mensaje':
                                                            "${userData['nombre']} ha aceptado la multa",
                                                        'subtitulo':
                                                            multaData['titulo'],
                                                        'visto': false,
                                                        'idUsuario': multaData[
                                                            'autorId'],
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : multaData['pagado']
                                            ? const Center(
                                                child: Text(
                                                "Multa pagada",
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
                                              ))
                                            : const Center(
                                                child: Text(
                                                "Multa por pagar",
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
                                              ))
                                  ],
                                ),
                              ),
                            ]),
                      );
                    },
                  );
          },
        ));
  }
}
