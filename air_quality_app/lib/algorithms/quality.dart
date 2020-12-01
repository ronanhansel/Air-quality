import 'package:air_quality/algorithms/getvalues.dart';

String status;
Future<String> quality135 () async {
  var index135 = await getData(135);
  var index5 = await getData(5);
  var index7 = await getData(7);
  var index = (index5 + index7 + index135) / 3;
  if (index <= 500) {
    status = 'fresh';
    return status;
  } else if (500 < index && index <= 700) {
    status = 'quite';
    return status;
  } else if (700 < index && index <= 800) {
    status = 'not good';
    return status;
  } else if (800 < index && index <= 900) {
    status = 'bad';
    return status;
  } else if (index > 900) {
    status = 'hazardous';
    return status;
  } else {
    status = 'fresh';
    return status;
  }

}