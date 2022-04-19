
import 'package:flutter/material.dart';
import 'package:penalty_flat_app/Styles/colors.dart';
import 'package:penalty_flat_app/components/lista_normas/buscador.dart';
import 'package:penalty_flat_app/components/lista_normas/multas_radioButton.dart';
import 'package:penalty_flat_app/components/lista_normas/zonas_casa.dart';
import 'package:penalty_flat_app/components/penalty_flat_app_bar.dart';
import 'package:penalty_flat_app/screens/multar/poner_multa.dart';
class EscojerMulta extends StatefulWidget {
  final String sesionId;
  final String idMultado;
  const EscojerMulta({Key? key, required this.sesionId, required this.idMultado}) : super(key: key);

  @override
  _EscojerMultaState createState() => _EscojerMultaState();
}

class _EscojerMultaState extends State<EscojerMulta> {
  int selectedIndex = 0;
  bool selected = true;
  bool _folded = true;
  bool todas = true;
  String parte = "Baño";
  String search = "";
  String _site = "";

  callbackParte(String varParte, bool varTodas) {
    setState(() {
      parte = varParte;
      todas = varTodas;
    });
  }

  callbackSearch(String varSearch, bool varFolded) {
    setState(() {
      search = varSearch;
      _folded = varFolded;
    });
  }

  callbackMulta(String varSite) {
    setState(() {
      _site = varSite;
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(parte);
    return Scaffold(
      appBar: PenaltyFlatAppBar(sesionId: widget.sesionId),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                  flex: 2,
                  child: ZonasCasa(
                    sesionId: widget.sesionId,
                    callbackParte: callbackParte,
                  )),
              Expanded(
                flex: 9,
                child: Container(
                  decoration: const BoxDecoration(color: Colors.white),
                  child: Column(
                    children: [
                      Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 30),
                            child: Buscador(width: 250, callbackSearch: callbackSearch),
                          )),
                      MultasRadio(
                          sesionId: widget.sesionId,
                          folded: _folded,
                          search: search,
                          todas: todas,
                          parte: parte,
                          callbackMulta: callbackMulta)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_site != "") {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => PonerMulta(
                    sesionId: widget.sesionId,
                    idMultado: widget.idMultado,
                    multaId: _site,
                  ),
                ));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                duration: Duration(seconds: 1),
                content: Text("Escoje una multa"),
              ),
            );
          }
        },
        child: Icon(
          Icons.navigate_next_rounded,
          color: PageColors.yellow,
        ),
        backgroundColor: PageColors.blue,
        elevation: 2000,
      ),
    );
  }
}
