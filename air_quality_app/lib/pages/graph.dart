import 'package:air_quality/algorithms/apis.dart';
import 'package:flutter/material.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:air_quality/charts/line.dart' show line;
import 'package:intl/intl.dart';

class Graph extends StatefulWidget {
  @override
  _GraphState createState() => _GraphState();
}

class _GraphState extends State<Graph> {
  var _xAxis;
  List<String> _dates = [];
  var _deaths;
  var _confirmed;
  var _recovered;
  var today = DateTime.now();
  DateFormat dateFormat = DateFormat("dd-MM-yy");

  @override
  void initState() {
    futureExec();
    super.initState();
  }

  futureExec() async {
    _deaths = await CSSEGICovidData.getRawDeathsData();
    _deaths.removeRange(0, 3);
    _confirmed = await CSSEGICovidData.getRawConfirmedData();
    _confirmed.removeRange(0, 3);
    _recovered = await CSSEGICovidData.getRawRecoveredData();
    _recovered.removeRange(0, 3);
    _xAxis = List.generate(_deaths.length, (i) => (i + 1));
    _xAxis.forEach((value) {
      var getDate = today.subtract(Duration(days: value));
      var todayString = dateFormat.format(getDate);
      _dates.add("'$todayString'");
    });
    _dates = _dates.reversed.toList();
    print(_dates.runtimeType);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Echarts(
        extensions: [line],
        theme: 'line',
        option: '''
          {
              tooltip: {
                  trigger: 'axis'
              },
              grid: {
                  left: '3%',
                  right: '4%',
                  bottom: '3%',
                  containLabel: true
              },
              legend: {
                data: ['Nhiễm bệnh',  'Đã khỏi', 'Tử vong']
              },
              xAxis: {
                type: 'category',
                data: $_dates
              },
              yAxis: {
                type: 'value'
              },
              series: [{
                  name: 'Nhiễm bệnh',
                data: $_confirmed,
                type: 'line',
                markPoint: {
                data: [
                    {type: 'max', name: 'latest'},
                ]
            },
              },
              {
                  name: 'Đã khỏi',
                data: $_recovered,
                type: 'line',
                markPoint: {
                data: [
                    {type: 'max', name: 'latest'},
                ]
            },
              },
              {
                  name: 'Tử vong',
                data: $_deaths,
                type: 'line',
                markPoint: {
                data: [
                    {type: 'max', name: 'latest'},
                ]
            },
              },
              ]
    }
          ''',
      ),
      width: 500,
      height: 300,
    );
  }
}
