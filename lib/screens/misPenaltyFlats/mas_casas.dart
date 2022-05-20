import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:penalty_flat_app/components/app_bar/app_bar_title.dart';
import 'package:penalty_flat_app/models/casa_model.dart';
import 'package:penalty_flat_app/models/user.dart';
import 'package:penalty_flat_app/screens/display_paginas.dart';
import 'package:penalty_flat_app/services/auth.dart';
import 'package:penalty_flat_app/services/sesionProvider.dart';
import 'package:provider/provider.dart';
import '../../Styles/colors.dart';

class TodasCasas extends StatelessWidget {
  TodasCasas({Key? key}) : super(key: key);
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;
    final user = Provider.of<MyUser?>(context);
    return Scaffold(
      backgroundColor: PageColors.white,
      appBar: AppBar(
          toolbarHeight: 70,
          backgroundColor: PageColors.white,
          iconTheme: IconThemeData(color: PageColors.blue),
          title: const AppBarTitle(),
          actions: <Widget>[
            TextButton.icon(
              icon: Icon(
                Icons.logout,
                color: PageColors.blue,
              ),
              onPressed: () async {
                await _auth.signOut();
              },
              label: const Text(
                "logOut",
                style: TextStyle(fontSize: 0),
              ),
            )
          ]),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Text(
                    "Tus PenaltyFlats",
                    style: TiposBlue.bodyBold,
                  ),
                  StreamBuilder(
                    stream: casasSnapshots(user!.uid),
                    builder: (
                      BuildContext context,
                      AsyncSnapshot<List<Casa>> snapshot,
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
                          final casas = snapshot.data!;

                          return _ListCasas(casasData: casas);
                      }
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 25.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: PageColors.yellow.withOpacity(1)),
                    child: Text(
                      "Atras",
                      style: TextStyle(color: PageColors.blue),
                    ),
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _ListCasas extends StatelessWidget {
  const _ListCasas({
    Key? key,
    required this.casasData,
  }) : super(key: key);

  final List<Casa> casasData;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: casasData.length,
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
    );
  }
}
