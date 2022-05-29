import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:penalty_flat_app/models/colors_model.dart';
import 'package:penalty_flat_app/models/usersInside.dart';

class UserProfileImage extends StatelessWidget {
  const UserProfileImage({
    Key? key,
    required this.userData,
    required this.size,
  }) : super(key: key);

  final InsideUser userData;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = UserColors().colors;
    final storage = FirebaseStorage.instance;
    return FutureBuilder(
      future: storage.ref("/images/${userData.imagenPerfil}").getDownloadURL(),
      builder: (context, AsyncSnapshot<String> snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }
        debugPrint(snapshot.data!);
        return CircleAvatar(
          radius: size,
          backgroundColor: colors[userData.color.toInt()],
          child: CircleAvatar(
            radius: size-2,
            backgroundImage: NetworkImage(
              snapshot.data!,
            ),
          ),
        );
      },
    );
  }
}
