import 'package:flutter/material.dart';
import 'package:penalty_flat_app/Styles/colors.dart';

class AppBarTitle extends StatelessWidget {
  const AppBarTitle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/LogoCabecera.png',
            height: 70,
            width: 70,
          ),
          Text(
            'PENALTY FLAT',
            style: TextStyle(
              fontFamily: 'BasierCircle',
              fontSize: 18,
              color: PageColors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
