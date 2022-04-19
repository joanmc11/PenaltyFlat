// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:penalty_flat_app/models/user.dart';
import 'package:penalty_flat_app/screens/principal.dart';
import 'package:provider/provider.dart';
import '../../Styles/colors.dart';

class TodasCasas extends StatelessWidget {
  const TodasCasas({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;
    final user = Provider.of<MyUser?>(context);
    return Scaffold(
      backgroundColor: PageColors.white,
      appBar: AppBar(
        backgroundColor: PageColors.white,
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: PageColors.blue,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/LogoCabecera.png',
                height: 70,
                width: 70,
              ),
              Text('PENALTY FLAT',
                  style: TextStyle(
                      fontFamily: 'BasierCircle',
                      fontSize: 18,
                      color: PageColors.blue,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            StreamBuilder(
                stream: db.collection("users/${user!.uid}/casas").snapshots(),
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
                  final casasData = snapshot.data!.docs;

                  return Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Text(
                          "Tus PenaltyFlats",
                          style: TiposBlue.bodyBold,
                        ),
                        ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: casasData.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: Icon(
                                Icons.house_rounded,
                                color: PageColors.blue,
                              ),
                              title: Text(
                                casasData[index]['nombreCasa'],
                                style: TiposBlue.bodyBold,
                              ),
                              onTap: () async {
                                await Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => PrincipalScreen(
                                            sesionId: casasData[index]
                                                ['idCasa'],
                                          )),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  );
                }),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 25.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: PageColors.yellow.withOpacity(1)),
                    child: Text(
                      "Atras",
                      style: TextStyle(color: PageColors.blue),
                    ),
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}