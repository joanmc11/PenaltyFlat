import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:penalty_flat_app/components/app_bar_title.dart';
import 'package:penalty_flat_app/screens/misPenaltyFlats/inici.dart';
import 'package:provider/provider.dart';
import '../../Styles/colors.dart';
import '../../models/user.dart';
import '../../services/database.dart';

class EntrarSesion extends StatefulWidget {
  const EntrarSesion({Key? key}) : super(key: key);

  @override
  _EntrarSesionState createState() => _EntrarSesionState();
}

class _EntrarSesionState extends State<EntrarSesion> {
  String codi = "";
  String apodo = "";
  final _formKey = GlobalKey<FormState>();
  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    return Scaffold(
      backgroundColor: PageColors.white,
      appBar: AppBar(
        backgroundColor: PageColors.white,
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: PageColors.blue,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const AppBarTitle(),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height / 1.1,
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Center(
                  child: Text("""¡Únete a una PenaltyFlat!""",
                      textAlign: TextAlign.center, style: TiposBlue.body),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Center(
                    child: Text("""Pide el código para unirte""",
                        textAlign: TextAlign.center, style: TiposBlue.subtitle),
                  ),
                ),
                TextFormField(
                  validator: (val) => val!.isEmpty ? "Introduce un código" : null,
                  decoration: InputDecoration(
                      hintText: "Código",
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: PageColors.yellow, width: 0.5))),
                  onChanged: (val) {
                    setState(() {
                      codi = val;
                    });
                  },
                ),
                TextFormField(
                  //password
                  validator: (val) => val!.isEmpty ? "Introduce tu apodo" : null,
                  decoration: InputDecoration(
                      hintText: "Tu apodo",
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: PageColors.yellow, width: 0.5))),

                  onChanged: (val) {
                    setState(() {
                      apodo = val;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Center(
                    child: Text(
                        """Si el creador de la PenaltyFlat no encuentra el código, está en la pantalla principal.""",
                        textAlign: TextAlign.center, style: TiposBlue.body),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(primary: PageColors.white),
                          child: Text(
                            "Cancelar",
                            style: TextStyle(color: PageColors.blue),
                          ),
                          onPressed: () async {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: codi != "" && apodo != "" ? PageColors.yellow : Colors.grey),
                          child: Text(
                            "Únete",
                            style: TextStyle(color: PageColors.blue),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final sesionSnap = await db
                                  .collection('sesion')
                                  .where('codi', isEqualTo: codi)
                                  .get();
                              //id de la sesio
                              final sesionId = sesionSnap.docs[0].id;

                              //Comprovo si l'usuari ja hi és a la sesió
                              final userIn = await db
                                  .collection('sesion/$sesionId/users')
                                  .where('id', isEqualTo: user!.uid)
                                  .get();

                              //si no hi és l'afageixo
                              if (userIn.docs.isNotEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    duration: Duration(seconds: 1),
                                    content: Text(
                                        "Ya perteneces a está sesión, no puedes entrar dos veces"),
                                  ),
                                );
                              } else {
                                //Afageixo un color per defecte a l'usuari segons la llargaria dels usuaris
                                final userLen = await db.collection('sesion/$sesionId/users').get();

                                await db.doc('/sesion/$sesionId/users/${user.uid}').set({
                                  "nombre": apodo,
                                  "color": userLen.docs.length,
                                  "id": user.uid,
                                  "isAdmin": false,
                                  "imagenPerfil": "",
                                  "dinero": 0,
                                  "pendiente": false,
                                  'contador': 1,
                                });

                                //Busco el nom de la casa
                                final casa = await db.doc('sesion/$sesionId').get();
                                final String casaNombre = casa['casa'];
                                //creo la collection de casas de l'usuari (inicialment buida)
                                await DatabaseService(uid: user.uid)
                                    .updateUserFlats(casaNombre, sesionId);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    duration: Duration(seconds: 1),
                                    content: Text("¡Te has unido a la PenaltyFlat!"),
                                  ),
                                );
                                await Future.delayed(const Duration(milliseconds: 300), () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Inicio(),
                                      ));
                                });
                              }
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
