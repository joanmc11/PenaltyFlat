import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:penalty_flat_app/screens/inside/inici.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../../Styles/colors.dart';
import '../../models/user.dart';
import '../../services/database.dart';

class CrearSesion extends StatefulWidget {
  const CrearSesion({Key? key}) : super(key: key);

  @override
  _CrearSesionState createState() => _CrearSesionState();
}

class _CrearSesionState extends State<CrearSesion> {
  String casa = "";
  String apodo = "";
  final _formKey = GlobalKey<FormState>();
  final db = FirebaseFirestore.instance;

  //Get Random String
  static const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnPpQqRrSsTtUuVvWwXxYyZz123456789';
  final Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    return Scaffold(
      backgroundColor: PageColors.white,
      appBar: AppBar(
        backgroundColor: PageColors.white,
        elevation: 0.0,
        title: Center(child: Text("PenaltyFlat", style: TiposBlue.title)),
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
                  child: Text("""¡Bien, empezemos!""",
                      textAlign: TextAlign.center, style: TiposBlue.body),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Center(
                    child: Text("""Crea tu PenaltyFlat""",
                        textAlign: TextAlign.center, style: TiposBlue.subtitle),
                  ),
                ),
                TextFormField(
                  //Nombre
                  validator: (val) =>
                      val!.isEmpty ? "Introduce un nombre para la casa" : null,
                  decoration: InputDecoration(
                      hintText: "Nombre de la casa",
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: PageColors.yellow, width: 0.5))),
                  onChanged: (val) {
                    setState(() {
                      casa = val;
                    });
                  },
                ),
                TextFormField(
                  //apodo
                  validator: (val) =>
                      val!.isEmpty ? "Introduce tu apodo" : null,
                  decoration: InputDecoration(
                      hintText: "Tu apodo",
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: PageColors.yellow, width: 0.5))),

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
                        """En la pantalla principal podrás ver el código de tu PenaltyFlat para que tus compañeros puedan unir-se.""",
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
                          style: ElevatedButton.styleFrom(
                              primary: PageColors.white),
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
                              primary: apodo != "" && casa != ""
                                  ? PageColors.yellow
                                  : Colors.grey),
                          child: Text(
                            "Empieza",
                            style: TextStyle(color: PageColors.blue),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final sesionSnap =
                                  await db.collection('/sesion').add({
                                "codi": getRandomString(5),
                                "casa": casa,
                                "partes": [
                                  "Todas",
                                  "Baño",
                                  "Comedor",
                                  "Cocina",
                                  "Lavadero",
                                  "Otros"
                                ],
                                "sinMultas": true,
                              });
                              await db
                                  .doc(
                                      '/sesion/${sesionSnap.id}/users/${user?.uid}')
                                  .set({
                                "nombre": apodo,
                                "color": 0,
                                "id": user!.uid,
                                "isAdmin": true,
                                "imagenPerfil": "",
                                "dinero": 0
                              });
                              //creo la collection de casas (inicialment buida)
                              await DatabaseService(uid: user.uid)
                                  .updateUserFlats(casa, sesionSnap.id);

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  duration: Duration(seconds: 1),
                                  content: Text("¡Has creado un PenaltyFlat!"),
                                ),
                              );
                              await Future.delayed(
                                  const Duration(milliseconds: 300), () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Inicio(),
                                    ));
                              });
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
