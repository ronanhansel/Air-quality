import 'package:air_quality/pages/air_quality.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart' hide LinearGradient;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Artboard _riveArtboard;
  RiveAnimationController _controller;

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
          Container(
            child: Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => AirQuality(),
                      ));
                },
                child: Container(
                  height: 230,
                  width: 230,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Color(0xFF42E695), Color(0xFF3BB2B8)]),
                    borderRadius: BorderRadius.all(Radius.circular(360)),
                  ),
                  child: Center(
                    child: Text(
                      'Air quality',
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
