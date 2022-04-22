import 'package:flutter/material.dart';
import 'package:penalty_flat_app/Styles/colors.dart';
import 'package:penalty_flat_app/components/multar/user_grid.dart';

class PersonaMultada extends StatelessWidget {
  final String sesionId;
  const PersonaMultada({Key? key, required this.sesionId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20.0, bottom: 50.0),
          child: Center(
              child: Text("¿A quién has pillado?", style: TiposBlue.title)),
        ),
        UserGrid(sesionId: sesionId)
      ],
    );
  }
}
