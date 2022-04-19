import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:icon_badge/icon_badge.dart';
import 'package:penalty_flat_app/Styles/colors.dart';
import 'package:penalty_flat_app/components/app_bar_title.dart';
import 'package:penalty_flat_app/components/lista_normas/buscador.dart';
import 'package:penalty_flat_app/components/lista_normas/multas_list.dart';
import 'package:penalty_flat_app/components/lista_normas/zonas_casa.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import 'crearMulta/crear_multa.dart';
import 'notifications.dart';

class CodigoMultas extends StatefulWidget {
  final String sesionId;
  const CodigoMultas({
    Key? key,
    required this.sesionId,
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
    final user = Provider.of<MyUser?>(context);
    final db = FirebaseFirestore.instance;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: PageColors.blue,
          onPressed: () async {
            Navigator.pop(context);
          },
        ),
        toolbarHeight: 70,
        backgroundColor: Colors.white,
        title: const AppBarTitle(),
        actions: <Widget>[
          StreamBuilder(
              stream: db
                  .collection("sesion/${widget.sesionId}/notificaciones")
                  .where('idUsuario', isEqualTo: user?.uid)
                  .where('visto', isEqualTo: false)
                  .snapshots(),
              builder: (
                BuildContext context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
              ) {
                if (snapshot.hasError) {
                  return ErrorWidget(snapshot.error.toString());
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final notifyData = snapshot.data!.docs;

                return IconBadge(
                  icon: Icon(
                    Icons.notifications_none_outlined,
                    color: PageColors.blue,
                    size: 35,
                  ),
                  itemCount: notifyData.length,
                  badgeColor: Colors.red,
                  itemColor: Colors.white,
                  hideZero: true,
                  top: 11,
                  right: 9,
                  onTap: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => Notificaciones(sesionId: widget.sesionId)),
                    );
                  },
                );
              }),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                  flex: 2,
                  child: ZonasCasa(sesionId: widget.sesionId, callbackParte: callbackParte)),
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
                          sesionId: widget.sesionId,
                          folded: _folded,
                          search: search,
                          todas: todas,
                          parte: parte,
                          edit: edit)
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
                builder: (context) => CrearMulta(
                  sesionId: widget.sesionId,
                ),
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
