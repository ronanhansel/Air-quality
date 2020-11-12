import 'package:firebase_database/firebase_database.dart';

final database = FirebaseDatabase.instance.reference();
getData(var sensor) async {
  var number;

  await database.once().then((DataSnapshot snapshot) {
    number = snapshot.value["$sensor"];
  });
  return number;
}