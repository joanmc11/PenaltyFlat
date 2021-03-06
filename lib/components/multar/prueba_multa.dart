import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:penalty_flat_app/Styles/colors.dart';
import 'package:dotted_border/dotted_border.dart';
import 'dart:io';

class PruebaMultar extends StatefulWidget {
  final String sesionId;
  final String idMultado;
  final String multaId;
  final Function callbackImgPath;
  const PruebaMultar({
    Key? key,
    required this.sesionId,
    required this.idMultado,
    required this.multaId,
    required this.callbackImgPath,
  }) : super(key: key);

  @override
  _PruebaMultarState createState() => _PruebaMultarState();
}



class _PruebaMultarState extends State<PruebaMultar> {
  File? _image;
  
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "¿Tienes Pruebas?",
                style: TiposBlue.subtitle,
              ),
              Material(
                color: Colors.white.withOpacity(0.0),
                child: InkWell(
                  splashColor: Theme.of(context).primaryColorLight,
                  onTap: () async {
                    final image = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 10);
                    if (image == null) return;
                    setState(() {
                      _image=File(image.path) ;
                    });
                    
                    widget.callbackImgPath(image.name, _image);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DottedBorder(
                      radius: const Radius.circular(8),
                      borderType: BorderType.RRect,
                      dashPattern: const [5],
                      color: PageColors.blue,
                      strokeWidth: 0.5,
                      child: SizedBox(
                        height: 100,
                        width: 100,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: _image==null? Icon(
                            Icons.add_a_photo,
                            size: 40,
                            color: PageColors.blue,
                          ):
                          Image.file(_image!),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
