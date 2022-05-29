// ignore_for_file: file_names

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:penalty_flat_app/Styles/colors.dart';
import 'package:penalty_flat_app/components/image_builder.dart';
import 'package:penalty_flat_app/models/colors_model.dart';
import 'package:penalty_flat_app/screens/multar/escojer_multa.dart';

class ImageMultar extends StatelessWidget {
  final dynamic userData;
  const ImageMultar({Key? key, required this.userData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = UserColors().colors;
    return Material(
      color: Colors.white.withOpacity(0.0),
      child: InkWell(
        splashColor: Theme.of(context).primaryColorLight,
        onTap: () {
          Future.delayed(const Duration(milliseconds: 200));
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EscojerMulta(idMultado: userData.id),
            ),
          );
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
              color: colors[userData.color],
              strokeWidth: 1,
                 padding: const EdgeInsets.all(6),
              child: userData.imagenPerfil == ""
                  ? Icon(
                      Icons.account_circle_rounded,
                      size: 85,
                      color: colors[userData.color],
                    )
                  : UserProfileImage(userData: userData, size: 42,),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                userData.nombre,
                style: TiposBlue.bodyBold,
              ),
            )
          ],
        ),
      ),
    );
  }
}
