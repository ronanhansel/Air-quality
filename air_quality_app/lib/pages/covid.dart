import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:air_quality/algorithms/apis.dart';
import 'package:air_quality/algorithms/getvalues.dart';
import 'package:air_quality/charts/line.dart' show line;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:intl/intl.dart';
import 'package:skeleton_text/skeleton_text.dart';

// ignore: must_be_immutable
class COVID extends StatefulWidget {
  @override
  _CO2State createState() => _CO2State();
}

class _CO2State extends State<COVID> with SingleTickerProviderStateMixin {
  //Graph
  JsonCodec codec = JsonCodec();
  List _xAxis;
  List<String> _dates = [];
  List _deaths;
  List _confirmed;
  List _recovered;
  List _vaccine;
  bool loading = true;
  DateTime today = DateTime.now();
  List<String> dateVaccine = [];
  List totalVaccine = [];
  List fullyVaccine = [0];
  DateFormat dateFormat = DateFormat("yyyy-MM-dd");

  futureExec() async {
    //Process CSV data
    //Get CSV data

    _deaths = await CovidData.getRawDeathsData();
    _confirmed = await CovidData.getRawConfirmedData();
    _recovered = await CovidData.getRawRecoveredData();
    //Delete unrelated data

    _deaths.removeRange(0, 3);
    _confirmed.removeRange(0, 3);
    _recovered.removeRange(0, 3);

    //Generate evenly distributed list of integer for Date Index
    _xAxis = List.generate(_deaths.length, (i) => (i + 1));

    //Subtract current date with the index at a given point to get that index's specific date
    _xAxis.forEach((value) {
      var getDate = today.subtract(Duration(days: value));
      var todayString = dateFormat.format(getDate);
      _dates.add("'$todayString'");
    });

    //Reverse data to get a chronological list
    _dates = _dates.reversed.toList();
    //Process JSON data
    _vaccine = await CovidData.getJSONVaccinationData();
    int count = 0;
    //Generate Split data into Lists to work with graphs
    _vaccine.forEach((val) {
      String sVal = val.toString();
      sVal = sVal.replaceAll("{", "{\"").replaceAll(", ", "\", \"").replaceAll(": ", "\": \"").replaceAll("}", "\"}");
      Map<String, dynamic> dataInner = codec.decode("""$sVal""");
      dateVaccine.add("'${dataInner["date"]}'");
      //Check if the data is present
      totalVaccine.add(dataInner["total_vaccinations"] ?? totalVaccine[count - 1]);
      fullyVaccine.add(dataInner["people_fully_vaccinated"] ?? fullyVaccine[count]);
      count++;
    });
    fullyVaccine.remove(0);
    print(dateVaccine.length);
    print(totalVaccine.length);
    print(fullyVaccine.length);
    if (mounted)
      setState(() {
        loading = false;
      });
  }

  double opacity;
  String bg;

  @override
  void initState() {
    init();
    futureExec();

    super.initState();
  }

  init() async {
    Map listImages = await getImages();
    int rand = Random().nextInt(listImages['bg'].length);
    bg = '${await listImages['bg'][rand]}';
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = NeumorphicTheme.currentTheme(context);
    return Scaffold(
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: CustomHeaderDelegate(
              expandedHeight: 300,
              theme: theme,
              bg: bg,
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: !loading
                        ? Echarts(
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
                          )
                        : Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: SkeletonAnimation(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              child: Container(),
                            ),
                          ),
                    width: 500,
                    height: 300,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: !loading
                        ? Echarts(
                      extensions: [line],
                      theme: 'line',
                      option:
                      '''
                                      {
                                          tooltip: {
                                              trigger: 'axis',
                                              axisPointer: {
                                                  type: 'cross',
                                                  label: {
                                                      backgroundColor: '#6a7985'
                                                  }
                                              }
                                          },
                                          legend: {
                                              data: ['Tiêm 1 mũi', 'Tiêm 2 mũi']
                                          },
                                      
                                          grid: {
                                              left: '3%',
                                              right: '4%',
                                              bottom: '3%',
                                              containLabel: true
                                          },
                                          xAxis: [
                                              {
                                                  type: 'category',
                                                  boundaryGap: false,
                                                  data: $dateVaccine
                                              }
                                          ],
                                          yAxis: [
                                              {
                                                  type: 'value'
                                              }
                                          ],
                                          series: [
                                              {
                                                  name: 'Đã tiêm',
                                                  type: 'line',
                                                  areaStyle: {},
                                                  emphasis: {
                                                      focus: 'series'
                                                  },
                                                  data: $totalVaccine
                                              },
                                      
                                              {
                                                  name: 'Tiêm 2 mũi',
                                                  type: 'line',
                                                  label: {
                                                      show: true,
                                                      position: 'top'
                                                  },
                                                  areaStyle: {},
                                                  emphasis: {
                                                      focus: 'series'
                                                  },
                                                  data: $totalVaccine
                                              }
                                          ]
                                      }
                   ''',
                    )
                        : Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: SkeletonAnimation(
                        borderRadius:
                        BorderRadius.all(Radius.circular(10)),
                        child: Container(),
                      ),
                    ),
                    width: 500,
                    height: 300,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final String bg;
  final NeumorphicThemeData theme;

  CustomHeaderDelegate({
    @required this.expandedHeight,
    @required this.bg,
    @required this.theme,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      fit: StackFit.expand,
      clipBehavior: Clip.none,
      children: [
        buildBackground(shrinkOffset, bg, theme),
        buildAppBar(context, shrinkOffset),
      ],
    );
  }

  double appear(shrinkOffset) => shrinkOffset / expandedHeight;

  double disappear(shrinkOffset) => 1 - shrinkOffset / expandedHeight;

  Widget buildAppBar(BuildContext context, double shrinkOffset) {
    return Opacity(
      opacity: appear(shrinkOffset),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            height: kToolbarHeight,
            child: AppBar(
              backgroundColor: Colors.blue.withOpacity(0.2),
              title: Text("Covid-19"),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBackground(
      double shrinkOffset, String bg, NeumorphicThemeData theme) {
    return Opacity(
        opacity: disappear(shrinkOffset), child: artBoard(bg, theme));
  }

  Widget artBoard(String bg, NeumorphicThemeData theme) {
    return bg == null
        ? const SizedBox(
            height: 300,
            width: 300,
          )
        : DecoratedBox(
            position: DecorationPosition.foreground,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.center,
                colors: [Colors.blue, Colors.transparent],
              ),
            ),
            child: bg.isNotEmpty
                ? Image.network(
                    bg,
                    fit: BoxFit.cover,
                  )
                : Container());
  }

  double subtract(double i, double shrinkOffset, double lim) {
    double a = i - shrinkOffset;
    if (a < lim) {
      a = lim;
    }
    return a;
  }

  double add(double i, double shrinkOffset, double lim) {
    double a = i + shrinkOffset;
    if (a > lim) {
      a = lim;
    }
    return a;
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
