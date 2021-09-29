import 'dart:async';
import 'package:air_quality/algorithms/apis.dart';
import 'package:air_quality/algorithms/getvalues.dart';
import 'package:air_quality/algorithms/quality.dart';
import 'package:air_quality/algorithms/storage.dart';
import 'package:air_quality/pages/co.dart';
import 'package:air_quality/pages/natural.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart' hide AnimatedScale;
import 'package:rive/rive.dart' hide LinearGradient;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:air_quality/pages/co2.dart';

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
  AnimationController _scaleaniController;
  AnimationController _fadeaniController;
  Animation anifade;
  Animation aniscale;
  bool touch = true;
  var status = "...";
  var index = 0.0;
  var onethreefive = 0;
  var five = 0;
  var seven = 0.0;
  int humid = 0;
  double temp = 0.0;
  AnimationStatus animsta;
  var forecast;
  String api = 'ff677b8db486de02b5effc8891a86899';

  @override
  void initState() {
    super.initState();
    _scaleaniController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    aniscale = Tween<double>(
      begin: 0.85,
      end: 1,
    ).animate(_scaleaniController);
    _fadeaniController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    anifade = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_fadeaniController);
    _bgController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    bgfade = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_bgController);
    _scaleController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    scale = Tween<double>(
      begin: 0.85,
      end: 1,
    ).animate(_scaleController)
      ..addStatusListener((AnimationStatus ani) {
        animsta = ani;
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

  bool updated = false;
  int i = 0;

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
          i++;
          if (i > 3) {
            updated = true;
          }
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
      _scaleaniController.reverse();
      await _fadeaniController.reverse();
      status = await quality135();
      setState(() {
        load();
        display();
      });
    }
  }

  show() async {
    _bgController.forward();
    await _scaleController.forward();
    display();
  }

  void display() {
    _fadeaniController.forward();
    _scaleaniController.forward();
    _controller.isActive = !_controller.isActive;
  }

  void load() {
    rootBundle.load('assets/environment.riv').then(
      (data) async {
        var file = RiveFile.import(data);
        if (file != null) {
          var artboard = file.mainArtboard;
          artboard.addController(
            _controller = SimpleAnimation('$status'),
          );
          _controller.isActive = false;
          setState(() => _riveArtboard = artboard);
        }
      },
    );
  }

  void getAirVisual() async {
    List listLocation = await Store.readFile();
    String city = listLocation[0];
    double lat = double.parse(listLocation[1]);
    double lon = double.parse(listLocation[2]);

    print("$city");
    forecast = await APIs.airVisual(lat.toString(), lon.toString(), api);

    print(lat);
    print(lon);
    print(forecast[0]['components']);
    print(listLocation);
  }

  initial() async {
    status = await quality135();
    getDataRepeat7();
    getDataRepeat5();
    getDataRepeat135();
    getDataRepeatHumid();
    getDataRepeatTemp();
    getAirVisual();
    load();
  }

  @override
  Widget build(BuildContext context) {
    final theme = NeumorphicTheme.currentTheme(context);

    return Scaffold(
      body: Center(
        child: FutureBuilder(
          builder: (BuildContext context, AsyncSnapshot<Widget> widget) {
            if (updated == false) {
              return SkeletonLoading(context, theme);
            }
            show();
            return FadeTransition(
              opacity: bgfade,
              child: CustomScrollView(
                physics: BouncingScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    stretch: true,
                    snap: true,
                    floating: true,
                    pinned: true,
                    expandedHeight: 300,
                    flexibleSpace: FlexibleSpaceBar(
                      stretchModes: [StretchMode.zoomBackground],
                      title: Row(
                        children: [
                          Text("Air Quality"),
                          Expanded(child: SizedBox()),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text("${index.toInt()}"),
                          )
                        ],
                      ),
                      background: _riveArtboard == null
                          ? const SizedBox(
                              height: 300,
                              width: 300,
                            )
                          : ScaleTransition(
                              scale: aniscale,
                              child: FadeTransition(
                                opacity: anifade,
                                child: DecoratedBox(
                                  position: DecorationPosition.foreground,
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.center,
                                          colors: [
                                        theme.accentColor.withOpacity(0.5),
                                        Colors.transparent
                                      ])),
                                  child: Container(
                                    child: Rive(
                                      fit: BoxFit.cover,
                                      artboard: _riveArtboard,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            'Mức độ chất lượng không khí: $status',
                            style: TextStyle(
                                color: theme.defaultTextColor, fontSize: 20),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                height: 100,
                                width: 100,
                                child: NeumorphicButton(
                                  onPressed: () {
                                    Timer(
                                        Duration(milliseconds: 300),
                                        () => Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                              builder: (context) =>
                                                  CO2(value: onethreefive),
                                            )));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Stack(
                                      children: [
                                        Text(
                                          'CO2 level',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: theme.defaultTextColor,
                                          ),
                                        ),
                                        Center(
                                          child: Text(
                                            '$onethreefive',
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: theme.defaultTextColor,
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: Text(
                                            'ppm',
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: theme.defaultTextColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(child: SizedBox()),
                              Container(
                                height: 100,
                                width: 100,
                                child: NeumorphicButton(
                                  onPressed: () {
                                    Timer(
                                        Duration(milliseconds: 300),
                                        () => Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                              builder: (context) =>
                                                  CO(value: seven),
                                            )));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Stack(
                                      children: [
                                        Text(
                                          'CO level',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: theme.defaultTextColor,
                                          ),
                                        ),
                                        Center(
                                          child: Text(
                                            '$seven',
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: theme.defaultTextColor,
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: Text(
                                            'ppm',
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: theme.defaultTextColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(child: SizedBox()),
                              Container(
                                height: 100,
                                width: 100,
                                child: NeumorphicButton(
                                  onPressed: () {
                                    Timer(
                                        Duration(milliseconds: 300),
                                        () => Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                              builder: (context) =>
                                                  Natural(value: five),
                                            )));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Stack(
                                      children: [
                                        Text(
                                          'Gas level',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: theme.defaultTextColor,
                                          ),
                                        ),
                                        Center(
                                          child: Text(
                                            '$five',
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: theme.defaultTextColor,
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: Text(
                                            'ppm',
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: theme.defaultTextColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: NeumorphicButton(
                                style: NeumorphicStyle(
                                  color: theme.variantColor,
                                ),
                                child: Container(
                                  width: 300,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: theme.variantColor,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Text(
                                        'Độ ẩm: $humid%, Nhiệt độ: $temp C',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: theme.defaultTextColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 300,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

Widget SkeletonLoading(BuildContext context, NeumorphicThemeData theme) {
  return Center(
    child: Container(
      height: 100,
      child: Column(
        children: [
          SpinKitCircle(
            color: theme.accentColor,
          ),
          Text(
            'Đang đo lường, vui lòng mở Airify',
            style: TextStyle(
              color: theme.defaultTextColor
            ),
          )
        ],
      ),
    ),
  );
}
