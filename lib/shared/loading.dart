import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:penalty_flat_app/Styles/colors.dart';


class Loading extends StatelessWidget {
  const Loading({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: PageColors.yellow,
      child: Center(child: SpinKitChasingDots(color: PageColors.blue, size: 50.0,)),
      
    );
  }
}