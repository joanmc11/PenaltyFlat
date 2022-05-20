import 'package:flutter/material.dart';
import 'package:penalty_flat_app/models/casa_model.dart';
import 'package:penalty_flat_app/services/sesionProvider.dart';
import 'package:penalty_flat_app/screens/display_paginas.dart';
import 'package:penalty_flat_app/screens/misPenaltyFlats/mas_casas.dart';
import 'package:provider/provider.dart';
import '../../Styles/colors.dart';


class CasasList extends StatelessWidget {
  const CasasList({
    Key? key,
    required this.casasData,
  }) : super(key: key);

  final List<Casa> casasData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Tus PenaltyFlats",
          style: TiposBlue.bodyBold,
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 2,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: casasData.length > 4 ? 4 : casasData.length,
            itemBuilder: (context, index) {
              Casa casa = casasData[index];
              return ListTile(
                leading: Icon(
                  Icons.house_rounded,
                  color: PageColors.blue,
                ),
                title: Text(
                  casa.nombreCasa,
                  style: TiposBlue.bodyBold,
                ),
                onTap: () async {
                  String sesionCode = casa.idCasa;
                  Provider.of<SesionProvider>(context, listen: false)
                      .setSesion(sesionCode);

                  await Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const DisplayPaginas(),
                    ),
                  );
                },
              );
            },
          ),
        ),
        casasData.length > 4
            ? Padding(
                padding: const EdgeInsets.only(right: 20, top: 8, bottom: 8),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onTap: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => TodasCasas(),
                        ),
                      );
                    },
                    child: Text(
                      "+ ver más PenaltyFlats",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: PageColors.blue,
                      ),
                    ),
                  ),
                ),
              )
            : const Text(""),
      ],
    );
  }
}