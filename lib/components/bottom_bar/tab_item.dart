import 'package:flutter/material.dart';
import 'package:penalty_flat_app/Styles/colors.dart';

class TabItem extends StatelessWidget {
  final IconData icon;
  final bool currentItem;
  const TabItem({Key? key, required this.icon, required this.currentItem}) : super(key: key);

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
            size: 28
          ),
          Padding(
            padding: const EdgeInsets.only(top:2.0),
            child: Container(width: 20, height: 1.5, color: currentItem? PageColors.yellow: null,),
          )
        ],
      ),
    );
  }
}
