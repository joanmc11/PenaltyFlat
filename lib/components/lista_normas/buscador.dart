
import 'package:flutter/material.dart';
import 'package:penalty_flat_app/Styles/colors.dart';

class Buscador extends StatefulWidget {
  final double width;
  final Function callbackSearch;
  const Buscador(
      {Key? key, required this.width, required this.callbackSearch})
      : super(key: key);

  @override
  _BuscadorState createState() => _BuscadorState();
}

class _BuscadorState extends State<Buscador> {
  
 
  bool _folded = true;
  String search = "";

  @override
  Widget build(BuildContext context) {
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      width: _folded ? 56 : widget.width,
      alignment: Alignment.bottomRight,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: kElevationToShadow[1],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 16),
              child: !_folded
                  ? TextField(
                      decoration: InputDecoration(
                          hintText: 'Busca una multa',
                          hintStyle: TextStyle(
                            color: PageColors.blue,
                          ),
                          border: InputBorder.none),
                      onChanged: (value) {
                        setState(() {
                          search = value;
                        });
                        // debugPrint(search);
                        widget.callbackSearch(search, _folded);
                      },
                    )
                  : null,
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                borderRadius: BorderRadius.only(
                    topLeft:
                        Radius.circular(_folded ? 32 : 0),
                    topRight: const Radius.circular(32),
                    bottomLeft:
                        Radius.circular(_folded ? 32 : 0),
                    bottomRight:
                        const Radius.circular(32)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Icon(
                    _folded ? Icons.search : Icons.close,
                    color: PageColors.blue,
                  ),
                ),
                onTap: () {
                  setState(() {
                    _folded = !_folded;
                    if (_folded) {
                      search = "";
                    }
                  });
                },
              ),
            ),
          )
        ],
      ),
    );
      
    
  }
}
