import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:penalty_flat_app/models/colors_model.dart';
import 'package:penalty_flat_app/models/usersInside.dart';
import 'package:penalty_flat_app/services/sesionProvider.dart';
import 'package:provider/provider.dart';

class ImagenMultado extends StatelessWidget {
  final String idMultado;
  ImagenMultado({
    Key? key,
    required this.idMultado,
  }) : super(key: key);
  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final storage = FirebaseStorage.instance;
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
            return Center(
              child: DottedBorder(
                borderType: BorderType.Circle,
                dashPattern: const [5],
                color: UserColors().colors[userData.color.toInt()],
                strokeWidth: 1,
                child: userData.imagenPerfil == ""
                    ? Icon(
                        Icons.account_circle_rounded,
                        size: 85,
                        color: UserColors().colors[userData.color.toInt()],
                      )
                    : FutureBuilder(
                        future: storage
                            .ref("/images/${userData.imagenPerfil}")
                            .getDownloadURL(),
                        builder: (context, AsyncSnapshot<String> snapshot) {
                          if (!snapshot.hasData) {
                            return const CircularProgressIndicator();
                          }
                          debugPrint(snapshot.data!);
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: CircleAvatar(
                              radius: 38,
                              backgroundColor:
                                  UserColors().colors[userData.color.toInt()],
                              child: CircleAvatar(
                                radius: 37,
                                backgroundImage: NetworkImage(
                                  snapshot.data!,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            );
        }
      },
    );
  }
}
