
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:icon_badge/icon_badge.dart';
import 'package:penalty_flat_app/Styles/colors.dart';
import 'package:penalty_flat_app/components/app_bar/app_bar_title.dart';
import 'package:penalty_flat_app/models/notificaciones.dart';
import 'package:penalty_flat_app/services/sesionProvider.dart';
import 'package:penalty_flat_app/screens/notifications.dart';
import 'package:penalty_flat_app/shared/loading.dart';
import 'package:provider/provider.dart';

class PenaltyFlatAppBar extends AppBar {
  PenaltyFlatAppBar({Key? key})
      : super(
          key: key,
          toolbarHeight: 75,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: PageColors.blue),
          title: const AppBarTitle(),
          actions: <Widget>[buildNotificationAction()],
        );

  static Widget buildNotificationAction() {
    final user = FirebaseAuth.instance.currentUser;
    return user == null ? const Loading() : const _NotificationIcon();
  }
}

class _NotificationIcon extends StatelessWidget {
  const _NotificationIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final idCasa = Provider.of<SesionProvider?>(context)!.sesionCode;
    return StreamBuilder(
      stream: notificacionesNoVistas(idCasa, user.uid),
      builder: (
        BuildContext context,
        AsyncSnapshot<List<Notificacion>> snapshot,
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
            final notifyData = snapshot.data!;

            return IconBadge(
              icon: Icon(
                Icons.notifications_none_outlined,
                color: PageColors.blue,
                size: 35,
              ),
              itemCount: notifyData.length,
              badgeColor: Colors.red,
              itemColor: Colors.white,
              hideZero: true,
              top: 11,
              right: 9,
              onTap: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const Notificaciones(),
                  ),
                );
              },
            );
        }
      },
    );
  }
}
