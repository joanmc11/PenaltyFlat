import 'package:flutter/material.dart';
import 'package:penalty_flat_app/Styles/colors.dart';
import 'package:penalty_flat_app/models/user.dart';
import 'package:penalty_flat_app/models/usersInside.dart';
import 'package:penalty_flat_app/services/database.dart';
import 'package:penalty_flat_app/services/sesionProvider.dart';
import 'package:provider/provider.dart';

class BotonesPagamento extends StatelessWidget {
  const BotonesPagamento({Key? key, required this.singleUserData})
      : super(key: key);
  final InsideUser singleUserData;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    final idCasa = Provider.of<SesionProvider?>(context)!.sesionCode;
    return StreamBuilder(
      stream: simpleUsersSnapshot(idCasa),
      builder: (
        BuildContext context,
        AsyncSnapshot<List<InsideUser>> snapshot,
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
            final usersData = snapshot.data!;

            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
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
                              "Atrás",
                              style: TextStyle(color: PageColors.blue),
                            ),
                            onPressed: () async {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: singleUserData.pendiente == false
                                    ? singleUserData.dinero == 0
                                        ? Colors.grey
                                        : PageColors.yellow
                                    : Colors.grey),
                            child: Text(
                              singleUserData.pendiente == false
                                  ? "Pagar"
                                  : "Pendiente",
                              style: TextStyle(color: PageColors.blue),
                            ),
                            onPressed: () async {
                              DatabaseService(uid: user!.uid).pagamentos(
                                singleUserData,
                                usersData,
                                context,
                                idCasa,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
        }
      },
    );
  }
}
