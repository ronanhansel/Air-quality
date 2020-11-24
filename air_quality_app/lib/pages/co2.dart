import 'package:air_quality/algorithms/co2_quality.dart';
import 'package:air_quality/algorithms/getvalues.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
    getDataRepeat135();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
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
              tag: 'co2',
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
                            'CO2 level',
                            style: TextStyle(fontSize: 20),
                          ),
                          Center(
                            child: co2 == null
                                ? Text(
                                    '${widget.value}',
                                    style: TextStyle(fontSize: 40),
                                  )
                                : Text(
                                    '$co2',
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
              '${getco2quad(co2 ?? 0)}',
              style: TextStyle(fontSize: 30),
            ),
          ),
        ],
      ),

    );
  }
}
