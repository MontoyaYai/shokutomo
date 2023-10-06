import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore database  = FirebaseFirestore.instance;

Future <List> getTest() async{
  List test = [];

  CollectionReference collectionReferenceTest = database.collection('Test ');


  QuerySnapshot queryTest = await collectionReferenceTest.get();

  queryTest.docs.forEach((document) {

    test.add(document.data());

  });

  return test;
}
