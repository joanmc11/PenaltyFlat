// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:penalty_flat_app/components/app_bar/app_bar_title.dart';
import 'package:penalty_flat_app/models/user.dart';
import 'package:penalty_flat_app/screens/display_paginas.dart';
import 'package:penalty_flat_app/screens/misPenaltyFlats/crear_sesion.dart';
import 'package:penalty_flat_app/screens/misPenaltyFlats/mas_casas.dart';
import 'package:penalty_flat_app/screens/misPenaltyFlats/unirte_sesion.dart';
import 'package:penalty_flat_app/services/auth.dart';
import 'package:provider/provider.dart';
import '../../Styles/colors.dart';
import '../../shared/loading.dart';

class Inicio extends StatelessWidget {
  Inicio({Key? key}) : super(key: key);

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
            FlatButton.icon(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await _auth.signOut();
              },
              label: const Text(
                "logOut",
                style: TextStyle(fontSize: 0),
              ),
            )
          ]),
      body: user == null
          ? const Loading()
          : Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  StreamBuilder(
                    stream:
                        db.collection("users/${user.uid}/casas").snapshots(),
                    builder: (
                      BuildContext context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot,
                    ) {
                      if (snapshot.hasError) {
                        return ErrorWidget(snapshot.error.toString());
                      }
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final casasData = snapshot.data!.docs;

                      return StreamBuilder(
                        stream: db.doc("users/${user.uid}").snapshots(),
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
                          final userData = snapshot.data!.data()!;
                          return Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(40.0),
                                  child: Center(
                                    child: Text(
                                        "Bienvenido " + userData['nombre'],
                                        textAlign: TextAlign.center,
                                        style: TiposBlue.subtitle),
                                  ),
                                ),
                                casasData.isEmpty
                                    ? Center(
                                        child: Text(
                                            """??A??n no tienes una PenaltyFlat?
 Cr??ala ahora o ??nete a la de tus compa??eros""",
                                            textAlign: TextAlign.center,
                                            style: TiposBlue.body),
                                      )
                                    : Column(
                                        children: [
                                          Text(
                                            "Tus PenaltyFlats",
                                            style: TiposBlue.bodyBold,
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(10),
                                                      topRight:
                                                          Radius.circular(10),
                                                      bottomLeft:
                                                          Radius.circular(10),
                                                      bottomRight:
                                                          Radius.circular(10)),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.2),
                                                  spreadRadius: 2,
                                                  blurRadius: 2,
                                                  offset: const Offset(0,
                                                      3), // changes position of shadow
                                                ),
                                              ],
                                            ),
                                            child: ListView.builder(
                                              scrollDirection: Axis.vertical,
                                              shrinkWrap: true,
                                              itemCount: casasData.length > 3
                                                  ? 3
                                                  : casasData.length,
                                              itemBuilder: (context, index) {
                                                return ListTile(
                                                  leading: Icon(
                                                    Icons.house_rounded,
                                                    color: PageColors.blue,
                                                  ),
                                                  title: Text(
                                                    casasData[index]
                                                        ['nombreCasa'],
                                                    style: TiposBlue.bodyBold,
                                                  ),
                                                  onTap: () async {
                                                    await Navigator.of(context)
                                                        .pushReplacement(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              DisplayPaginas(
                                                                sesionId: casasData[
                                                                        index]
                                                                    ['idCasa'],
                                                              )),
                                                    );
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                          casasData.length > 3
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 20,
                                                          top: 8,
                                                          bottom: 8),
                                                  child: Align(
                                                    alignment:
                                                        Alignment.bottomRight,
                                                    child: GestureDetector(
                                                        onTap: () async {
                                                          await Navigator.of(
                                                                  context)
                                                              .push(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        TodasCasas()),
                                                          );
                                                        },
                                                        child: Text(
                                                          "+ ver m??s PenaltyFlats",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14,
                                                            color:
                                                                PageColors.blue,
                                                          ),
                                                        )),
                                                  ),
                                                )
                                              : const Text(""),
                                        ],
                                      ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 25.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: PageColors.yellow),
                              child: Text(
                                "Crea tu PenaltyFlat",
                                style: TextStyle(color: PageColors.blue),
                              ),
                              onPressed: () async {
                                await Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const CrearSesion()),
                                );
                              },
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: PageColors.yellow),
                            child: Text(
                              "Entra en una PenaltyFlat",
                              style: TextStyle(color: PageColors.blue),
                            ),
                            onPressed: () async {
                              await Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => const EntrarSesion()),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
