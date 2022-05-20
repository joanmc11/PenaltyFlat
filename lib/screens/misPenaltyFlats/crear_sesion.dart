import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:penalty_flat_app/components/app_bar/app_bar_title.dart';
import 'package:provider/provider.dart';
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

  

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    return Scaffold(
      backgroundColor: PageColors.white,
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: PageColors.white,
        iconTheme: IconThemeData(color: PageColors.blue),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: const [
            AppBarTitle(),
          ],
        ),
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
                  validator: (val) => val!.isEmpty ? "Introduce un nombre para la casa" : null,
                  decoration: InputDecoration(
                      hintText: "Nombre de la casa",
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: PageColors.yellow, width: 0.5))),
                  onChanged: (val) {
                    setState(() {
                      casa = val;
                    });
                  },
                ),
                TextFormField(
                  //apodo
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
                              primary: apodo != "" && casa != "" ? PageColors.yellow : Colors.grey),
                          child: Text(
                            "Empieza",
                            style: TextStyle(color: PageColors.blue),
                          ),
                          onPressed: () async{
                            if (_formKey.currentState!.validate()) {
                              await DatabaseService(uid: user!.uid).createHouse(casa, apodo, context);
                               
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
