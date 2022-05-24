import 'package:flutter/material.dart';
import 'package:penalty_flat_app/Styles/colors.dart';
import 'package:penalty_flat_app/models/multas.dart';
import 'package:penalty_flat_app/services/sesionProvider.dart';
import 'package:penalty_flat_app/screens/llistaMultes/multa_detall.dart';
import 'package:provider/provider.dart';
import '../../models/user.dart';

class ListaMultasUsuarios extends StatelessWidget {
  final int monthValue;
  final String selectedMonth;
  final int yearValue;
  final bool selected;
  final int currentIndex;

  const ListaMultasUsuarios({
    Key? key,
    required this.monthValue,
    required this.selectedMonth,
    required this.yearValue,
    required this.selected,
    required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    final idCasa = Provider.of<SesionProvider?>(context)!.sesionCode;
    return StreamBuilder(
      stream: listaMultasSnapshots(idCasa, selected, selectedMonth, monthValue,
          yearValue, user!.uid.toString()),
      builder: (
        BuildContext context,
        AsyncSnapshot<List<Multa>> snapshot,
      ) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.done:
            throw "Stream is none or done!!!";
          case ConnectionState.waiting:
            return const Center(
              child: CircularProgressIndicator(),
            );
          case ConnectionState.active:
            final listMultas = snapshot.data!;

            return Flexible(
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemExtent: 55.0,
                  itemCount: listMultas.isEmpty ? 1 : listMultas.length,
                  itemBuilder: (context, index) {
                    final multa = listMultas[index];
                    return listMultas.isEmpty
                        ? Align(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              currentIndex == 0
                                  ? "Aún no tienes multas"
                                  : "No tienes multas para esta fecha",
                              style: TiposBlue.body,
                            ))
                        : ListTile(
                            leading: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                    onPressed: () async {
                                      await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => MultaDetall(
                                              notifyId: "sinNotificacion",
                                              idMulta: multa.id.toString(),
                                              idMultado: multa.idMultado,
                                            ),
                                          ));
                                    },
                                    icon: Icon(Icons.open_in_full,
                                        color: PageColors.blue)),
                              ],
                            ),
                            title: Text(multa.nomMultado,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: PageColors.blue,
                                    fontWeight: FontWeight.bold)),
                            subtitle: Text(
                              multa.titulo,
                              style: TextStyle(
                                  fontSize: 14, color: PageColors.blue),
                            ),
                            trailing: Text("${multa.precio}€"),
                          );
                  },
                ),
              ),
            );
        }
      },
    );
  }
}
