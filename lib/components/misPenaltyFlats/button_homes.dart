
import 'package:flutter/material.dart';
import '../../Styles/colors.dart';

class ButtonHomes extends StatelessWidget {
  const ButtonHomes({
    Key? key,
    required this.titulo,
    required this.destination,
  }) : super(key: key);

  final String titulo;
  final Widget destination;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(primary: PageColors.yellow),
      child: Text(
        titulo,
        style: TextStyle(color: PageColors.blue),
      ),
      onPressed: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => destination),
        );
      },
    );
  }
}