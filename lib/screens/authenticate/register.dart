import 'package:flutter/material.dart';
import 'package:penalty_flat_app/services/auth.dart';
import 'package:penalty_flat_app/Styles/colors.dart';
import 'package:email_validator/email_validator.dart';
import 'package:penalty_flat_app/shared/loading.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  const Register({Key? key, required this.toggleView}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

//text field states
  String name = "";
  String email = "";
  String password = "";
  String error = "";
  String completed = "";

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
                height: MediaQuery.of(context).size.height / 1.1,
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Center(
                        child: Text("""¡Bienvenido a Penalty Flat!""",
                            textAlign: TextAlign.center, style: TiposBlue.body),
                      ),
                      Center(
                        child: Text(
                            """¿Quieres ponerte a prueba a ti y a tus compañeros con las tareas de hogar?""",
                            textAlign: TextAlign.center, style: TiposBlue.body),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Center(
                          child: Text("""¡Empieza YA Registrandote!""",
                              textAlign: TextAlign.center,
                              style: TiposBlue.subtitle),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 18.0),
                        child: TextFormField(
                          //nombre
                          validator: (val) =>
                              val!.isEmpty ? "Introduce tu nombre" : null,
                          decoration: InputDecoration(
                              hintText: "Tu nombre",
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: PageColors.yellow, width: 0.5))),
                          onChanged: (val) {
                            setState(() {
                              name = val;
                            });
                          },
                        ),
                      ),
                      TextFormField(
                        //email
                        validator: (val) => EmailValidator.validate(val!)
                            ? null
                            : "Introduce un email válido",
                        decoration: InputDecoration(
                            hintText: "Correo electrónico",
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: PageColors.yellow, width: 0.5))),
                        onChanged: (val) {
                          setState(() {
                            email = val;
                          });
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 18.0, bottom: 18.0),
                        child: TextFormField(
                          //password
                          validator: (val) => val!.length < 6
                              ? "Introduce una contraseña de mínimo 6 caracteres"
                              : null,
                          decoration: InputDecoration(
                              hintText: "Contraseña",
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
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: name != "" &&
                                          email != "" &&
                                          password != ""
                                      ? PageColors.yellow
                                      : Colors.grey),
                              child: Text(
                                "Registrate",
                                style: TextStyle(color: PageColors.blue),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    loading = true;
                                  });
                                  dynamic result =
                                      await _auth.registerWithEmailAndPassword(
                                          name, email, password);

                                  if (result == null) {
                                    setState(() {
                                      error = "";
                                      loading = false;
                                    });
                                  }
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      GestureDetector(
                        onTap: () {
                          widget.toggleView();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            const Text("¿Tienes una cuenta? "),
                            const Text(
                              "Inicia sesión",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        error,
                        style: const TextStyle(color: Colors.red),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
