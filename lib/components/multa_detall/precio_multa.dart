import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:penalty_flat_app/models/multas.dart';
import '../../../Styles/colors.dart';

class PrecioDetail extends StatelessWidget {
  final Multa multaData;
  PrecioDetail({Key? key, required this.multaData}) : super(key: key);
  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Precio a pagar",
          style: TiposBlue.subtitle,
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "${multaData.precio}€",
            style: TiposBlue.title,
          ),
        )
      ],
    );
  }
}
