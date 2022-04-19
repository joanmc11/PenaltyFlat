import 'package:flutter/material.dart';
import 'package:penalty_flat_app/Styles/colors.dart';
import 'package:penalty_flat_app/screens/multar/usuario_multa.dart';

class BottomBarButtonPenalty extends StatelessWidget {
  const BottomBarButtonPenalty({
    Key? key,
    required this.sesionId,
  }) : super(key: key);

  final String sesionId;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PersonaMultada(sesionId: sesionId),
            ));
      },
      child: Icon(
        Icons.gavel,
        color: PageColors.yellow,
      ),
      backgroundColor: PageColors.blue,
    );
  }
}