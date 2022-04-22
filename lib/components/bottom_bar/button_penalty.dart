import 'package:flutter/material.dart';
import 'package:penalty_flat_app/Styles/colors.dart';

class BottomBarButtonPenalty extends StatelessWidget {
  const BottomBarButtonPenalty({
    Key? key,
    required this.sesionId,
    required this.callbackTap,
    required this.callbackSelected,
    required this.multa,
  }) : super(key: key);

  final String sesionId;
  final Function callbackTap;
  final Function callbackSelected;
  final bool multa;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        callbackTap(1);
        callbackSelected(false, true, false);
      },
      child: Icon(
        Icons.gavel,
        color: multa? PageColors.blue:PageColors.yellow,
      ),
      backgroundColor: multa? PageColors.yellow: PageColors.blue,
    );
  }
}
