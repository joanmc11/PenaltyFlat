// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:penalty_flat_app/models/user.dart';
import 'package:penalty_flat_app/services/auth.dart';
import 'package:provider/provider.dart';
import '../../Styles/colors.dart';

class TodasCasas extends StatelessWidget {
   TodasCasas({ Key? key }) : super(key: key);
   final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;
    final user = Provider.of<MyUser?>(context);
    return Scaffold(
      backgroundColor: PageColors.white,
      appBar: AppBar(
          backgroundColor: PageColors.white,
          elevation: 0.0,
          title: Center(child: Text("PenaltyFlat", style: TiposBlue.title)),
          actions: <Widget>[
            FlatButton.icon(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await _auth.signOut();
              },
              label: const Text(
                "logOut",
                style: TextStyle(fontSize: 0),
              ),
            )
          ]),
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
                    child: 
                      
                    Column(
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
                              onTap: () {},
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
                        primary: PageColors.blue),
                    child: Text(
                      "Atras",
                      style: TextStyle(color: PageColors.white),
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