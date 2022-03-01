import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:penalty_flat_app/Styles/colors.dart';
import 'package:penalty_flat_app/screens/penaltyflat/crearMulta/crear_multa.dart';
import 'package:penalty_flat_app/screens/penaltyflat/ver_multa.dart';
import 'package:string_extensions/string_extensions.dart';

class CodigoMultas extends StatefulWidget {
  final String sesionId;
  const CodigoMultas({
    Key? key,
    required this.sesionId,
  }) : super(key: key);

  @override
  _CodigoMultasState createState() => _CodigoMultasState();
}

class _CodigoMultasState extends State<CodigoMultas> {
  int selectedIndex = 0;
  bool selected = true;
  bool _folded = true;
  bool todas = true;
  String parte = "Todas";
  String search = "";

  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                      color: PageColors.blue,
                      borderRadius:
                          const BorderRadius.only(topRight: Radius.circular(20))),
                  //Lista Partes Casa
                  child: StreamBuilder(
                      stream: db.doc("sesion/${widget.sesionId}").snapshots(),
                      builder: (
                        BuildContext context,
                        AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                            snapshot,
                      ) {
                        if (snapshot.hasError) {
                          return ErrorWidget(snapshot.error.toString());
                        }
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        final casaData = snapshot.data!.data()!;

                        return ListView.separated(
                          itemCount: casaData['partes'].length,
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
                                  parte = casaData['partes'][index];
                                  parte == "Todas"
                                      ? todas = true
                                      : todas = false;
                                });
                              },
                              child: SingleChildScrollView(
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
                                                  ? Colors.blueGrey
                                                      .withOpacity(0.15)
                                                  : Colors.transparent,
                                              borderRadius: const BorderRadius.all(
                                                  Radius.circular(10))),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 0, horizontal: 5),
                                            child: Text(
                                                casaData['partes'][index],
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  color: PageColors.yellow,
                                                  fontWeight:
                                                      (selectedIndex == index
                                                          ? FontWeight.bold
                                                          : FontWeight.normal),
                                                )),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }),
                ),
              ),
              Expanded(
                flex: 9,
                child: Container(
                  decoration: const BoxDecoration(color: Colors.white),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 30),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 400),
                            width: _folded ? 56 : 250,
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
                                          topRight: Radius.circular(32),
                                          bottomLeft:
                                              Radius.circular(_folded ? 32 : 0),
                                          bottomRight: Radius.circular(32)),
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
                          ),
                        ),
                      ),
                      Flexible(
                        child: StreamBuilder(
                          stream: !_folded && search != ""
                              ? db
                                  .collection(
                                      "sesion/${widget.sesionId}/codigoMultas")
                                  .where('titulo',
                                      isGreaterThanOrEqualTo:
                                          search.toLowerCase())
                                  .where('titulo',
                                      isLessThan: search
                                              .toLowerCase()
                                              .substring(
                                                  0,
                                                  search.toLowerCase().length -
                                                      1) +
                                          String.fromCharCode(search
                                                  .toLowerCase()
                                                  .codeUnitAt(
                                                      search.length - 1) +
                                              1))
                                  .snapshots()
                              : todas
                                  ? db
                                      .collection(
                                          "sesion/${widget.sesionId}/codigoMultas")
                                      .snapshots()
                                  : db
                                      .collection(
                                          "sesion/${widget.sesionId}/codigoMultas")
                                      .where('parte', isEqualTo: parte)
                                      .snapshots(),
                          builder: (
                            BuildContext context,
                            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                snapshot,
                          ) {
                            if (snapshot.hasError) {
                              return ErrorWidget(snapshot.error.toString());
                            }
                            if (!snapshot.hasData) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            final codigoMultas = snapshot.data!.docs;

                            return StreamBuilder(
                              stream: db
                                  .doc("sesion/${widget.sesionId}")
                                  .snapshots(),
                              builder: (
                                BuildContext context,
                                AsyncSnapshot<
                                        DocumentSnapshot<Map<String, dynamic>>>
                                    snapshot,
                              ) {
                                if (snapshot.hasError) {
                                  return ErrorWidget(snapshot.error.toString());
                                }
                                if (!snapshot.hasData) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                                final casaData = snapshot.data!.data()!;
                                return casaData['sinMultas']
                                    ? SingleChildScrollView(
                                      child: SizedBox(
                                         height: MediaQuery.of(context).size.height / 1.5,
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      bottom: 8),
                                                  child: Center(
                                                    child: Text(
                                                      "Todavía no hay normas en tu código de multas",
                                                      textAlign: TextAlign.center,
                                                      style: TiposBlue.subtitle,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(16.0),
                                                  child: Center(
                                                    child: Text(
                                                      "Todos los intengrantes de esta casa pueden añadir y eliminar normas. Poneros de acuerdo y rellenad este vacío con todo lo que se os ocurra.",
                                                      textAlign: TextAlign.center,
                                                      style: TiposBlue.body,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      left: 8.0,
                                                      top: 4.0,
                                                      right: 8.0),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            const BorderRadius.all(
                                                          Radius.circular(10),
                                                        ),
                                                        border: Border.all(
                                                            color: Colors.grey
                                                                .withOpacity(0.3))),
                                                    child: ListTile(
                                                      title: Text(
                                                        "Carretera en el lavabo",
                                                        style: TextStyle(
                                                            color: PageColors.blue,
                                                            fontWeight:
                                                                FontWeight.bold),
                                                      ),
                                                      subtitle: Text(
                                                        "Dejar un rastro negro en el WC",
                                                        style: TextStyle(
                                                            color: PageColors.blue),
                                                      ),
                                                      trailing: GestureDetector(
                                                          onTap: () {},
                                                          child: const Text('0.5€')),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      left: 8.0,
                                                      top: 8.0,
                                                      right: 8.0),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            const BorderRadius.all(
                                                          Radius.circular(10),
                                                        ),
                                                        border: Border.all(
                                                            color: Colors.grey
                                                                .withOpacity(0.3))),
                                                    child: ListTile(
                                                      title: Text(
                                                        "Platos con telarañas",
                                                        style: TextStyle(
                                                            color: PageColors.blue,
                                                            fontWeight:
                                                                FontWeight.bold),
                                                      ),
                                                      subtitle: Text(
                                                        "Platos más de dos dias sin lavar",
                                                        style: TextStyle(
                                                            color: PageColors.blue),
                                                      ),
                                                      trailing: GestureDetector(
                                                          onTap: () {},
                                                          child: Text('2€')),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(16.0),
                                                  child: Text(
                                                    "Esto son ejemplos. Ten en cuenta que se borrarán al añadir una norma.",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: PageColors.blue),
                                                  ),
                                                ),
                                              ]),
                                      ),
                                    )
                                    : ListView.builder(
                                        itemCount: codigoMultas.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          final String? titulo =
                                              "${codigoMultas[index]['titulo']}"
                                                  .capitalize;
                                          final String? descripcion =
                                              "${codigoMultas[index]['descripcion']}"
                                                  .capitalize;

                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0, top: 4.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    Radius.circular(10),
                                                  ),
                                                  border: Border.all(
                                                      color: Colors.grey
                                                          .withOpacity(0.3))),
                                              child: ListTile(
                                                onTap: (() {
                                                 
                                                    Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            VerMulta(
                                                          sesionId:
                                                              widget.sesionId,
                                                              multaId: codigoMultas[index].id,
                                                              parte: codigoMultas[index]['parte'],
                                                              titulo: codigoMultas[index]['titulo'],
                                                              descripcion: codigoMultas[index]['descripcion'],
                                                              precio: codigoMultas[index]['precio'],
                                                        ),
                                                      ),
                                                    );
                                                    print("selected");
                                                  
                                                }),
                                                title: Text(
                                                  titulo!,
                                                  style: TextStyle(
                                                      color: PageColors.blue,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                subtitle: Text(
                                                  descripcion!,
                                                  style: TextStyle(
                                                      color: PageColors.blue),
                                                ),
                                                trailing: 
                                                  Text(
                                                      '${codigoMultas[index]['precio']}€'),
                                                
                                              ),
                                            ),
                                          );
                                        },
                                      );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => CrearMulta(
                  sesionId: widget.sesionId,
                ),
              ));
        },
        child: Icon(
          Icons.add,
          color: PageColors.yellow,
        ),
        backgroundColor: PageColors.blue,
        elevation: 2000,
      ),
    );
  }
}
