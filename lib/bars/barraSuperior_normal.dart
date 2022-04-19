// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:icon_badge/icon_badge.dart';
import 'package:penalty_flat_app/components/app_bar_title.dart';
import 'package:penalty_flat_app/screens/notifications.dart';
import 'package:provider/provider.dart';

import '../Styles/colors.dart';
import '../models/user.dart';

class NormalAppBar extends StatelessWidget {
  final String sesionId;
  const NormalAppBar({Key? key, required this.sesionId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;
    final user = Provider.of<MyUser?>(context);
    return AppBar(
      toolbarHeight: 75,
      backgroundColor: Colors.white,
      leading: Container(),
      title: const AppBarTitle(),
      actions: <Widget>[
        StreamBuilder(
            stream: db
                .collection("sesion/$sesionId/notificaciones")
                .where('idUsuario', isEqualTo: user?.uid)
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
                    MaterialPageRoute(builder: (context) => Notificaciones(sesionId: sesionId)),
                  );
                },
              );
            }),
      ],
    );
  }
}
