import 'dart:io';
import 'package:flutter/material.dart';
import 'package:penalty_flat_app/Styles/colors.dart';
import 'package:penalty_flat_app/models/codigo_multas.dart';
import 'package:penalty_flat_app/models/usersInside.dart';
import 'package:penalty_flat_app/services/database.dart';
import 'package:penalty_flat_app/services/sesionProvider.dart';
import 'package:provider/provider.dart';
import '../../models/user.dart';

class BotonesMultar extends StatelessWidget {
  final String idMultado;
  final String multaId;
  final Function callbackMultado;
  final String imgName;
  final File? imgFile;
  const BotonesMultar(
      {Key? key,
      required this.idMultado,
      required this.multaId,
      required this.callbackMultado,
      required this.imgName,
      required this.imgFile})
      : super(key: key);

 

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    final idCasa = Provider.of<SesionProvider?>(context)!.sesionCode;
    return StreamBuilder(
      stream: singleUserData(idCasa, idMultado),
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
            final userData = snapshot.data!;
            return StreamBuilder(
                stream: singleNormaSnapshot(idCasa, multaId),
                builder: (
                  BuildContext context,
                  AsyncSnapshot<CodigoMultas> snapshot,
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
                      final multaData = snapshot.data!;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                  primary: PageColors.blue,
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      side: BorderSide(
                                          color:
                                              Colors.black.withOpacity(0.5))),
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
                                DatabaseService(uid: user!.uid).ponerMulta(
                                    multaData,
                                    userData,
                                    imgName,
                                    imgFile,
                                    idCasa);
                                callbackMultado(true);
                              },
                              child: const Text('Multar',
                                  style: TextStyle(fontSize: 15)),
                            ),
                          ),
                        ],
                      );
                  }
                });
        }
      },
    );
  }
}
