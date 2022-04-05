// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:penalty_flat_app/Styles/colors.dart';
import 'package:penalty_flat_app/services/auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:penalty_flat_app/shared/loading.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  const SignIn({Key? key, required this.toggleView}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

//text field states
  String email = "";
  String password = "";
  String error = "";

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
            backgroundColor: PageColors.white,
            appBar: AppBar(
              backgroundColor: PageColors.white,
              elevation: 0.0,
              title: Center(child: Text("PenaltyFlat", style: TiposBlue.title)),
            ),
            body: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height / 1.2,
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Center(
                          child: Text("Inicia sesión",
                              textAlign: TextAlign.center,
                              style: TiposBlue.subtitle),
                        ),
                      ),
                      TextFormField(
                        //email
                        validator: (val) => EmailValidator.validate(val!)
                            ? null
                            : "Introduce un email válido",
                        decoration: InputDecoration(
                            hintText: "Email",
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: PageColors.yellow, width: 0.5))),
                        onChanged: (val) {
                          setState(() {
                            email = val;
                          });
                        },
                      ),
                      TextFormField(
                        //password
                        validator: (val) => val!.length < 6
                            ? "Introduce una contraseña de mínimo 6 caracteres"
                            : null,
                        decoration: InputDecoration(
                            hintText: "Password",
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: PageColors.yellow, width: 0.5))),
                        obscureText: true,
                        onChanged: (val) {
                          setState(() {
                            password = val;
                          });
                        },
                      ),
                      Text(
                        error,
                        style: const TextStyle(color: Colors.red),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: email != "" && password != ""
                                      ? PageColors.yellow
                                      : Colors.grey),
                              child: Text(
                                "Entra",
                                style: TextStyle(color: PageColors.blue),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    loading = true;
                                  });
                                  dynamic result =
                                      await _auth.signInWithEmailAndPassword(
                                          email, password);

                                  if (result == null) {
                                    setState(() {
                                      error = "Email o contraseña incorrectos";
                                      loading = false;
                                    });
                                  }
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          widget.toggleView();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text("¿No tienes cuenta? "),
                            Text(
                              "Registrate",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
