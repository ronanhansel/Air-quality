import 'package:air_quality/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pusher_beams_server/pusher_beams_server.dart';
import 'package:firebase_messaging/firebase_messaging.dart';




void main() {
  PushNotifications('f800f676-a0af-4fee-be95-06a8d254a474', '4FB41C68E36B684C59D679ABA4A0803363C2AE1D794BACA6F8CDD9EBB8FEB845');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return MaterialApp(
      title: 'Airify',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}