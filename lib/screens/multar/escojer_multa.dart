import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:icon_badge/icon_badge.dart';
import 'package:penalty_flat_app/Styles/colors.dart';
import 'package:penalty_flat_app/screens/multar/poner_multa.dart';
import 'package:penalty_flat_app/screens/multar/usuario_multa.dart';
import 'package:provider/provider.dart';
import 'package:string_extensions/string_extensions.dart';

import '../../models/user.dart';
import '../penaltyflat/notifications/notifications.dart';

class EscojerMulta extends StatefulWidget {
  final String sesionId;
  final String idMultado;
  const EscojerMulta(
      {Key? key, required this.sesionId, required this.idMultado})
      : super(key: key);

  @override
  _EscojerMultaState createState() => _EscojerMultaState();
}

class _EscojerMultaState extends State<EscojerMulta> {
  int selectedIndex = 0;
  bool selected = true;
  bool _folded = true;
  bool todas = true;
  String parte = "Todas";
  String search = "";
  String _site = "";
  bool edit = false;

  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;
    final user = Provider.of<MyUser?>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: PageColors.blue,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        toolbarHeight: 70,
        backgroundColor: Colors.white,
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/LogoCabecera.png',
                height: 70,
                width: 70,
              ),
              Text('PENALTY FLAT',
                  style: TextStyle(
                      fontFamily: 'BasierCircle',
                      fontSize: 18,
                      color: PageColors.blue,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ),
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
                          builder: (context) =>
                              Notificaciones(sesionId: widget.sesionId)),
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
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                      color: PageColors.blue,
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(20))),
                  //Lista Partes Casa
                  child: StreamBuilder(
                      stream: db.doc("sesion/${widget.sesionId}").snapshots(),
                      builder: (
                        BuildContext context,
                        AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                            snapshot,
                      ) {
                        if (snapshot.hasError) {
                          return ErrorWidget(snapshot.error.toString());
                        }
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        final casaData = snapshot.data!.data()!;

                        return ListView.separated(
                          itemCount: casaData['partes'].length,
                          separatorBuilder: (
                            BuildContext context,
                            int index,
                          ) {
                            return const SizedBox(height: 10);
                          },
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedIndex = index;
                                  parte = casaData['partes'][index];
                                  parte == "Todas"
                                      ? todas = true
                                      : todas = false;
                                });
                              },
                              child: SingleChildScrollView(
                                child: Row(
                                  children: [
                                    AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      height: (selectedIndex == index ? 40 : 0),
                                      width: 2,
                                      color: PageColors.yellow,
                                    ),
                                    Expanded(
                                      child: RotatedBox(
                                        quarterTurns: 3,
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: 50,
                                          decoration: BoxDecoration(
                                              color: (selectedIndex == index)
                                                  ? Colors.blueGrey
                                                      .withOpacity(0.15)
                                                  : Colors.transparent,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10))),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 0, horizontal: 5),
                                            child: Text(
                                                casaData['partes'][index],
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  color: PageColors.yellow,
                                                  fontWeight:
                                                      (selectedIndex == index
                                                          ? FontWeight.bold
                                                          : FontWeight.normal),
                                                )),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }),
                ),
              ),
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
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 400),
                            width: _folded ? 56 : 250,
                            alignment: Alignment.bottomRight,
                            height: 56,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                              boxShadow: kElevationToShadow[1],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.only(left: 16),
                                    child: !_folded
                                        ? TextField(
                                            decoration: InputDecoration(
                                                hintText: 'Busca una multa',
                                                hintStyle: TextStyle(
                                                  color: PageColors.blue,
                                                ),
                                                border: InputBorder.none),
                                            onChanged: (value) {
                                              setState(() {
                                                search = value;
                                              });
                                              // debugPrint(search);
                                            },
                                          )
                                        : null,
                                  ),
                                ),
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 400),
                                  child: Material(
                                    type: MaterialType.transparency,
                                    child: InkWell(
                                      borderRadius: BorderRadius.only(
                                          topLeft:
                                              Radius.circular(_folded ? 32 : 0),
                                          topRight: const Radius.circular(32),
                                          bottomLeft:
                                              Radius.circular(_folded ? 32 : 0),
                                          bottomRight:
                                              const Radius.circular(32)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Icon(
                                          _folded ? Icons.search : Icons.close,
                                          color: PageColors.blue,
                                        ),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          _folded = !_folded;
                                          if (_folded) {
                                            search = "";
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: StreamBuilder(
                          stream: !_folded && search != ""
                              ? todas
                                  ? db
                                      .collection(
                                          "sesion/${widget.sesionId}/codigoMultas")
                                      .where('titulo',
                                          isGreaterThanOrEqualTo:
                                              search.toLowerCase())
                                      .where('titulo',
                                          isLessThan: search.toLowerCase().substring(
                                                  0,
                                                  search.toLowerCase().length -
                                                      1) +
                                              String.fromCharCode(search
                                                      .toLowerCase()
                                                      .codeUnitAt(
                                                          search.length - 1) +
                                                  1))
                                      .snapshots()
                                  : db
                                      .collection(
                                          "sesion/${widget.sesionId}/codigoMultas")
                                      .where('parte', isEqualTo: parte)
                                      .where('titulo',
                                          isGreaterThanOrEqualTo:
                                              search.toLowerCase())
                                      .where('titulo',
                                          isLessThan: search
                                                  .toLowerCase()
                                                  .substring(0, search.toLowerCase().length - 1) +
                                              String.fromCharCode(search.toLowerCase().codeUnitAt(search.length - 1) + 1))
                                      .snapshots()
                              : todas
                                  ? db.collection("sesion/${widget.sesionId}/codigoMultas").snapshots()
                                  : db.collection("sesion/${widget.sesionId}/codigoMultas").where('parte', isEqualTo: parte).snapshots(),
                          builder: (
                            BuildContext context,
                            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                snapshot,
                          ) {
                            if (snapshot.hasError) {
                              return ErrorWidget(snapshot.error.toString());
                            }
                            if (!snapshot.hasData) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            final codigoMultas = snapshot.data!.docs;

                            return StreamBuilder(
                              stream: db
                                  .doc("sesion/${widget.sesionId}")
                                  .snapshots(),
                              builder: (
                                BuildContext context,
                                AsyncSnapshot<
                                        DocumentSnapshot<Map<String, dynamic>>>
                                    snapshot,
                              ) {
                                if (snapshot.hasError) {
                                  return ErrorWidget(snapshot.error.toString());
                                }
                                if (!snapshot.hasData) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                                return codigoMultas.isEmpty
                                    ? Center(
                                        child: Text(
                                          "No se han encontrado multas.",
                                          textAlign: TextAlign.center,
                                          style: TiposBlue.body,
                                        ),
                                      )
                                    : ListView.builder(
                                        itemCount: codigoMultas.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          final String? titulo =
                                              "${codigoMultas[index]['titulo']}"
                                                  .capitalize;
                                          final String? descripcion =
                                              "${codigoMultas[index]['descripcion']}"
                                                  .capitalize;

                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0, top: 4.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    Radius.circular(10),
                                                  ),
                                                  border: Border.all(
                                                      color: Colors.grey
                                                          .withOpacity(0.3))),
                                              child: ListTile(
                                                title: Text(
                                                  titulo!,
                                                  style: TextStyle(
                                                      color: PageColors.blue,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                subtitle: Text(
                                                  descripcion!,
                                                  style: TextStyle(
                                                      color: PageColors.blue),
                                                ),
                                                trailing: Radio(
                                                    value:
                                                        codigoMultas[index].id,
                                                    groupValue: _site,
                                                    onChanged: (value) async {
                                                      setState(() {
                                                        _site =
                                                            value.toString();
                                                      });
                                                    }),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                              },
                            );
                          },
                        ),
                      ),
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
