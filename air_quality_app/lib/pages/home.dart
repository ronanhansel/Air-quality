import 'dart:async';
import 'package:air_quality/pages/air_quality.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:neumorphic/neumorphic.dart';
import 'package:rive/rive.dart' hide LinearGradient;
import 'package:vibration/vibration.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Artboard _riveArtboard;
  RiveAnimationController _controller;
  bool absorb = false;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  bool touch = true;

  @override
  void initState() {
    super.initState();
    _fcm.getToken().then((token) {
      print(token);
    });
    //firebase messaging
    _fcm.configure(onMessage: (Map<String, dynamic> message) async {
      if (touch) {
        touch = false;
        showDialog(
            context: context,
            builder: (context) =>
                AlertDialog(
                  content: ListTile(
                    title: Text(message['notification']['title']),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(message['notification']['body']),
                    ),
                  ),
                  actions: [
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          touch = true;
                        },
                        child: Text('Ok'))
                  ],
                ));
        if (await Vibration.hasCustomVibrationsSupport()) {
          Vibration.vibrate(duration: 1000);
        } else {
          Vibration.vibrate();
          await Future.delayed(Duration(milliseconds: 500));
          Vibration.vibrate();
        }
      }
    });

    fcmSubscribe();

    rootBundle.load('assets/bubles.riv').then(
          (data) async {
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

  void fcmSubscribe() {
    _fcm.subscribeToTopic("TopicName");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe0e5ec),
      body: Stack(
        children: [
          Center(
            child: Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
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
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
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
            alignment: Alignment.topRight,
            child: Container(
              width: 170,
              height: 170,
              decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.zero,
                      topLeft: Radius.zero,
                      bottomRight: Radius.zero,
                      bottomLeft: Radius.circular(360))),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.zero,
                      topRight: Radius.circular(360),
                      bottomRight: Radius.zero,
                      bottomLeft: Radius.zero)),
            ),
          ),
        ],
      ),
    );
  }
}
