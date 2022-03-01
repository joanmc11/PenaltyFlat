import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:penalty_flat_app/Styles/colors.dart';
import 'package:penalty_flat_app/models/user.dart';
import 'package:penalty_flat_app/screens/multar/poner_multa.dart';
import 'package:penalty_flat_app/screens/penaltyflat/llista_multas.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';



class Calendario extends StatefulWidget {
  final String sesionId;

  const Calendario({
    Key? key,
    required this.sesionId,
  }) : super(key: key);

  @override
  _CalendarioState createState() => _CalendarioState();
}

CalendarFormat format = CalendarFormat.month;


class _CalendarioState extends State<Calendario> {
  DateTime _selectedDay = dateToday;
  DateTime _focusedDay = dateToday;

  
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
            calendarStyle: const CalendarStyle(),
            calendarFormat: format,
            onFormatChanged: (CalendarFormat _format) {
              setState(() {
                format = _format;
              });
            },
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay; // update `_focusedDay` here as well
              });
            },
            daysOfWeekVisible: true,
            headerStyle: const HeaderStyle(
                formatButtonVisible: true, formatButtonShowsNext: true),
          ),
         
          
          
          
        ],
      ),
    );
  }
}