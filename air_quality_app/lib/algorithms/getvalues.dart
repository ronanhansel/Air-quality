import 'package:firebase_database/firebase_database.dart';


final database = FirebaseDatabase.instance.reference();

getData(var sensor) async {
  var number;

  await database.once().then((DataSnapshot snapshot) {
    number = snapshot.value["$sensor"];
  });
  return number;
}

getTips(String tips) async {
  var listTips;
  await database.once().then((DataSnapshot snapshot) {
    listTips = Map<String, dynamic>.from(snapshot.value[tips]);
  });
  return listTips;
}

getImages() async {
  var listImages;
  await database.once().then((DataSnapshot snapshot) {
    listImages = Map<String, dynamic>.from(snapshot.value['images']);
  });
  return listImages;
}
