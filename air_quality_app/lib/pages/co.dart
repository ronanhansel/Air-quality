import 'package:air_quality/algorithms/co_quality.dart';
import 'package:air_quality/algorithms/getvalues.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// ignore: must_be_immutable
class CO extends StatefulWidget {
  var value;

  CO({Key key, this.value}) : super(key: key);

  @override
  _COState createState() => _COState();
}

class _COState extends State<CO> {
  double co;
  Color normal = Colors.greenAccent;

  getDataRepeat7() async {
    var number;
    database.onValue.listen((event) {
      var snapshot = event.snapshot;
      number = snapshot.value["7"];
      if (this.mounted) {
        setState(() {
          co = number.toDouble();
          if (500 < co) {
            normal = Colors.redAccent;
          } else {
            normal = Colors.greenAccent;
          }
        });
      }
    });
    return number;
  }

  @override
  void initState() {
    co = widget.value;
    getDataRepeat7();
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
                          '${getcoquad(co ?? 0)}',
                          style: TextStyle(fontSize: 30),
                        ),
                      ),
                      Container(
                        width: 150,
                        height: 5,
                        decoration: BoxDecoration(
                            color: normal,
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
                                  tag: 'co',
                                  child: Material(
                                    color: Colors.transparent,
                                    child: FittedBox(
                                      fit: BoxFit.contain,
                                      child: Text(
                                        '$co',
                                        style: TextStyle(fontSize: 40),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Hero(
                                tag: 'ppm2',
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
                                currentValue: co.toInt(),
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
                          tag: 'cotext',
                          child: Material(
                            color: Colors.transparent,
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Text(
                                'CO level',
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
