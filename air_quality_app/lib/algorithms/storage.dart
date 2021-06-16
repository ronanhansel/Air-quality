import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:geocoder/geocoder.dart';
import 'package:air_quality/algorithms/apis.dart';

class Store {
  static exec() async {
    List list = await getLocation();
    writeFile(list.toString());
  }

  static Future<List> getLocation() async {
    var position = await APIs.findPosition();
    double lat = position.latitude;
    double lon = position.longitude;
    final coordinates = Coordinates(lat, lon);

    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    List addressLine = first.addressLine.split(",");
    String cityWithPostalNumber = addressLine[3];
    var city = cityWithPostalNumber.replaceAll(r"[0-9]", '');
    List locate = [city, lat, lon];
    return locate;
  }

  static Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  static Future<File> get localFile async {
    final path = await localPath;
    return File('$path/dataUser.txt');
  }

  static Future<File> writeFile(String data) async {
    final file = await localFile;

    // Write the file
    return file.writeAsString(data);
  }

  static Future<List> readFile() async {
    try {
      final file = await localFile;

      // Read the file
      final contents = await file.readAsString();
      String noBrackets = contents.substring(1, contents.lastIndexOf("]"));
      List addressLine = noBrackets.split(", ");
      return addressLine;
    } catch (e) {
      // If encountering an error, return 0
      print(e);
      return [];
    }
  }
}
// class StoreCovidConfirmed {
//   static exec() async {
//     String list = await CSSEGICovidData.getRawConfirmedData().toString();
//     writeFile(list.toString());
//   }
//   static Future<String> get localPath async {
//     final directory = await getApplicationDocumentsDirectory();
//
//     return directory.path;
//   }
//
//   static Future<File> get localFile async {
//     final path = await localPath;
//     return File('$path/dataCovidConfirmed.txt');
//   }
//
//   static Future<File> writeFile(String data) async {
//     final file = await localFile;
//
//     // Write the file
//     return file.writeAsString(data);
//   }
//
//   static Future<List> readFile() async {
//     try {
//       final file = await localFile;
//
//       // Read the file
//       final contents = await file.readAsString();
//       String noBrackets = contents.substring(1, contents.lastIndexOf("]"));
//       List addressLine = noBrackets.split(", ");
//       return addressLine;
//     } catch (e) {
//       // If encountering an error, return 0
//       print(e);
//       return [];
//     }
//   }
// }
// class StoreCovidRecovered {
//   static exec() async {
//     String list = await CSSEGICovidData.getRawRecoveredData().toString();
//     writeFile(list.toString());
//   }
//   static Future<String> get localPath async {
//     final directory = await getApplicationDocumentsDirectory();
//
//     return directory.path;
//   }
//
//   static Future<File> get localFile async {
//     final path = await localPath;
//     return File('$path/dataCovidRecovered.txt');
//   }
//
//   static Future<File> writeFile(String data) async {
//     final file = await localFile;
//
//     // Write the file
//     return file.writeAsString(data);
//   }
//
//   static Future<List> readFile() async {
//     try {
//       final file = await localFile;
//
//       // Read the file
//       final contents = await file.readAsString();
//       String noBrackets = contents.substring(1, contents.lastIndexOf("]"));
//       List addressLine = noBrackets.split(", ");
//       return addressLine;
//     } catch (e) {
//       // If encountering an error, return 0
//       print(e);
//       return [];
//     }
//   }
// }
// class StoreCovidDeaths {
//   static exec() async {
//     String list = await CSSEGICovidData.getRawDeathsData().toString();
//     writeFile(list.toString());
//   }
//   static Future<String> get localPath async {
//     final directory = await getApplicationDocumentsDirectory();
//
//     return directory.path;
//   }
//
//   static Future<File> get localFile async {
//     final path = await localPath;
//     return File('$path/dataCovidDeaths.txt');
//   }
//
//   static Future<File> writeFile(String data) async {
//     final file = await localFile;
//
//     // Write the file
//     return file.writeAsString(data);
//   }
//
//   static Future<List> readFile() async {
//     try {
//       final file = await localFile;
//
//       // Read the file
//       final contents = await file.readAsString();
//       String noBrackets = contents.substring(1, contents.lastIndexOf("]"));
//       List addressLine = noBrackets.split(", ");
//       return addressLine;
//     } catch (e) {
//       // If encountering an error, return 0
//       print(e);
//       return [];
//     }
//   }
// }