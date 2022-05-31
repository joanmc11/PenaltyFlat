import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:penalty_flat_app/Styles/colors.dart';
import 'package:penalty_flat_app/models/usersInside.dart';

class CantidadConfirmacion extends StatelessWidget {
  final String userId;
  final InsideUser userData;
  const CantidadConfirmacion({
    Key? key,
    required this.userId,
    required this.userData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Column(
            children: [
              Text("¿${userData.nombre} ha pagado su parte?",
                  style: TiposBlue.bodyBold),
              Text(
                "${userData.dinero.toStringAsFixed(2)}€",
                style: GoogleFonts.nunitoSans(
                  fontSize: MediaQuery.of(context).size.width / 5,
                  textStyle: TextStyle(
                      color: PageColors.blue, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
