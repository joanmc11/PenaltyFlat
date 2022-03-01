import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:penalty_flat_app/Styles/colors.dart';
import 'package:penalty_flat_app/screens/multar/poner_multa.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../models/user.dart';

class PantallaMultas extends StatefulWidget {
  final String sesionId;

  const PantallaMultas({
    Key? key,
    required this.sesionId,
  }) : super(key: key);

  @override
  _PantallaMultasState createState() => _PantallaMultasState();
}

DateTime _selectedDay = dateToday;
DateTime _focusedDay = dateToday;

class _PantallaMultasState extends State<PantallaMultas> {
  bool selected = true;
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: DateTime.now(),
            locale: 'es_ES',
            calendarStyle: CalendarStyle() ,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay; // update `_focusedDay` here as well
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50.0, bottom: 25),
            child: Text(
              "Multas Febrero 2022",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: PageColors.blue),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selected = true;
                    });
                  },
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 50),
                      child: Text(
                        "Todos",
                        style: TextStyle(
                            color: PageColors.yellow,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: (selected ? PageColors.blue : Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selected = false;
                    });
                  },
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 50),
                      child: Text(
                        "Propio",
                        style: TextStyle(
                            color: PageColors.yellow,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: (!selected ? PageColors.blue : Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          StreamBuilder(
              stream: selected
                  ? db
                      .collection("sesion/${widget.sesionId}/multas")
                      .orderBy('fecha')
                      .snapshots()
                  : db
                      .collection("sesion/${widget.sesionId}/multas")
                      .where('idMultado', isEqualTo: user!.uid)
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
                final multasSesion = snapshot.data!.docs;
                return Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 20.0),
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemExtent: 55.0,
                      itemCount: multasSesion.isEmpty ? 1 : multasSesion.length,
                      itemBuilder: (context, index) {
                        return multasSesion.isEmpty
                            ? Align(
                                alignment: Alignment.bottomCenter,
                                child: Text(
                                  "Todavía no tienes multas",
                                  style: TiposBlue.body,
                                ))
                            : ListTile(
                                title: Text(multasSesion[index]['nomMultado'],
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: PageColors.blue,
                                        fontWeight: FontWeight.bold)),
                                subtitle: Text(
                                  multasSesion[index]['titulo'],
                                  style: TextStyle(
                                      fontSize: 14, color: PageColors.blue),
                                ),
                                trailing:
                                    Text("${multasSesion[index]['precio']}€"),
                              );
                      },
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
