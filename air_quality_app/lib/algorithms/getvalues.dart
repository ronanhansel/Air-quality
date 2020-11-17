import 'package:firebase_database/firebase_database.dart';


final database = FirebaseDatabase.instance.reference();

getData(var sensor) async {
  var number;

  await database.once().then((DataSnapshot snapshot) {
    number = snapshot.value["$sensor"];
  });
  return number;
}

// getDataRepeat(var sensor) async {
//   var number;
//   database.onValue.listen((event) {
//     var snapshot = event.snapshot;
//     number = snapshot.value["$sensor"];
//     print('$number');
//   });
//   return number;
// }
