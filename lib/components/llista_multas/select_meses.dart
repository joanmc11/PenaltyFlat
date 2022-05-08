import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:penalty_flat_app/Styles/colors.dart';
import 'package:penalty_flat_app/services/sesionProvider.dart';
import 'package:provider/provider.dart';

class SelectMeses extends StatefulWidget {
  final Function callbackMes;

  const SelectMeses({
    Key? key,
    required this.callbackMes,
  }) : super(key: key);

  @override
  _SelectMesesState createState() => _SelectMesesState();
}

class _SelectMesesState extends State<SelectMeses> {
  String selectedMonth = "Todas";
  int monthValue = 0;
  int yearValue = 0;
  bool mount = true;
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;
    final idCasa = Provider.of<SesionProvider?>(context)!.sesionCode;
    return StreamBuilder(
        stream: db.collection("sesion/$idCasa/multas").snapshots(),
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
          final multasData = snapshot.data!.docs;
          List<String>? monthsYearsStrings = ["Todas"];
          List<int>? mValues = [0];
          List<int> yValues = [0];
          for (int i = 0; i < multasData.length; i++) {
            DateTime date =
                DateTime.fromMicrosecondsSinceEpoch(multasData[i]['fecha'].microsecondsSinceEpoch);

            String dateString = DateFormat("MMMM yyy", "es_ES").format(date);
            int year = int.parse(DateFormat('yyyy').format(date));
            int month = int.parse(DateFormat('MM').format(date));

            monthsYearsStrings.contains(dateString) ? null : monthsYearsStrings.add(dateString);

            if (!mValues.contains(month) || !yValues.contains(year)) {
              yValues.add(year);
              mValues.add(month);
            }
          }

          return DropdownButton(
            hint: const Text("Selecciona"),
            dropdownColor: PageColors.white,
            borderRadius: BorderRadius.circular(20),
            value: selectedMonth,
            items: monthsYearsStrings.map((valuesItem) {
              int index = monthsYearsStrings.indexOf(valuesItem);

              return DropdownMenuItem(
                onTap: () {
                  setState(() {
                    currentIndex = index;
                    mount = false;
                  });
                },
                value: valuesItem,
                child: Text(valuesItem),
              );
            }).toList(),
            onChanged: (String? value) {
              setState(() {
                selectedMonth = value!;
                yearValue = yValues[currentIndex];
                monthValue = mValues[currentIndex];
              });
              widget.callbackMes(selectedMonth, monthValue, yearValue, currentIndex);
            },
          );
        });
  }
}
