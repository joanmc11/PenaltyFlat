
import 'package:cloud_firestore/cloud_firestore.dart';


class DatabaseService {

  final String uid;
  DatabaseService({required this.uid});

  //collection reference
 final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

  Future updateUserdata(String nombre) async{
    return await userCollection.doc(uid).set({
      'nombre': nombre,
      
    });
    
  }

  Future updateUserFlats(String nombreCasa, String idCasa) async{
    return await userCollection.doc(uid).collection('casas').add({
      'nombreCasa': nombreCasa,
      'idCasa': idCasa,
    });
    
  }
  

  Stream<QuerySnapshot> get users{
    return userCollection.snapshots();
  }

    
  }