
// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:penalty_flat_app/Styles/colors.dart';
import 'package:penalty_flat_app/models/usersInside.dart';

class DineroPagamento extends StatelessWidget {
  DineroPagamento({Key? key, required this.userData}) : super(key: key);
  InsideUser userData;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Column(
            children: [
              Text("Tienes que pagar: ", style: TiposBlue.bodyBold),
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
