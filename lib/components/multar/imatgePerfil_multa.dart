// ignore_for_file: file_names

import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:penalty_flat_app/Styles/colors.dart';
import 'package:penalty_flat_app/screens/multar/escojer_multa.dart';

class ImageMultar extends StatelessWidget {
  final String sesionId;
  final dynamic userData;
   ImageMultar({ Key? key, required this.sesionId, required this.userData }) : super(key: key);

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
    final storage = FirebaseStorage.instance;
    return Material(
                          color: Colors.white.withOpacity(0.0),
                          child: InkWell(
                            splashColor: Theme.of(context).primaryColorLight,
                            onTap: () {
                              
                              Future.delayed(const Duration(milliseconds: 200));
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EscojerMulta(
                                      sesionId: sesionId,
                                      idMultado: userData.id,
                                    ),
                                  ));
                            },
                            child: Column(
                              children: [
                                /*Image.memory(
                          (app as ApplicationWithIcon).icon,
                          width: 40,
                          height: 40,
                        ),*/
                                DottedBorder(
                                  borderType: BorderType.Circle,
                                  dashPattern: const [5],
                                  color: colors[userData['color']],
                                  strokeWidth: 1,
                                  child: userData['imagenPerfil'] == ""
                                      ? Icon(
                                          Icons.account_circle_rounded,
                                          size: 85,
                                          color:
                                              colors[userData['color']],
                                        )
                                      : FutureBuilder(
                                          future: storage
                                              .ref(
                                                  "/images/${userData['imagenPerfil']}")
                                              .getDownloadURL(),
                                          builder: (context,
                                              AsyncSnapshot<String> snapshot) {
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
                                                  backgroundImage: NetworkImage(
                                                    snapshot.data!,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    userData['nombre'],
                                    style: TiposBlue.bodyBold,
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
  }
}