import 'package:air_quality/algorithms/getvalues.dart';
import 'package:air_quality/algorithms/quality.dart';
import 'package:air_quality/pages/co.dart';
import 'package:air_quality/pages/natural.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:neumorphic/neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart' hide LinearGradient;
import 'package:vibration/vibration.dart';

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
  final FirebaseMessaging _fcm = FirebaseMessaging();
  bool touch = true;
  var status = "...";
  var index = 0.0;
  var onethreefive = 0;
  var five = 0;
  var seven = 0.0;
  int humid = 0;
  double temp = 0.0;

  @override
  void initState() {
    super.initState();
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
    //firebase messaging
    _fcm.configure(onMessage: (Map<String, dynamic> message) async {
      if (touch) {
        touch = false;
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
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
    initial();
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
          seven = number.toDouble();
          index = (five + seven + onethreefive) / 3;
          changestatus();
        });
      }
    });
    return number;
  }

  getDataRepeat5() {
    var number;
    database.onValue.listen((event) {
      var snapshot = event.snapshot;
      number = snapshot.value["5"];
      if (mounted) {
        setState(() {
          five = number.toInt();
          index = (five + seven + onethreefive) / 3;
          changestatus();
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
          onethreefive = number.toInt();
          index = (five + seven + onethreefive) / 3;
          changestatus();
        });
      }
    });
    return number;
  }

  getDataRepeatHumid() async {
    var number;
    database.onValue.listen((event) {
      var snapshot = event.snapshot;
      number = snapshot.value["humid"];
      if (mounted) {
        setState(() {
          humid = number.toInt();
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
          temp = number.toDouble();
        });
      }
    });
    return number;
  }

  void changestatus() async {
    if (status != await quality135()) {
      status = await quality135();
      setState(() {

        play();
      });
    }
  }

  show () {
    _bgController.forward();
    _scaleController.forward();
  }
  void play () {
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
  initial() async {
    status = await quality135();
    getDataRepeat7();
    getDataRepeat5();
    getDataRepeat135();
    getDataRepeatHumid();
    getDataRepeatTemp();
    play();
  }

  @override
  Widget build(BuildContext context) {

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
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        width: 170,
                        height: 170,
                        decoration: BoxDecoration(
                            color: Colors.greenAccent,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.zero,
                                topLeft: Radius.zero,
                                bottomRight: Radius.circular(360),
                                bottomLeft: Radius.zero)),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                            color: Colors.greenAccent,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.zero,
                                topRight: Radius.zero,
                                bottomRight: Radius.zero,
                                bottomLeft: Radius.circular(360))),
                      ),
                    ),
                    Center(
                      child: FutureBuilder(
                        builder: (BuildContext context,
                            AsyncSnapshot<Widget> widget) {
                          if (onethreefive == 0) {
                            return Container(
                                height: 40,
                                width: 40,
                                child: SpinKitSquareCircle(
                                  color: Colors.grey,
                                ));
                          }
                          show();

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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('Air quality',
                                              style: TextStyle(
                                                  color: Colors.grey[800],
                                                  fontSize: 40)),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                  ' ${index.toStringAsFixed(2)}',
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
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Hero(
                                            tag: 'co2',
                                            child: Material(
                                              color: Colors.transparent,
                                              child: Container(
                                                height: 100,
                                                width: 100,
                                                child: NeuButton(
                                                  decoration:
                                                      NeumorphicDecoration(
                                                          color:
                                                              Colors.grey[300],
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          20))),
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        CupertinoPageRoute(
                                                          builder: (context) => CO2(
                                                              value:
                                                                  onethreefive),
                                                        ));
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Stack(
                                                      children: [
                                                        Text(
                                                          'CO2 level',
                                                          style: TextStyle(
                                                              fontSize: 10),
                                                        ),
                                                        Center(
                                                          child: Text(
                                                            '$onethreefive',
                                                            style: TextStyle(
                                                                fontSize: 20),
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment: Alignment
                                                              .bottomRight,
                                                          child: Text(
                                                            'ppm',
                                                            style: TextStyle(
                                                                fontSize: 10),
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
                                            tag: 'co',
                                            child: Material(
                                              color: Colors.transparent,
                                              child: Container(
                                                height: 100,
                                                width: 100,
                                                child: NeuButton(
                                                  decoration:
                                                      NeumorphicDecoration(
                                                          color:
                                                              Colors.grey[300],
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
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
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Stack(
                                                      children: [
                                                        Text(
                                                          'CO level',
                                                          style: TextStyle(
                                                              fontSize: 10),
                                                        ),
                                                        Center(
                                                          child: Text(
                                                            '$seven',
                                                            style: TextStyle(
                                                                fontSize: 20),
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment: Alignment
                                                              .bottomRight,
                                                          child: Text(
                                                            'ppm',
                                                            style: TextStyle(
                                                                fontSize: 10),
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
                                                height: 100,
                                                width: 100,
                                                child: NeuButton(
                                                  decoration:
                                                      NeumorphicDecoration(
                                                          color:
                                                              Colors.grey[300],
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
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
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Stack(
                                                      children: [
                                                        Text(
                                                          'Natural Gas level',
                                                          style: TextStyle(
                                                              fontSize: 10),
                                                        ),
                                                        Center(
                                                          child: Text(
                                                            '$five',
                                                            style: TextStyle(
                                                                fontSize: 20),
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment: Alignment
                                                              .bottomRight,
                                                          child: Text(
                                                            'ppm',
                                                            style: TextStyle(
                                                                fontSize: 10),
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
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                      height: 300,
                                      child: Center(
                                        child: Center(
                                          child: Container(
                                            color: Colors.transparent,
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 20.0),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: _riveArtboard == null
                                                ? const SizedBox()
                                                : NeuCard(
                                                    color: Colors.grey[300],
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  20)),
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
                                  ]))
                                ],
                              ),
                            ),
                          );
                        },
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
                )),
          ),
        ),
      ],
    );
  }
}
