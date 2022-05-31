import 'package:penalty_flat_app/models/usersInside.dart';

import 'package:collection/collection.dart';

class FunctionService {
  Map<String, double> sectionChart(List<InsideUser> usersData) {
    Map<String, double> sectionsChart = {};
    for (int i = 0; i < usersData.length; i++) {
      sectionsChart[usersData[i].nombre] = usersData[i].dinero.toDouble();
    }
    return sectionsChart;
  }

  num dineroMultas(List<InsideUser> usersData) {
    List<num> dineroMultas = [];
    for (int i = 0; i < usersData.length; i++) {
      dineroMultas.add(usersData[i].dinero);
    }
    final num totalMultas = dineroMultas.sum;
    return totalMultas;
  }

  DateTime takeDate() {
    DateTime dateToday = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        DateTime.now().hour,
        DateTime.now().minute,
        DateTime.now().second);
    return dateToday;
  }



  String porcentajeMultas (userMoney, totalMultas) {
     return ((userMoney / totalMultas) * 100).toStringAsFixed(1);
  }
}
