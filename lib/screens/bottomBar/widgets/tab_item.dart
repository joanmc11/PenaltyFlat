import 'package:flutter/material.dart';
import 'package:penalty_flat_app/Styles/colors.dart';

class TabItem extends StatelessWidget {
  final IconData icon;
  const TabItem({Key? key, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 14, 22, 14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: PageColors.yellow,
          ),
        ],
      ),
    );
  }
}
