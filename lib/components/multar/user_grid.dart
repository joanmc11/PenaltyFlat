import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:penalty_flat_app/components/multar/imatgePerfil_multa.dart';
import 'package:provider/provider.dart';
import '../../models/user.dart';

class UserGrid extends StatelessWidget {
   final String sesionId;
  const UserGrid({ Key? key, required this.sesionId }) : super(key: key);

  @override
  Widget build(BuildContext context) {
     final db = FirebaseFirestore.instance;
    final user = Provider.of<MyUser?>(context);
    return StreamBuilder(
              stream: db
                  .collection("sesion/$sesionId/users")
                  .where('id', isNotEqualTo: user?.uid)
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
                final usersData = snapshot.data!.docs;

                return Flexible(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    shrinkWrap: true,
                    itemCount: usersData.length,
                    itemBuilder: (context, index) {
                      return ImageMultar(sesionId: sesionId, userData: usersData[index]);
                    },
                  ),
                );
              });
  }
}