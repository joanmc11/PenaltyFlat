import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:icon_badge/icon_badge.dart';
import 'package:penalty_flat_app/Styles/colors.dart';
import 'package:penalty_flat_app/components/app_bar/app_bar_title.dart';
import 'package:penalty_flat_app/screens/display_paginas.dart';
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
    final db = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser!;
    final idCasa = context.read<CasaID>();
    return StreamBuilder(
      stream: db
          .collection("sesion/$idCasa/notificaciones")
          .where('idUsuario', isEqualTo: user.uid)
          .where('visto', isEqualTo: false)
          .snapshots(),
      builder: (
        BuildContext context,
        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
      ) {
        if (snapshot.hasError) {
          return ErrorWidget(snapshot.error.toString());
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final notifyData = snapshot.data!.docs;

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
      },
    );
  }
}
