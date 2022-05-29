import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:penalty_flat_app/components/app_bar/app_bar_title.dart';
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
                      borderSide: BorderSide(color: PageColors.yellow, width: 0.5),
                    ),
                  ),

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
                              DatabaseService(uid: user!.uid).joinHouse(codi, apodo, context);
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
