import 'package:air_quality/algorithms/co2_quality.dart';
import 'package:air_quality/algorithms/gas_quality.dart';
import 'package:air_quality/algorithms/getvalues.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:neumorphic/neumorphic.dart';

// ignore: must_be_immutable
class Natural extends StatefulWidget {
  var value;

  Natural({Key key, this.value}) : super(key: key);

  @override
  _NaturalState createState() => _NaturalState();
}

class _NaturalState extends State<Natural> {
  var gas;

  getDataRepeat5() async {
    var number;
    database.onValue.listen((event) {
      var snapshot = event.snapshot;
      number = snapshot.value["5"];
      if (this.mounted) {
        setState(() {
          gas = number;
        });
      }
    });
    return number;
  }

  @override
  void initState() {
    getDataRepeat5();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: 170,
              height: 120,
              decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(360),
                      topLeft: Radius.circular(360),
                      bottomRight: Radius.zero,
                      bottomLeft: Radius.zero)),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Hero(
              tag: 'decor1',
              child: Container(
                width: 150,
                height: 120,
                decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.zero,
                        topRight: Radius.zero,
                        bottomRight: Radius.circular(360),
                        bottomLeft: Radius.circular(360))),
              ),
            ),
          ),
          ListView(
            physics: BouncingScrollPhysics(),
            children: [
              Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 5,
              ),
              Center(
                child: Hero(
                  tag: 'natural',
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      height: 250,
                      width: 250,
                      child: NeuButton(
                        decoration: NeumorphicDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.all(Radius.circular(20))),
                        onPressed: () {},
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Stack(
                            children: [
                              Text(
                                'Natural Gas level',
                                style: TextStyle(fontSize: 20),
                              ),
                              Center(
                                child: gas == null
                                    ? Text(
                                  '${widget.value}',
                                  style: TextStyle(fontSize: 40),
                                )
                                    : Text(
                                  '$gas',
                                  style: TextStyle(fontSize: 40),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  'ppm',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ],
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
              Center(
                child: Text(
                  '${getgasquad(gas ?? 0)}',
                  style: TextStyle(fontSize: 30),
                ),
              ),
            ],
          ),
        ],
      ),

    );
  }
}
