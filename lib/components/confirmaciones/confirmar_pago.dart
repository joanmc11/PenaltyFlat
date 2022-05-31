import 'package:flutter/material.dart';
import 'package:penalty_flat_app/Styles/colors.dart';
import 'package:penalty_flat_app/models/multas.dart';
import 'package:penalty_flat_app/models/user.dart';
import 'package:penalty_flat_app/models/usersInside.dart';
import 'package:penalty_flat_app/services/database.dart';
import 'package:penalty_flat_app/services/sesionProvider.dart';
import 'package:penalty_flat_app/shared/loading.dart';
import 'package:provider/provider.dart';

class BotonesConfirmacion extends StatefulWidget {
  final String notifyId;
  final String userId;
  final InsideUser userData;
  const BotonesConfirmacion({
    Key? key,
    required this.notifyId,
    required this.userId,
    required this.userData,
  }) : super(key: key);

  @override
  State<BotonesConfirmacion> createState() => _BotonesConfirmacionState();
}

class _BotonesConfirmacionState extends State<BotonesConfirmacion> {
  bool pagado = false;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    final idCasa = Provider.of<SesionProvider?>(context)!.sesionCode;

    return StreamBuilder(
      stream: simpleUsersSnapshot(idCasa),
      builder: (
        BuildContext context,
        AsyncSnapshot<List<InsideUser>> snapshot,
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
            final allUsers = snapshot.data!;

            return StreamBuilder(
              stream: simpleUsersSnapshot(idCasa),
              builder: (
                BuildContext context,
                AsyncSnapshot<List<InsideUser>> snapshot,
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
                    final notifyData = snapshot.data!;

                    /* Map notifyData = {};
                snapshot.data?.data() != null
                    ? notifyData = snapshot.data!.data()!
                    : notifyData = {};*/

                    return notifyData.isEmpty
                        ? const Loading()
                        : StreamBuilder(
                            stream: multasAceptadas(idCasa),
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
                                  final multasPagadas = snapshot.data!;

                                  if (pagado) {
                                    DatabaseService(uid: user!.uid)
                                        .multasPagadas(multasPagadas, idCasa);
                                  }

                                  return StreamBuilder(
                                    stream: singleUserData(idCasa, user!.uid),
                                    builder: (
                                      BuildContext context,
                                      AsyncSnapshot<InsideUser> snapshot,
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
                                          final currentUserData =
                                              snapshot.data!;

                                          return Padding(
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
                                                        DatabaseService(
                                                                uid: user.uid)
                                                            .rechazarPago(
                                                          idCasa,
                                                          context,
                                                          widget.userData,
                                                          widget.userId,
                                                          currentUserData,
                                                          widget.notifyId,
                                                        );
                                                        Navigator.pop(context);
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
                                                          setState(() {
                                                            pagado = true;
                                                          });
                                                          DatabaseService(
                                                                  uid: user.uid)
                                                              .aceptarPago(
                                                            idCasa,
                                                            context,
                                                            widget.userData,
                                                            widget.userId,
                                                            currentUserData,
                                                            widget.notifyId,
                                                            allUsers,
                                                          );
                                                        }),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                      }
                                    },
                                  );
                              }
                            },
                          );
                }
              },
            );
        }
      },
    );
  }
}
