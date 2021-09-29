import 'dart:async';
import 'package:air_quality/algorithms/storage.dart';
import 'package:air_quality/pages/air.dart';
import 'package:animate_icons/animate_icons.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart' hide AnimatedScale;
import 'package:rive/rive.dart' hide LinearGradient;

import 'covid.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final databaseRef =
      FirebaseDatabase.instance.reference(); //database reference object

  void addData(String data) {
    databaseRef.push().set({'device': data});
  }

  Artboard _riveArtboard;
  bool absorb = false;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  bool touch = true;
  AnimateIconController controller;

  @override
  void initState() {
    super.initState();
    Store.exec();
    fcmSubscribe();

    rootBundle.load('assets/bubles.riv').then(
      (data) async {
        var file = RiveFile.import(data);
        if (file != null) {
          var artboard = file.mainArtboard;
          artboard.addController(
            SimpleAnimation('start'),
          );
          if (mounted) {
            setState(() => _riveArtboard = artboard);
          }
        }
      },
    );
    controller = AnimateIconController();
  }

  void fcmSubscribe() {
    _fcm.subscribeToTopic("TopicName");
  }

  @override
  Widget build(BuildContext context) {
    final theme = NeumorphicTheme.currentTheme(context);
    return Scaffold(
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
                child: NeumorphicButton(
                  style: NeumorphicStyle(color: theme.variantColor),
                  child: Center(
                      child: Text(
                    'Air Quality',
                    style: TextStyle(
                        color: theme.defaultTextColor,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  )),
                  onPressed: () {
                    setState(() {
                      absorb = true;
                    });
                    Timer(Duration(milliseconds: 300), () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => Air(),
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
            child: Column(
              children: [
                Stack(
                  children: [
                    AnimateIcons(
                      startIcon: Icons.coronavirus_outlined,
                      endIcon: Icons.coronavirus,
                      size: 50.0,
                      controller: controller,
                      // add this tooltip for the start icon
                      startTooltip: 'Icons.coronavirus_outlined',
                      // add this tooltip for the end icon
                      endTooltip: 'Icons.coronavirus',
                      onStartIconPress: () {
                        controller.animateToEnd();
                        Timer(Duration(milliseconds: 500), () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => COVID(),
                              ));
                          setState(() {
                            absorb = false;
                          });
                        });
                        return true;
                      },
                      onEndIconPress: () {
                        controller.animateToEnd();
                        Timer(Duration(milliseconds: 650), () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => COVID(),
                              ));
                          setState(() {
                            absorb = false;
                          });
                        });
                        return true;
                      },
                      duration: Duration(milliseconds: 500),
                      startIconColor: Colors.white,
                      endIconColor: Colors.white,
                      clockwise: false,
                    ),
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.all(Radius.circular(360))
                        ),
                      ),
                    )
                  ],
                ),
                Text(
                  "COVID-19",
                  style: TextStyle(
                    color: theme.defaultTextColor,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
