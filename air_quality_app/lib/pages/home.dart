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
  bool get isPlaying => _controller?.isActive ?? false;

  Artboard _riveArtboard;
  RiveAnimationController _controller;

  @override
  void initState() {
    super.initState();

    // Load the animation file from the bundle, note that you could also
    // download this. The RiveFile just expects a list of bytes.
    rootBundle.load('assets/bubles.riv').then(
      (data) async {
        var file = RiveFile();

        // Load the RiveFile from the binary data.
        var success = file.import(data);
        if (success) {
          // The artboard is the root of the animation and is what gets drawn
          // into the Rive widget.
          var artboard = file.mainArtboard;
          // Add a controller to play back a known animation on the main/default
          // artboard.We store a reference to it so we can toggle playback.
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
                child: Hero(
                  tag: "air_quality",
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      height: 250,
                      width: 250,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Color(0xFF42E695), Color(0xFF3BB2B8)]),
                        borderRadius: BorderRadius.all(Radius.circular(360)),
                      ),
                      child: Center(
                        child: Text(
                          'Air quality - Numbers here!',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
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
