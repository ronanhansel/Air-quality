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

class _CO2State extends State<CO2> {
  var co2;

  getDataRepeat135() async {
    var number;
    database.onValue.listen((event) {
      var snapshot = event.snapshot;
      number = snapshot.value["135"];
      if (this.mounted) {
        setState(() {
          co2 = number;
        });
      }
    });
    return number;
  }

  @override
  void initState() {
    co2 = widget.value;
    getDataRepeat135();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
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
                            color: Colors.greenAccent,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(360), bottomLeft: Radius.circular(360), topRight: Radius.circular(360), bottomRight: Radius.circular(360))
                        ),
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
                                child: Hero(
                                  tag: 'co2',
                                  child: Material(
                                    color: Colors.transparent,
                                    child: FittedBox(
                                      fit: BoxFit.contain,
                                      child: Text(
                                        '$co2',
                                        style: TextStyle(fontSize: 40),
                                      ),
                                    ),
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
                                color: Colors.greenAccent,
                                borderRadius: BorderRadius.only(topRight: Radius.circular(360), bottomRight: Radius.circular(360))
                            ),
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
                                changeColorValue: 500,
                                animatedDuration: Duration(milliseconds: 700),
                                progressColor: Colors.greenAccent,
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
