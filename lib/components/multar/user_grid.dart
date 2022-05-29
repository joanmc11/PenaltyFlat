
import 'package:flutter/material.dart';
import 'package:penalty_flat_app/components/multar/imatgePerfil_multa.dart';
import 'package:penalty_flat_app/models/usersInside.dart';
import 'package:penalty_flat_app/services/sesionProvider.dart';
import 'package:provider/provider.dart';
import '../../models/user.dart';

class UserGrid extends StatelessWidget {
  const UserGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    final idCasa = Provider.of<SesionProvider?>(context)!.sesionCode;
    return StreamBuilder(
      stream: usersMultarSnapshot(idCasa, user!.uid),
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

            return Flexible(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                shrinkWrap: true,
                itemCount: usersData.length,
                itemBuilder: (context, index) {
                  return ImageMultar(userData: usersData[index]);
                },
              ),
            );
        }
      },
    );
  }
}
