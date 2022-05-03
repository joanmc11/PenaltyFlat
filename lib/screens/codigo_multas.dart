import 'package:flutter/material.dart';
import 'package:penalty_flat_app/Styles/colors.dart';
import 'package:penalty_flat_app/components/app_bar/penalty_flat_app_bar.dart';
import 'package:penalty_flat_app/components/lista_normas/buscador.dart';
import 'package:penalty_flat_app/components/lista_normas/multas_list.dart';
import 'package:penalty_flat_app/components/lista_normas/zonas_casa.dart';
import 'crearMulta/crear_multa.dart';

class CodigoMultas extends StatefulWidget {
  const CodigoMultas({
    Key? key,
  }) : super(key: key);

  @override
  _CodigoMultasState createState() => _CodigoMultasState();
}

bool edit = false;

class _CodigoMultasState extends State<CodigoMultas> {
  int selectedIndex = 0;
  bool selected = true;
  bool _folded = true;
  bool todas = true;
  String parte = "Todas";
  String search = "";
  bool edit = false;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PenaltyFlatAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(flex: 2, child: ZonasCasa(callbackParte: callbackParte)),
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Buscador(width: 200, callbackSearch: callbackSearch),
                              //Icono per editar multes
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        edit = !edit;
                                      });
                                    },
                                    icon: Icon(
                                      edit ? Icons.edit_off : Icons.edit,
                                      color: PageColors.blue,
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ),
                      MultasList(
                        folded: _folded,
                        search: search,
                        todas: todas,
                        parte: parte,
                        edit: edit,
                      )
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
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CrearMulta(),
              ));
        },
        child: Icon(
          Icons.add,
          color: PageColors.yellow,
        ),
        backgroundColor: PageColors.blue,
        elevation: 2000,
      ),
    );
  }
}
