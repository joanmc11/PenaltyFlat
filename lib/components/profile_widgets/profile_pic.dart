// ignore_for_file: must_be_immutable

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:penalty_flat_app/components/image_builder.dart';
import 'package:penalty_flat_app/models/colors_model.dart';
import 'package:penalty_flat_app/models/user.dart';
import 'package:penalty_flat_app/models/usersInside.dart';
import 'package:penalty_flat_app/services/database.dart';
import 'package:penalty_flat_app/services/sesionProvider.dart';
import 'package:provider/provider.dart';
import '../../../../Styles/colors.dart';

class ProfilePic extends StatelessWidget {
  ProfilePic({Key? key, required this.userData}) : super(key: key);
  InsideUser userData;

  @override
  Widget build(BuildContext context) {
    final colors = UserColors().colors;
    final user = Provider.of<MyUser?>(context);
    final idCasa = Provider.of<SesionProvider?>(context)!.sesionCode;

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
            color: colors[userData.color.toInt()],
            strokeWidth: 1,
            child: Center(
              child: userData.imagenPerfil == ""
                  ? Icon(
                      Icons.account_circle_rounded,
                      size: 110,
                      color: colors[userData.color.toInt()],
                    )
                  : UserProfileImage(
                      userData: userData,
                      size: 52,
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
                  DatabaseService(uid: user!.uid).changeProfileImage(idCasa, context);
                },
                child: const Text("+"),
              ),
            ),
          )
        ],
      ),
    );
  }
}
