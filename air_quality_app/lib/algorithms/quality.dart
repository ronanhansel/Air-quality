import 'package:air_quality/algorithms/getvalues.dart';

String status;
Future<String> quality135 () async {
  var index135 = await getData(135);
  var index5 = await getData(5);
  var index7 = await getData(7);
  var index = (index5 + index7 + index135) / 3;
  if (index <= 270) {
    status = 'fresh';
    return status;
  } else if (270 < index && index <= 350) {
    status = 'quite';
    return status;
  } else if (360 < index && index <= 440) {
    status = 'not good';
    return status;
  } else if (440 < index && index <= 600) {
    status = 'bad';
    return status;
  } else if (index > 600) {
    status = 'hazardous';
    return status;
  } else {
    status = 'fresh';
    return status;
  }

}