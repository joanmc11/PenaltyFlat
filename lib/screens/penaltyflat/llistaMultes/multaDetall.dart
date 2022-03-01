import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Styles/colors.dart';
import '../../../models/user.dart';
import 'package:string_extensions/string_extensions.dart';

class MultaDetall extends StatelessWidget {
  final String sesionId;
  final String idMulta;
  MultaDetall({Key? key, required this.sesionId, required this.idMulta})
      : super(key: key);
  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
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
