// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:penalty_flat_app/components/app_bar/app_bar_title.dart';
import 'package:penalty_flat_app/components/misPenaltyFlats/button_homes.dart';
import 'package:penalty_flat_app/components/misPenaltyFlats/casas_list_general.dart';
import 'package:penalty_flat_app/models/casa_model.dart';
import 'package:penalty_flat_app/models/user.dart';
import 'package:penalty_flat_app/screens/misPenaltyFlats/crear_sesion.dart';
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
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                          future: db.doc("users/${user.uid}").get(),
                          builder: (_, snapshot) {
                            if (snapshot.hasError) {
                              return Text('Error = ${snapshot.error}');
                            }
                            if (snapshot.hasError) {
                              return ErrorWidget(snapshot.error.toString());
                            }
                            if (!snapshot.hasData) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }

                            final userData = snapshot.data!.data()!;
                            // <-- Your value

                            return Padding(
                              padding: const EdgeInsets.all(40.0),
                              child: Center(
                                child: Text("Bienvenido " + userData['nombre'],
                                    textAlign: TextAlign.center,
                                    style: TiposBlue.subtitle),
                              ),
                            );
                          },
                        ),
                        StreamBuilder(
                          stream: casasSnapshots(user.uid),
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

                                return casas.isEmpty
                                    ? Center(
                                        child: Text(
                                            """¿Aún no tienes una PenaltyFlat?
 Créala ahora o únete a la de tus compañeros""",
                                            textAlign: TextAlign.center,
                                            style: TiposBlue.body),
                                      )
                                    : CasasList(casasData: casas);
                            }
                          },
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                          Padding(
                            padding: EdgeInsets.only(bottom: 25.0),
                            child: ButtonHomes(titulo: "Crea tu PenaltyFlat", destination: CrearSesion() ,),
                          ),
                          ButtonHomes(titulo: "Entra en una PenaltyFlat", destination: EntrarSesion()),
                         
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


