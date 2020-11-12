import 'package:air_quality/algorithms/getvalues.dart';
import 'package:air_quality/algorithms/quality.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart' hide LinearGradient;
import 'package:firebase_database/firebase_database.dart';

class AirQuality extends StatefulWidget {
  @override
  _AirQualityState createState() => _AirQualityState();
}

class _AirQualityState extends State<AirQuality> with TickerProviderStateMixin {
  Artboard _riveArtboard;
  RiveAnimationController _controller;
  Animation bgfade;
  AnimationController _bgController;
  Animation scale;
  AnimationController _scaleController;
  var status;
  var number;

  @override
  void initState() {
    getStatus();
    _bgController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 600));
    bgfade = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_bgController);
    _scaleController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 600));
    scale = Tween<double>(
      begin: 0.85,
      end: 1,
    ).animate(_scaleController);
    super.initState();
  }

  getStatus() async {
    status = await quality135();
    number = await getData(135);
    print(status);
    rootBundle.load('assets/environment.riv').then(
      (data) async {
        var file = RiveFile();
        var success = file.import(data);
        if (success) {
          var artboard = file.mainArtboard;
          artboard.addController(
            _controller = SimpleAnimation('$status'),
          );
          setState(() => _riveArtboard = artboard);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _scaleController.forward();
    _bgController.forward();
    return Wrap(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: Material(
            child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color(0xFF42E695), Color(0xFF3BB2B8)]),
                  borderRadius: BorderRadius.all(Radius.circular(0)),
                ),
                child: Center(
                    child: FutureBuilder(
                      builder: (BuildContext context, AsyncSnapshot<Widget> widget) {
                        if (status == null) {
                          return CircularProgressIndicator();
                        }
                        _bgController.forward();
                        _scaleController.forward();
                        return ScaleTransition(
                          scale: scale,
                          child: FadeTransition(
                            opacity: bgfade,
                            child: CustomScrollView(
                              physics: BouncingScrollPhysics(),
                              slivers: [
                                SliverAppBar(
                                  pinned: true,
                                  expandedHeight: 200,
                                  stretch: true,
                                  shape: ContinuousRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(40),
                                          bottomLeft: Radius.circular(40))),
                                  flexibleSpace:
                                  FlexibleSpaceBar(stretchModes: [
                                    StretchMode.fadeTitle,
                                  ], title: Text('Air quality $number')),
                                ),
                                SliverList(
                                    delegate: SliverChildListDelegate([
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text('The air quality is $status', style: TextStyle(fontSize: 20),),
                                      ),
                                      Container(
                                        height: 300,
                                        child: Center(
                                          child: Container(
                                            width:
                                            MediaQuery.of(context).size.width,
                                            height: MediaQuery.of(context)
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
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text('CO level: ', style: TextStyle(fontSize: 20),),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text('Natural gas level: ', style: TextStyle(fontSize: 20),),
                                      ),
                                    ]))
                              ],
                            ),
                          ),
                        );
                      },
                    ), )),
          ),
        ),
      ],
    );
  }
}
