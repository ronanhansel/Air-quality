import 'package:air_quality/algorithms/co2_quality.dart';
import 'package:air_quality/algorithms/gas_quality.dart';
import 'package:air_quality/algorithms/getvalues.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// ignore: must_be_immutable
class Natural extends StatefulWidget {
  var value;

  Natural({Key key, this.value}) : super(key: key);

  @override
  _NaturalState createState() => _NaturalState();
}

class _NaturalState extends State<Natural> with SingleTickerProviderStateMixin {
  var gas;
  int value = 0;
  Animation animation;
  AnimationController controller;
  Color normal = Colors.greenAccent;

  getDataRepeat5() async {
    var number;
    database.onValue.listen((event) {
      var snapshot = event.snapshot;
      number = snapshot.value["5"];
      if (this.mounted) {
        mountFunc(number);
      }
    });
    return number;
  }

  mountFunc(var number) async {
    setState(() {
      value = number;
      if (500 < value) {
        normal = Colors.redAccent;
      } else {
        normal = Colors.greenAccent;
      }
      animation = IntTween(begin: gas, end: value)
          .animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));
      controller.reset();
      controller.forward();
    });

    setState(() {
      gas = number;
    });
  }

  @override
  void initState() {
    init();
    super.initState();
  }
init() async{
  gas = widget.value;
  value = gas;
  controller =
      AnimationController(duration: Duration(milliseconds: 700), vsync: this);
  animation = IntTween(begin: 0, end: gas)
      .animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));
  await controller.forward();
  getDataRepeat5();
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
                          '${getgasquad(gas ?? 0)}',
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
                                tag: 'ppm3',
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
                                currentValue: gas,
                                changeColorValue: 501,
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
                          tag: 'gastext',
                          child: Material(
                            color: Colors.transparent,
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Text(
                                'Gas level',
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
