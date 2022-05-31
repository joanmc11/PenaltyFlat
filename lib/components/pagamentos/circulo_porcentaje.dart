import 'package:flutter/material.dart';
import 'package:penalty_flat_app/Styles/colors.dart';
import 'package:penalty_flat_app/models/usersInside.dart';
import 'package:penalty_flat_app/services/functions.dart';
import 'package:penalty_flat_app/services/sesionProvider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

class CirculoPagamento extends StatelessWidget {
  const CirculoPagamento({
    Key? key,
    required this.userMoney,
  }) : super(key: key);
  final num userMoney;
  @override
  Widget build(BuildContext context) {
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

            final num totalMultas = FunctionService().dineroMultas(usersData);
            String porcentajeMulta =
                FunctionService().porcentajeMultas(userMoney, totalMultas);

            return CircularPercentIndicator(
              radius: MediaQuery.of(context).size.width / 6,
              animation: true,
              animationDuration: 1200,
              center: Text(userMoney == 0 ? "0%" : "$porcentajeMulta%",
                  style: TiposBlue.subtitle),
              percent: userMoney == 0 ? 0 : userMoney / totalMultas,
              progressColor: PageColors.yellow,
              lineWidth: MediaQuery.of(context).size.width / 45,
            );
        }
      },
    );
  }
}
