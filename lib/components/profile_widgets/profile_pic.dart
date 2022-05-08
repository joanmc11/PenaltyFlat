import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:penalty_flat_app/models/user.dart';
import 'package:penalty_flat_app/services/sesionProvider.dart';
import 'package:provider/provider.dart';
import '../../../../Styles/colors.dart';

class ProfilePic extends StatefulWidget {
  const ProfilePic({Key? key}) : super(key: key);

  @override
  _ProfilePicState createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
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
    final db = FirebaseFirestore.instance;
    final user = Provider.of<MyUser?>(context);
    final idCasa = Provider.of<SesionProvider?>(context)!.sesionCode;
    final storage = FirebaseStorage.instance;
    return StreamBuilder(
        stream: db.doc("sesion/$idCasa/users/${user?.uid}").snapshots(),
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
          return SizedBox(
            height: 115,
            width: 115,
            child: Stack(
              fit: StackFit.expand,
              clipBehavior: Clip.none,
              children: [
                DottedBorder(
                  borderType: BorderType.Circle,
                  dashPattern: const [5],
                  color: colors[userData['color']],
                  strokeWidth: 1,
                  child: Center(
                    child: userData['imagenPerfil'] == ""
                        ? Icon(
                            Icons.account_circle_rounded,
                            size: 110,
                            color: colors[userData['color']],
                          )
                        : FutureBuilder(
                            future:
                                storage.ref("/images/${userData['imagenPerfil']}").getDownloadURL(),
                            builder: (context, AsyncSnapshot<String> snapshot) {
                              if (!snapshot.hasData) {
                                return const CircularProgressIndicator();
                              }
                              debugPrint(snapshot.data!);
                              return CircleAvatar(
                                radius: 52,
                                backgroundColor: colors[userData['color']],
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundImage: NetworkImage(
                                    snapshot.data!,
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ),
                Positioned(
                  right: -5,
                  bottom: 0,
                  child: SizedBox(
                    height: 36,
                    width: 36,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                          side: BorderSide(color: PageColors.blue),
                        ),
                        primary: PageColors.yellow,
                        backgroundColor: PageColors.blue,
                      ),
                      onPressed: () async {
                        final image = await ImagePicker()
                            .pickImage(source: ImageSource.gallery, imageQuality: 25);
                        if (image == null) return;
                        final imageTemporary = File(image.path);
                        await db.doc('sesion/$idCasa/users/${user?.uid}').update({
                          'imagenPerfil': image.name,
                        });
                        await FirebaseStorage.instance
                            .ref("/images/${image.name}")
                            .putFile(imageTemporary);
                      },
                      child: const Text("+"),
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}
