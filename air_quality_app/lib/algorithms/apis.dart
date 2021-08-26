import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class APIs {
  static Future<List> airVisual(String lat, String lon, String api) async{
    final response = await http.get(Uri.parse(
        'http://api.openweathermap.org/data/2.5/air_pollution?lat=$lat&lon=$lon&appid=$api'));
    final Map parsed = jsonDecode(response.body);
    return parsed['list'];
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  static Future<Position> findPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}

class CovidData {
  static Future<List> getRawDeathsData () async {
    final response = (await http.get(Uri.parse('https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master'
        '/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv'))).body;
    String vnData = response.substring(response.indexOf("Vietnam"), response.indexOf(",West "));
    List data = vnData.split(",");
    return data;
  }
  static Future<List> getRawConfirmedData () async {
    final response = (await http.get(Uri.parse('https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master'
        '/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv'))).body;
    String vnData = response.substring(response.indexOf("Vietnam"), response.indexOf(",West "));
    List data = vnData.split(",");
    return data;
  }
  static Future<List> getRawRecoveredData () async {
    final response = (await http.get(Uri.parse('https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master'
        '/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_recovered_global.csv'))).body;
    String vnData = response.substring(response.indexOf("Vietnam"), response.indexOf(",West "));
    List data = vnData.split(",");
    return data;
  }
  static Future<List> getJSONVaccinationData () async {
    final response = (await http.get(Uri.parse('https://raw.githubusercontent.com/owid/covid-19-data/master'
        '/public/data/vaccinations/vaccinations.json'))).body;
    List<dynamic> rawData = jsonDecode(response);
    List<String> countries = [];
    rawData.forEach((element) {
      Map<String, dynamic> vnData = element;
      countries.add(vnData["country"] ?? "null");
    });
    List data = rawData[countries.indexOf("Vietnam", 190)]["data"];

    /*
    "country": "Vietnam",
    "iso_code": "VNM",
    "data": [
    {
    "date": "2021-03-07",
    "total_vaccinations": 0,
    "people_vaccinated": 0,
    "people_fully_vaccinated": 0,
    "total_vaccinations_per_hundred": 0.0,
    "people_vaccinated_per_hundred": 0.0
    },
     */
    return data;
  }
}