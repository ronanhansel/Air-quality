import 'dart:async';

import 'package:air_quality/algorithms/getvalues.dart';
import 'package:air_quality/pages/air_quality.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:neumorphic/neumorphic.dart';
import 'package:rive/rive.dart' hide LinearGradient;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Artboard _riveArtboard;
  RiveAnimationController _controller;
  bool absorb = false;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  int humid = 0;
  double temp = 0.0;

  @override
  void initState() {
    _fcm.getToken().then((token) {
      print(token);
    });
    //firebase messaging
    _fcm.configure(onMessage: (Map<String, dynamic> message) async {
      print("onMessage: $message");
      final snackbar = SnackBar(
          content: Text(message['notification']['title']),
          action: SnackBarAction(
            label: 'Go',
            onPressed: () => null,
          ));
      Scaffold.of(context).showSnackBar(snackbar);
    });

    super.initState();

    rootBundle.load('assets/bubles.riv').then(
      (data) async {
        await getDataRepeatHumid();
        await getDataRepeatTemp();

        var file = RiveFile();
        var success = file.import(data);
        if (success) {
          var artboard = file.mainArtboard;
          artboard.addController(
            _controller = SimpleAnimation('start'),
          );
          setState(() => _riveArtboard = artboard);
        }
      },
    );
  }

  getDataRepeatHumid() async {
    var number;
    database.onValue.listen((event) {
      var snapshot = event.snapshot;
      number = snapshot.value["humid"];
      if (mounted) {
        setState(() {
          humid = number;
        });
      }
    });
    return number;
  }

  getDataRepeatTemp() async {
    var number;
    database.onValue.listen((event) {
      var snapshot = event.snapshot;
      number = snapshot.value["temp"];
      if (mounted) {
        setState(() {
          temp = number;
        });
      }
    });
    return number;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe0e5ec),
      body: Stack(
        children: [
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: _riveArtboard == null
                  ? const SizedBox()
                  : Rive(
                      fit: BoxFit.fitHeight,
                      artboard: _riveArtboard,
                    ),
            ),
          ),
          Center(
            child: Container(
              height: 230,
              width: 230,
              child: AbsorbPointer(
                absorbing: absorb,
                child: NeuButton(
                  child: Center(
                      child: Text(
                    'Air Quality',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  )),
                  decoration: NeumorphicDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.all(Radius.circular(40))),
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
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              width: 300,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(360),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(child: SizedBox()),
                    Text(
                      'Độ ẩm: $humid%, Nhiệt độ: $temp C',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
