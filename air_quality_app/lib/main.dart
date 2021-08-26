import 'package:air_quality/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return FutureBuilder(
      // Initialize FlutterFire
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        // Once complete, show application
        if (snapshot.connectionState == ConnectionState.done) {
          return NeumorphicApp(
            debugShowCheckedModeBanner: false,
            title: 'Airify',
            themeMode: ThemeMode.dark,
            //or dark / system
            darkTheme: NeumorphicThemeData(
              baseColor: Color(0xff333333),
              defaultTextColor: Colors.white,
              accentColor: Colors.green,
              variantColor: Color(0xff636363),
              lightSource: LightSource.topLeft,
              depth: 4,
              intensity: 0.3,
            ),
            theme: NeumorphicThemeData(
              baseColor: Color(0xffDDDDDD),
              accentColor: Colors.cyan,
              lightSource: LightSource.topLeft,
              depth: 6,
              intensity: 0.5,
            ),
            home: Home(),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Container(
          color: Colors.white,
          child: SpinKitSquareCircle(
            color: Colors.grey,
          ),
        );
      },
    );
  }
}
