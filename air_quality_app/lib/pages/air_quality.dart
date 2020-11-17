import 'package:air_quality/algorithms/getvalues.dart';
import 'package:air_quality/algorithms/quality.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:neumorphic/neumorphic.dart';
import 'package:rive/rive.dart' hide LinearGradient;

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
    onethreefive = await getData(135);
    seven = await getData(7);
    five = await getData(5);
    number = onethreefive + seven + five;
    status = await quality135();
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
                  color: Color(0xffe0e5ec),
                  borderRadius: BorderRadius.all(Radius.circular(0)),
                ),
                child: Center(
                  child: FutureBuilder(
                    builder:
                        (BuildContext context, AsyncSnapshot<Widget> widget) {
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
                                  child: Text('Air quality $number',
                                      style: TextStyle(
                                          color: Colors.grey[800],
                                          fontSize: 40)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    'The air quality is $status',
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
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Container(
                                          height: 200,
                                          child: NeuButton(
                                            decoration: NeumorphicDecoration(
                                                color: Colors.grey[300],
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20))),
                                            onPressed: () {},
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Stack(
                                                children: [
                                                  Text(
                                                    'CO level',
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                  ),
                                                  Center(
                                                    child: Text(
                                                      '$seven',
                                                      style: TextStyle(
                                                          fontSize: 40),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(child: SizedBox()),
                                      Expanded(
                                        flex: 3,
                                        child: Container(
                                          height: 200,
                                          child: NeuButton(
                                            decoration: NeumorphicDecoration(
                                                color: Colors.grey[300],
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20))),
                                            onPressed: () {},
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Stack(
                                                children: [
                                                  Text(
                                                    'Natural Gas level',
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                  ),
                                                  Center(
                                                    child: Text(
                                                      '$five',
                                                      style: TextStyle(
                                                          fontSize: 40),
                                                    ),
                                                  ),
                                                ],
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
