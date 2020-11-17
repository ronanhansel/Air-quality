import 'dart:async';

import 'package:air_quality/pages/air_quality.dart';
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

  @override
  void initState() {
    super.initState();

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
        ],
      ),
    );
  }
}
