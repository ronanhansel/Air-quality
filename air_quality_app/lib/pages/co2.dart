import 'package:air_quality/algorithms/co2_quality.dart';
import 'package:air_quality/algorithms/getvalues.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:neumorphic/neumorphic.dart';

// ignore: must_be_immutable
class CO2 extends StatefulWidget {
  var value;

  CO2({Key key, this.value}) : super(key: key);

  @override
  _CO2State createState() => _CO2State();
}

class _CO2State extends State<CO2> with SingleTickerProviderStateMixin {
  var co2;
  int value = 0;
  Animation animation;
  AnimationController controller;
  Color normal = Colors.greenAccent;

  getDataRepeat135() async {
    var number;
    database.onValue.listen((event) {
      var snapshot = event.snapshot;
      number = snapshot.value["135"];
      if (this.mounted) {
        mountFunc(number);
      }
    });
    return number;
  }

  mountFunc(var number) async {
    setState(() {
      value = number;
      if (800 < value) {
        normal = Colors.redAccent;
      } else {
        normal = Colors.greenAccent;
      }
      animation = IntTween(begin: co2, end: value)
          .animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));
      controller.reset();
      controller.forward();
    });

    setState(() {
      co2 = number;
    });
  }

  @override
  void initState() {
    init();
    super.initState();
  }
init() async {
  co2 = widget.value;
  controller =
      AnimationController(duration: Duration(milliseconds: 700), vsync: this);
  animation = IntTween(begin: 0, end: co2)
      .animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));
  controller.reset();
  await controller.forward();
  getDataRepeat135();
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          Container(
            height: MediaQuery
                .of(context)
                .size
                .height,
            width: MediaQuery
                .of(context)
                .size
                .width,
            child: Center(
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Column(
                    children: [
                      Center(
                        child: Text(
                          '${getco2quad(co2 ?? 0)}',
                          style: TextStyle(fontSize: 30),
                        ),
                      ),
                      Container(
                        width: 150,
                        height: 5,
                        decoration: BoxDecoration(
                            color: normal,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(360),
                                bottomLeft: Radius.circular(360),
                                topRight: Radius.circular(360),
                                bottomRight: Radius.circular(360))),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Column(
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: AnimatedBuilder(
                                    animation: controller,
                                    builder: (BuildContext context,
                                        Widget child) {
                                      return Text(
                                        '${animation.value}',
                                        style: TextStyle(fontSize: 40),
                                      );
                                    },

                                  ),
                                ),
                              ),
                              Hero(
                                tag: 'ppm1',
                                child: Material(
                                  color: Colors.transparent,
                                  child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: Text(
                                      'ppm',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 150,
                            height: 20,
                            decoration: BoxDecoration(
                                color: normal,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(360),
                                    bottomRight: Radius.circular(360))),
                          )
                        ],
                      ),
                      Expanded(child: SizedBox()),
                      Padding(
                        padding: const EdgeInsets.only(right: 25.0),
                        child: Material(
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Container(
                              width: 40,
                              height: 300,
                              child: FAProgressBar(
                                direction: Axis.vertical,
                                verticalDirection: VerticalDirection.up,
                                maxValue: 1500,
                                backgroundColor: Colors.grey[200],
                                currentValue: co2,
                                changeColorValue: 800,
                                animatedDuration: Duration(milliseconds: 700),
                                progressColor: normal,
                                changeProgressColor: Colors.redAccent,
                                displayText: '',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Hero(
                          tag: 'co2text',
                          child: Material(
                            color: Colors.transparent,
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Text(
                                'CO2 level',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
