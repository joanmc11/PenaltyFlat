
import 'package:flutter/material.dart';
import 'package:penalty_flat_app/Styles/colors.dart';
import 'package:penalty_flat_app/components/app_bar/penalty_flat_app_bar.dart';
import '../components/stats/general_stats.dart';
import '../components/stats/own_stats.dart';

class EstadisticaMultas extends StatelessWidget {
  final String sesionId;
  const EstadisticaMultas({Key? key, required this.sesionId}) : super(key: key);
callbackTap(hola){

}
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: PenaltyFlatAppBar(sesionId: sesionId),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Estadisticas generales:",
            style: TiposBlue.subtitle,
          ),
          GeneralStats(sesionId: sesionId),
          Text(
            "Estadisticas propias:",
            style: TiposBlue.subtitle,
          ),
          OwnStats(sesionId: sesionId),
        ],
      ),
   
    );
  }

}
