import 'package:air_quality/algorithms/getvalues.dart';

String status;
Future<String> quality135 () async {
  double index135 = await getData(135);
  double index5 = await getData(5);
  double index7 = await getData(7);
  double index = index5 + index7 + index135;
  print (index);
  if (index <= 20) {
    status = 'fresh';
    return status;
  } else if (20 <= index && index <= 30) {
    status = 'quite';
    return status;
  } else if (30 <= index && index <= 40) {
    status = 'not good';
    return status;
  } else if (40 <= index && index <= 50) {
    status = 'bad';
    return status;
  } else if (index >= 50) {
    status = 'hazardous';
    return status;
  } else {
    status = 'fresh';
    return status;
  }

}