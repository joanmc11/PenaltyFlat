import 'package:flutter/material.dart';
import 'package:penalty_flat_app/Styles/colors.dart';

class SinNormas extends StatelessWidget {
  const SinNormas({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height / 1.5,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Center(
                    child: Text(
                      "Todavía no hay normas en tu código de multas",
                      textAlign: TextAlign.center,
                      style: TiposBlue.subtitle,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      "Todos los intengrantes de esta casa pueden añadir y eliminar normas. Poneros de acuerdo y rellenad este vacío con todo lo que se os ocurra.",
                      textAlign: TextAlign.center,
                      style: TiposBlue.body,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 4.0, right: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        border: Border.all(color: Colors.grey.withOpacity(0.3))),
                    child: ListTile(
                      title: Text(
                        "Carretera en el lavabo",
                        style: TextStyle(
                            color: PageColors.blue, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "Dejar un rastro negro en el WC",
                        style: TextStyle(color: PageColors.blue),
                      ),
                      trailing:
                          GestureDetector(onTap: () {}, child: const Text('0.5€')),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        border: Border.all(color: Colors.grey.withOpacity(0.3))),
                    child: ListTile(
                      title: Text(
                        "Platos con telarañas",
                        style: TextStyle(
                            color: PageColors.blue, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "Platos más de dos dias sin lavar",
                        style: TextStyle(color: PageColors.blue),
                      ),
                      trailing:
                          GestureDetector(onTap: () {}, child: const Text('2€')),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Esto son ejemplos. Ten en cuenta que se borrarán al añadir una norma.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: PageColors.blue),
                  ),
                ),
              ]),
        ),
      );
  }
}