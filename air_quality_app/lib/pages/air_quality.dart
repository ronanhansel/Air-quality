import 'package:air_quality/algorithms/getvalues.dart';
import 'package:air_quality/algorithms/quality.dart';
import 'package:air_quality/pages/co.dart';
import 'package:air_quality/pages/natural.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:neumorphic/neumorphic.dart';
import 'package:rive/rive.dart' hide LinearGradient;

import 'co2.dart';

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
  var onethreefive;
  var five;
  var seven;

  @override
  void initState() {
    initial();
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

  void dispose() {
    _controller.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  getDataRepeat7() async {
    var number;
    database.onValue.listen((event) {
      var snapshot = event.snapshot;
      number = snapshot.value["7"];

      if (mounted) {
        setState(() {
          seven = number;
        });
      }
    });
    return number;
  }

  getDataRepeat5() async {
    var number;
    database.onValue.listen((event) {
      var snapshot = event.snapshot;
      number = snapshot.value["5"];
      if (mounted) {
        setState(() {
          five = number;
        });
      }
    });
    return number;
  }
  getDataRepeat135() async {
    var number;
    database.onValue.listen((event) {
      var snapshot = event.snapshot;
      number = snapshot.value["135"];
      if (mounted) {
        setState(() {
          onethreefive = number;
        });
      }
    });
    return number;
  }
  getDataRepeatnumber() async {
    var number;
    database.onValue.listen((event) {
      var snapshot = event.snapshot;
      number = snapshot.value["135"];
      if (mounted) {
        setState(() {
          onethreefive = number;
        });
      }
    });
    return number;
  }

  getSum() async {
    var no;

    number.listen((event) {
      no = number;
          if(mounted) {
            setState(() {
              number = no;
              print('changed');
            });
          }
    });
  }
  initial() async {
    getDataRepeat7();
    getDataRepeat5();
    getDataRepeat135();
    onethreefive = await getData(135);

    status = await quality135();
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
    number = five + seven + onethreefive;
    return Wrap(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: Material(
            child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color(0xffe0e5ec),
                  borderRadius: BorderRadius.all(Radius.circular(0)),
                ),
                child: Center(
                  child: FutureBuilder(
                    builder:
                        (BuildContext context, AsyncSnapshot<Widget> widget) {
                      if (status == null) {
                        return Container(
                            height: 40,
                            width: 40,
                            child: SpinKitSquareCircle(
                              color: Colors.grey,
                            ));
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
                              SliverList(
                                  delegate: SliverChildListDelegate([
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: IconButton(
                                    icon: Icon(Icons.arrow_back_ios),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Air quality',
                                          style: TextStyle(
                                              color: Colors.grey[800],
                                              fontSize: 40)),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text(' ${number.toStringAsFixed(2)}',
                                              style: TextStyle(
                                                  color: Colors.grey[800],
                                                  fontSize: 40)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    'Mức độ chất lượng không khí: $status',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                Container(
                                  height: 300,
                                  child: Center(
                                    child: Center(
                                      child: Container(
                                        color: Colors.transparent,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.width,
                                        child: _riveArtboard == null
                                            ? const SizedBox()
                                            : NeuCard(
                                                color: Colors.grey[300],
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(20)),
                                                  child: Rive(
                                                    fit: BoxFit.fitWidth,
                                                    artboard: _riveArtboard,
                                                  ),
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Hero(
                                      tag: 'co2',
                                      child: Material(
                                        color: Colors.transparent,
                                        child: Container(
                                          height: 200,
                                          width: 170,
                                          child: NeuButton(
                                            decoration:
                                            NeumorphicDecoration(
                                                color: Colors.grey[300],
                                                borderRadius:
                                                BorderRadius.all(
                                                    Radius.circular(
                                                        20))),
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  CupertinoPageRoute(
                                                    builder: (context) =>
                                                        CO2(value: onethreefive),
                                                  ));
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                  10.0),
                                              child: Stack(
                                                children: [
                                                  Text(
                                                    'CO2 level',
                                                    style: TextStyle(
                                                        fontSize: 20),
                                                  ),
                                                  Center(
                                                    child: Text(
                                                      '$onethreefive',
                                                      style: TextStyle(
                                                          fontSize: 40),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment: Alignment.bottomRight,
                                                    child: Text(
                                                      'ppm',
                                                      style: TextStyle(
                                                          fontSize: 20),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20,),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    children: [
                                      Hero(
                                        tag: 'co',
                                        child: Material(
                                          color: Colors.transparent,
                                          child: Container(
                                            height: 200,
                                            width: 160,
                                            child: NeuButton(
                                              decoration:
                                                  NeumorphicDecoration(
                                                      color: Colors.grey[300],
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  20))),
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    CupertinoPageRoute(
                                                      builder: (context) =>
                                                          CO(value: seven),
                                                    ));
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.all(
                                                    10.0),
                                                child: Stack(
                                                  children: [
                                                    Text(
                                                      'CO level',
                                                      style: TextStyle(
                                                          fontSize: 20),
                                                    ),
                                                    Center(
                                                      child: Text(
                                                        '$seven',
                                                        style: TextStyle(
                                                            fontSize: 40),
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment: Alignment.bottomRight,
                                                      child: Text(
                                                        'ppm',
                                                        style: TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(child: SizedBox()),
                                      Hero(
                                        tag: 'natural',
                                        child: Material(
                                          color: Colors.transparent,
                                          child: Container(
                                            height: 200,
                                            width: 160,
                                            child: NeuButton(
                                              decoration:
                                                  NeumorphicDecoration(
                                                      color: Colors.grey[300],
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  20))),
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    CupertinoPageRoute(
                                                      builder: (context) =>
                                                          Natural(
                                                              value: five),
                                                    ));
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.all(
                                                    10.0),
                                                child: Stack(
                                                  children: [
                                                    Text(
                                                      'Natural Gas level',
                                                      style: TextStyle(
                                                          fontSize: 20),
                                                    ),
                                                    Center(
                                                      child: Text(
                                                        '$five',
                                                        style: TextStyle(
                                                            fontSize: 40),
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment: Alignment.bottomRight,
                                                      child: Text(
                                                        'ppm',
                                                        style: TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ]))
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )),
          ),
        ),
      ],
    );
  }
}
