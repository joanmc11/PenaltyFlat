
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:penalty_flat_app/models/colors_model.dart';
import 'package:penalty_flat_app/models/usersInside.dart';
class ImagenConfirmacion extends StatelessWidget {
  final InsideUser userData;
  const ImagenConfirmacion({
    Key? key,
    required this.userData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = UserColors().colors;
    final storage = FirebaseStorage.instance;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        DottedBorder(
          borderType: BorderType.Circle,
          dashPattern: const [5],
          color: colors[userData.color.toInt()],
          strokeWidth: 1,
          child: Center(
            child: userData.imagenPerfil == ""
                ? Icon(
                    Icons.account_circle_rounded,
                    size: 110,
                    color: colors[userData.color.toInt()],
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
                      return CircleAvatar(
                        radius: 52,
                        backgroundColor: colors[userData.color.toInt()],
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
      ],
    );
  }
}
