import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:penalty_flat_app/shared/loading.dart';
import 'package:provider/provider.dart';
import '../../../Styles/colors.dart';
import '../../../models/user.dart';
import 'package:string_extensions/string_extensions.dart';

class MultaDetall extends StatelessWidget {
  final String sesionId;
  final String idMulta;
  final String idMultado;
  MultaDetall({Key? key, required this.sesionId, required this.idMulta, required this.idMultado})
      : super(key: key);
  final db = FirebaseFirestore.instance;
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
    final user = Provider.of<MyUser?>(context);
    final storage = FirebaseStorage.instance;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: PageColors.blue,
          onPressed: () async{
            Navigator.pop(context);
          },
        ),
        toolbarHeight: 70,
        backgroundColor: PageColors.white,
        title: Center(
          child: Text(
            'Penalty Flat',
            style: TextStyle(color: PageColors.blue),
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.notifications_none_outlined,
              color: PageColors.blue,
            ),
            padding: const EdgeInsets.only(right: 30),
          )
        ],
      ),
      body: StreamBuilder(
          stream: db.doc("sesion/$sesionId/multas/$idMulta").snapshots(),
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
            final multaData = snapshot.data!.data()!;
            return Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Center(
                          child: multaData['idMultado'] == user!.uid
                              ? Text("¡Te han pillado!", style: TiposBlue.title)
                              : Text(
                                  "¡Han pillado a ${multaData['nomMultado']}!",
                                  style: TiposBlue.title,
                                ),),
                    ),

                    StreamBuilder(
              stream: db.doc("sesion/$sesionId/users/$idMultado").snapshots(),
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

                return Center(
                  child: DottedBorder(
                                      borderType: BorderType.Circle,
                                      dashPattern: const [5],
                                      color: colors[userData['color']],
                                      strokeWidth: 1,
                                      child: userData['imagenPerfil'] ==
                                              ""
                                          ? Icon(
                                              Icons.account_circle_rounded,
                                              size: 85,
                                              color: colors[userData
                                                  ['color']],
                                            )
                                          : FutureBuilder(
                                              future: storage
                                                  .ref(
                                                      "/images${userData['imagenPerfil']}")
                                                  .getDownloadURL(),
                                              builder: (context,
                                                  AsyncSnapshot<String>
                                                      snapshot) {
                                                if (!snapshot.hasData) {
                                                  return const CircularProgressIndicator();
                                                }
                                                debugPrint(snapshot.data!);
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: CircleAvatar(
                                                    radius: 38,
                                                    backgroundColor: colors[
                                                        userData
                                                            ['color']],
                                                    child: CircleAvatar(
                                                      radius: 37,
                                                      backgroundImage:
                                                          NetworkImage(
                                                        snapshot.data!,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                    ),
                )
                
                
                ;},),

                    Expanded(
                      flex: 4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            Text(
                            multaData['idMultado'] == user.uid
                                ? "¿Qué has hecho?"
                                : "¿Qué ha hecho?",
                            style: TiposBlue.subtitle,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top:8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: PageColors.blue.withOpacity(0.2),
                              ),
                              
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Column(
                                  
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${multaData['titulo']}".capitalize!,
                                      style: TiposBlue.bodyBold,
                                    ),
                                    Text(
                                      "${multaData['descripcion']}".capitalize!,
                                      style: TiposBlue.body,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          ],),
                           Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Text("Pruebas", style: TiposBlue.subtitle,),
                               Padding(
                                 padding: const EdgeInsets.only(top:8.0),
                                 child: multaData['imagen']==""? Text("No se dispone de pruebas", style: TiposBlue.body,):Text("Imagen aquí"),
                               ),

                             ],
                           ),
                           Column(
                             mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Text("Sale a Pagar", style: TiposBlue.subtitle,),
                               Padding(
                                 padding: const EdgeInsets.all(16.0),
                                 child: Text("${multaData['precio']}€", style: TiposBlue.title,),
                               )
                             ],
                           )
                        ],
                      ),
                    ),
                   

                  ]),
            );
          }),
    );
  }
}
