import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import 'package:penalty_flat_app/Styles/colors.dart';
import 'package:penalty_flat_app/screens/multar/escojer_multa.dart';
import 'package:penalty_flat_app/shared/loading.dart';
import 'package:provider/provider.dart';

import '../../main.dart';

import '../../models/user.dart';
import '../widgets/tab_item.dart';

class PersonaMultada extends StatefulWidget {
  final String sesionId;
  const PersonaMultada({Key? key, required this.sesionId}) : super(key: key);

  @override
  _PersonaMultadaState createState() => _PersonaMultadaState();
}

class _PersonaMultadaState extends State<PersonaMultada> {
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
    final user = Provider.of<MyUser?>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: PageColors.blue,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        toolbarHeight: 70,
        backgroundColor: Colors.white,
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
      body: user==null? const Loading(): StreamBuilder(
          stream: db
              .collection("sesion/${widget.sesionId}/users")
              .where('id', isNotEqualTo: user.uid)
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

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 50.0),
                  child: Center(
                      child: Text("¿A quién has pillado?",
                          style: TiposBlue.title)),
                ),
                Flexible(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    shrinkWrap: true,
                    itemCount: usersData.length,
                    itemBuilder: (context, index) {
                      return Material(
                        color: Colors.white.withOpacity(0.0),
                        child: InkWell(
                          splashColor: Theme.of(context).primaryColorLight,
                          onTap: () {
                            setState(() {});
                            Future.delayed(const Duration(milliseconds: 200));
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EscojerMulta(
                                    sesionId: widget.sesionId,
                                    idMultado: usersData[index].id,
                                  ),
                                ));
                          },
                          child: Column(
                            children: [
                              /*Image.memory(
                          (app as ApplicationWithIcon).icon,
                          width: 40,
                          height: 40,
                        ),*/
                              DottedBorder(
                                borderType: BorderType.Circle,
                                dashPattern: [5],
                                color: colors[usersData[index]['color']],
                                strokeWidth: 1,
                                child: Icon(
                                  Icons.account_circle_rounded,
                                  size: 85,
                                  color: colors[usersData[index]['color']],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  usersData[index]['nombre'],
                                  style: TiposBlue.bodyBold,
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(
          Icons.gavel,
          color: PageColors.yellow,
        ),
        backgroundColor: PageColors.blue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomTab(context),
    );
  }

  _buildBottomTab(context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20.0),
        topRight: Radius.circular(20.0),
      ),
      child: BottomAppBar(
        color: PageColors.blue,
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyApp(),
                      ));
                },
                child: const TabItem(icon: Icons.home)),
            GestureDetector(
                onTap: () {}, child: const TabItem(icon: Icons.account_circle))
          ],
        ),
      ),
    );
  }
}
