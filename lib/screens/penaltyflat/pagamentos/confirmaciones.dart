import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:penalty_flat_app/Styles/colors.dart';
import 'package:penalty_flat_app/models/user.dart';
import 'package:penalty_flat_app/screens/multar/poner_multa.dart';
import 'package:penalty_flat_app/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Confirmaciones extends StatefulWidget {
  final String sesionId;
  final String notifyId;
  final String userId;
  const Confirmaciones({
    Key? key,
    required this.sesionId,
    required this.notifyId,
    required this.userId,
  }) : super(key: key);

  @override
  State<Confirmaciones> createState() => _ConfirmacionesState();
}

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

class _ConfirmacionesState extends State<Confirmaciones> {
  bool pagado = false;
  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;
    final user = Provider.of<MyUser?>(context);
    final storage = FirebaseStorage.instance;

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
      body: user == null
          ? const Loading()
          : StreamBuilder(
              stream: db
                  .collection("sesion/${widget.sesionId}/users")
                  .orderBy("color", descending: false)
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
                final allUsers = snapshot.data!.docs;

                return StreamBuilder(
                  stream: db
                      .doc("sesion/${widget.sesionId}/users/${widget.userId}")
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

                    final num totalUsuario = userData['dinero'];

                    return StreamBuilder(
                      stream: db
                          .doc(
                              "sesion/${widget.sesionId}/notificaciones/${widget.notifyId}")
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

                        Map notifyData = {};
                        snapshot.data?.data() != null
                            ? notifyData = snapshot.data!.data()!
                            : notifyData = {};

                        return notifyData.isEmpty
                            ? const Loading()
                            : StreamBuilder(
                                stream: db
                                    .collection(
                                        "sesion/${widget.sesionId}/multas")
                                    .where('fecha',
                                        isLessThan: notifyData['fecha'])
                                    .where("idMultado",
                                        isEqualTo: widget.userId)
                                    .snapshots(),
                                builder: (
                                  BuildContext context,
                                  AsyncSnapshot<
                                          QuerySnapshot<Map<String, dynamic>>>
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
                                  final multasPagadas = snapshot.data!.docs;

                                  if (pagado) {
                                    for (int i = 0;
                                        i < multasPagadas.length;
                                        i++) {
                                      db
                                          .doc(
                                              'sesion/${widget.sesionId}/multas/${multasPagadas[i].id}')
                                          .update({
                                        'pagado': true,
                                      });
                                    }
                                  }

                                  return StreamBuilder(
                                    stream: db
                                        .doc(
                                            "sesion/${widget.sesionId}/users/${user.uid}")
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
                                      final currentUserData =
                                          snapshot.data!.data()!;

                                      return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          DottedBorder(
                                            borderType: BorderType.Circle,
                                            dashPattern: const [5],
                                            color: colors[userData['color']],
                                            strokeWidth: 1,
                                            child: Center(
                                              child: userData['imagenPerfil'] ==
                                                      ""
                                                  ? Icon(
                                                      Icons
                                                          .account_circle_rounded,
                                                      size: 110,
                                                      color: colors[
                                                          userData['color']],
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
                                                        debugPrint(
                                                            snapshot.data!);
                                                        return CircleAvatar(
                                                          radius: 52,
                                                          backgroundColor:
                                                              colors[userData[
                                                                  'color']],
                                                          child: CircleAvatar(
                                                            radius: 50,
                                                            backgroundImage:
                                                                NetworkImage(
                                                              snapshot.data!,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                            ),
                                          ),
                                          Center(
                                            child: Column(
                                              children: [
                                                Text(
                                                    "¿${userData['nombre']} ha pagado su parte?",
                                                    style: TiposBlue.bodyBold),
                                                Text(
                                                  "${totalUsuario.toStringAsFixed(2)}€",
                                                  style: GoogleFonts.nunitoSans(
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            5,
                                                    textStyle: TextStyle(
                                                        color: PageColors.blue,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Row(
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
                                                              primary:
                                                                  PageColors
                                                                      .white),
                                                      child: Text(
                                                        "!No ha pagado!",
                                                        style: TextStyle(
                                                            color: PageColors
                                                                .blue),
                                                      ),
                                                      onPressed: () async {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          const SnackBar(
                                                            duration: Duration(
                                                                seconds: 1),
                                                            content: Text(
                                                                "Pago rechazado"),
                                                          ),
                                                        );
                                                        await db
                                                            .doc(
                                                                'sesion/${widget.sesionId}/users/${widget.userId}')
                                                            .update({
                                                          'contador': 0,
                                                          'pendiente': false,
                                                          'dinero':
                                                              userData['dinero']
                                                        });
                                                        await db
                                                            .doc(
                                                                'sesion/${widget.sesionId}/notificaciones/${widget.notifyId}')
                                                            .update({
                                                          'visto': true,
                                                        });
                                                        await db
                                                            .collection(
                                                                "sesion/${widget.sesionId}/notificaciones")
                                                            .add({
                                                          'mensaje':
                                                              "Tu pago ha sido rechazado por:",
                                                          'subtitulo':
                                                              "${currentUserData['nombre']}",
                                                          'idUsuario':
                                                              widget.userId,
                                                          'fecha': dateToday,
                                                          'tipo': "feedback",
                                                          'visto': false,
                                                        });
                                                        Navigator.pop(context);

                                                        await db
                                                            .doc(
                                                                "sesion/${widget.sesionId}/notificaciones/${widget.notifyId}")
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
                                                                primary:
                                                                    PageColors
                                                                        .yellow),
                                                        child: Text(
                                                          "Confirmar pago",
                                                          style: TextStyle(
                                                              color: PageColors
                                                                  .blue),
                                                        ),
                                                        onPressed: () async {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            const SnackBar(
                                                              duration:
                                                                  Duration(
                                                                      seconds:
                                                                          1),
                                                              content: Text(
                                                                  "Pago confirmado"),
                                                            ),
                                                          );
                                                          setState(() {
                                                            pagado = true;
                                                          });
                                                          await db
                                                              .doc(
                                                                  'sesion/${widget.sesionId}/notificaciones/${widget.notifyId}')
                                                              .update({
                                                            'visto': true,
                                                          });
                                                          await db
                                                              .doc(
                                                                  'sesion/${widget.sesionId}/users/${widget.userId}')
                                                              .update({
                                                            'contador': userData[
                                                                    'contador'] +
                                                                1,
                                                            'pendiente': (userData[
                                                                        'contador'] ==
                                                                    allUsers.length -
                                                                        1)
                                                                ? false
                                                                : true,
                                                            'dinero': (userData[
                                                                        'contador'] ==
                                                                    allUsers.length -
                                                                        1)
                                                                ? 0
                                                                : userData[
                                                                    'dinero']
                                                          });

                                                          if (userData[
                                                                  'contador'] ==
                                                              allUsers.length) {
                                                            await db
                                                                .collection(
                                                                    "sesion/${widget.sesionId}/notificaciones")
                                                                .add({
                                                              'mensaje':
                                                                  "Tu pago ha sido aceptado",
                                                              'subtitulo':
                                                                  "Tus compañeros lo han confirmado",
                                                              'idUsuario':
                                                                  widget.userId,
                                                              'fecha':
                                                                  dateToday,
                                                              'tipo':
                                                                  "feedback",
                                                              'visto': false,
                                                            });
                                                          }

                                                          Navigator.pop(
                                                              context);
                                                          await db
                                                              .doc(
                                                                  "sesion/${widget.sesionId}/notificaciones/${widget.notifyId}")
                                                              .delete();
                                                        }),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
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
