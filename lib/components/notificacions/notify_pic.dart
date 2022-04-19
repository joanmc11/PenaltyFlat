




import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class NotifyPic extends StatefulWidget {
  final String sesionId;
  final String notificadorId;
  const NotifyPic({
    Key? key,
    required this.sesionId,
    required this.notificadorId,
  }) : super(key: key);

  @override
  _NotifyPicState createState() => _NotifyPicState();
}

class _NotifyPicState extends State<NotifyPic> {
  final List<Color> colors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.indigo,
    Colors.pinkAccent,
    Colors.amber,
    Colors.deepOrange,
    Colors.brown,
    Colors.cyan,
    Colors.yellow,
  ];
  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;
    final storage = FirebaseStorage.instance;
    return StreamBuilder(
        stream:
            db.doc("sesion/${widget.sesionId}/users/${widget.notificadorId}").snapshots(),
        builder: (
          BuildContext context,
          AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot,
        ) {
          if (snapshot.hasError) {
            return ErrorWidget(snapshot.error.toString());
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final userData = snapshot.data!.data()!;
          return DottedBorder(
            borderType: BorderType.Circle,
            dashPattern: const [5],
            color: colors[userData['color']],
            strokeWidth: 1,
            
            child: Center(
              child: userData['imagenPerfil'] == ""
                  ? Icon(
                      Icons.account_circle_rounded,
                      size: 36,
                      color: colors[userData['color']],
                      
                    )
                  : FutureBuilder(
                      future: storage
                          .ref("/images/${userData['imagenPerfil']}")
                          .getDownloadURL(),
                      builder: (context, AsyncSnapshot<String> snapshot) {
                        if (!snapshot.hasData) {
                          return const CircularProgressIndicator();
                        }
                        debugPrint(snapshot.data!);
                        return CircleAvatar(
                          radius: 17,
                          backgroundColor: colors[userData['color']],
                          child: CircleAvatar(
                            radius: 16,
                            backgroundImage: NetworkImage(
                              snapshot.data!,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          );
        });
  }
}
