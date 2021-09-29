import 'dart:async';

import 'package:air_quality/algorithms/apis.dart';
import 'package:air_quality/algorithms/storage.dart';
import 'package:air_quality/pages/air_quality.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart' hide AnimatedScale;

String api = 'ff677b8db486de02b5effc8891a86899';
var forecast;
Map<String, dynamic> mapContent = {};
String components = "";

class Air extends StatefulWidget {
  @override
  _AirState createState() => _AirState();
}

class _AirState extends State<Air> {
  void getAirVisual() async {
    List listLocation = await Store.readFile();
    String city = listLocation[0];
    double lat = double.parse(listLocation[1]);
    double lon = double.parse(listLocation[2]);

    print("$city");
    forecast = await APIs.airVisual(lat.toString(), lon.toString(), api);

    print(lat);
    print(lon);
    components = forecast[0]['components'].toString();
    print(listLocation);
    var listContent = components.substring(1, components.length).split(", ");
    listContent.reversed.forEach((child) {
      String elementString = child.toString().replaceAll('[]{}', '');
      List element = elementString.split(', ');
      element.forEach((valueUnformatted) {
        String value = valueUnformatted.replaceAll('{', '');
        value = value.replaceAll('}', '');
        mapContent['${value.substring(0, value.indexOf(":"))}'] = value
            .substring(value.indexOf(": "), value.length)
            .replaceAll(':', '');
      });
    });
    print(mapContent);
    setState(() {
      mapContent = mapContent;
    });
  }
  bool absorb = false;
  @override
  void initState() {
    getAirVisual();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = NeumorphicTheme.currentTheme(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
        elevation: 0,
        backgroundColor: theme.baseColor,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 100,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 20, right: 20),
            child: Container(
              height: 50,
              width: 300,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: theme.variantColor),
              child: Center(
                child: Text(
                  "Dữ liệu từ OpenWeather",
                  style: TextStyle(
                    color: theme.defaultTextColor,
                    fontSize: 15
                  ),

                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: NeumorphicButton(
              onPressed: () {},
              child: Center(
                child: DefaultTextStyle(
                  style: TextStyle(color: theme.defaultTextColor, fontSize: 15),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Wrap(
                      children: [
                        Row(
                          children: [
                            Expanded(child: Text("CO: ${mapContent["co"] ?? "..." }\u00b5g/m\u00b3")),
                            Text("NO: ${mapContent["no"] ?? "..." }\u00b5g/m\u00b3"),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(child: Text("NO2: ${mapContent["no2"] ?? "..." }\u00b5g/m\u00b3")),
                            Text("O3: ${mapContent["o3"] ?? "..." }\u00b5g/m\u00b3"),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(child: Text("SO2: ${mapContent["so2"] ?? "..." }\u00b5g/m\u00b3")),
                            Text("NH3: ${mapContent["nh3"] ?? "..." }\u00b5g/m\u00b3"),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Text("PM10: ${mapContent["pm10"] ?? "..." }\u00b5g/m\u00b3")),
                            Text("PM2.5: ${mapContent["pm2_5"] ?? "..." }\u00b5g/m\u00b3"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          AbsorbPointer(
            absorbing: absorb,
            child: NeumorphicButton(
              child: Text(
                "Đánh giá chất lượng không khí bằng Airify",
                style: TextStyle(
                  color: theme.defaultTextColor
                ),
              ),
              onPressed: () {
                setState(() {
                  absorb = true;
                });
                Timer(Duration(milliseconds: 300), () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => AirQuality(),
                      ));
                  setState(() {
                    absorb = false;
                  });
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
