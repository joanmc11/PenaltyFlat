import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:icon_badge/icon_badge.dart';
import 'package:penalty_flat_app/Styles/colors.dart';
import 'package:penalty_flat_app/components/app_bar_title.dart';
import 'package:penalty_flat_app/components/llista_multas/botones_propio.dart';
import 'package:penalty_flat_app/components/llista_multas/multas_list.dart';
import 'package:penalty_flat_app/components/llista_multas/select_meses.dart';
import 'package:penalty_flat_app/components/penalty_flat_app_bar.dart';
import 'package:provider/provider.dart';
import '../../models/user.dart';
import '../notifications.dart';

class PantallaMultas extends StatefulWidget {
  final String sesionId;

  const PantallaMultas({
    Key? key,
    required this.sesionId,
  }) : super(key: key);

  @override
  _PantallaMultasState createState() => _PantallaMultasState();
}

class _PantallaMultasState extends State<PantallaMultas> {
  String selectedMonth = "Todas";
  int monthValue = 0;
  int yearValue = 0;
  bool mount = true;
  bool selected = true;
  int currentIndex = 0;

  callbackMes(varSelectedMonth, varMonth, varYear, varIndex) {
    setState(() {
      selectedMonth = varSelectedMonth;
      monthValue = varMonth;
      yearValue = varYear;
      currentIndex = varIndex;
    });
  }

  callbackButton(varSelected) {
    setState(() {
      selected = varSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PenaltyFlatAppBar(sesionId: widget.sesionId),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text("Multas de: ", style: TiposBlue.title),
          ),
          SelectMeses(sesionId: widget.sesionId, callbackMes: callbackMes),
          /* Padding(
            padding: const EdgeInsets.only(bottom: 8.0, top: 4.0),
            child: IconButton(
                icon: Icon(Icons.calendar_month, color: PageColors.blue),
                onPressed: () async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Calendario(
                          sesionId: widget.sesionId,
                        ),
                      ));
                },
                iconSize: 40),
          ),*/
          const Padding(padding: EdgeInsets.only(bottom: 8.0, top: 4.0)),
          ButtonPropio(callbackButton: callbackButton),
          ListaMultasUsuarios(
              sesionId: widget.sesionId,
              monthValue: monthValue,
              selectedMonth: selectedMonth,
              yearValue: yearValue,
              selected: selected,
              currentIndex: currentIndex)
        ],
      ),
    );
  }
}
