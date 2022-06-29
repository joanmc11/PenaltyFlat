
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:penalty_flat_app/models/usersInside.dart';
import 'dart:io';
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

  Future imagenMulta(context, callbackImgPath, Function callbackImage) async {
    await showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: const Text(
                "Aporta una imagen como prueba",
                textAlign: TextAlign.center,
              ),
              alignment: Alignment.center,
              actionsAlignment: MainAxisAlignment.spaceEvenly,
              actions: [
                TextButton(
                  onPressed: () async {
                    final image = await ImagePicker().pickImage(
                        source: ImageSource.camera, imageQuality: 10);
                    if (image == null) return;

                    final imageFile = File(image.path);
                    callbackImage(imageFile);

                    callbackImgPath(image.name, imageFile);
                    Navigator.of(context).pop();
                  },
                  child: Column(
                    children: const [
                      Icon(Icons.camera),
                      Text("Camera"),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    final image = await ImagePicker().pickImage(
                        source: ImageSource.gallery, imageQuality: 10);
                    if (image == null) return;

                    final imageFile = File(image.path);
                    callbackImage(imageFile);

                    callbackImgPath(image.name, imageFile);
                    Navigator.of(context).pop();
                  },
                  child: Column(
                    children: const [
                      Icon(Icons.image),
                      Text("Galeria"),
                    ],
                  ),
                ),
              ],
            ),
        barrierDismissible: true);
  }



  String porcentajeMultas (userMoney, totalMultas) {
     return ((userMoney / totalMultas) * 100).toStringAsFixed(1);
  }
}
