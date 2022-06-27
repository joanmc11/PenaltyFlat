
import 'package:flutter/material.dart';
import 'package:penalty_flat_app/Styles/colors.dart';
class ZonasCasa extends StatefulWidget {
  final Function callbackParte;
  const ZonasCasa({Key? key, required this.callbackParte}) : super(key: key);

  @override
  _ZonasCasaState createState() => _ZonasCasaState();
}

class _ZonasCasaState extends State<ZonasCasa> {
  int selectedIndex = 0;
  bool todas = true;
  String parte = "Todas";

  @override
  Widget build(BuildContext context) {
   
    List<String> partes = ["Todas", "Baño", "Comedor", "Cocina", "Lavadero", "Otros"];

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
          color: PageColors.blue,
          borderRadius: const BorderRadius.only(topRight: Radius.circular(20))),
      //Lista Partes Casa
      child: ListView.separated(
              itemCount: partes.length,
              separatorBuilder: (
                BuildContext context,
                int index,
              ) {
                return const SizedBox(height: 10);
              },
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                      parte = partes[index];
                      parte == "Todas" ? todas = true : todas = false;
                    });
                    widget.callbackParte(parte, todas);
                  },
                  child: Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: (selectedIndex == index ? 40 : 0),
                        width: 2,
                        color: PageColors.yellow,
                      ),
                      Expanded(
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: Container(
                            alignment: Alignment.center,
                            height: 50,
                            decoration: BoxDecoration(
                                color: (selectedIndex == index)
                                    ? Colors.blueGrey.withOpacity(0.15)
                                    : Colors.transparent,
                                borderRadius: const BorderRadius.all(Radius.circular(10))),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                              child: Text(partes[index],
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: PageColors.yellow,
                                    fontWeight: (selectedIndex == index
                                        ? FontWeight.bold
                                        : FontWeight.normal),
                                  )),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        
    );
  }
}
