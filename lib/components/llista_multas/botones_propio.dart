
import 'package:flutter/material.dart';
import 'package:penalty_flat_app/Styles/colors.dart';

class ButtonPropio extends StatefulWidget {
  final Function callbackButton;

  const ButtonPropio({
    Key? key,
    required this.callbackButton,
  }) : super(key: key);

  @override
  _ButtonPropioState createState() => _ButtonPropioState();
}

class _ButtonPropioState extends State<ButtonPropio> {
  String selectedMonth = "Todas";
  int monthValue = 0;
  int yearValue = 0;
  bool mount = true;
  bool selected = true;

  @override
  Widget build(BuildContext context) {

    return Container(
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
              widget.callbackButton(selected);
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
              widget.callbackButton(selected);
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
    );
  }
}
