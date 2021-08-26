import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:air_quality/algorithms/apis.dart';
import 'package:air_quality/charts/line.dart' show line;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:intl/intl.dart';
import 'package:skeleton_text/skeleton_text.dart';

class COVID extends StatefulWidget {
  @override
  _CO2State createState() => _CO2State();
}

class _CO2State extends State<COVID> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
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
  List<int> totalVaccine = [];
  List<int> fullyVaccine = [0];
  Map<String, dynamic> dataInner = {};
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
      sVal = sVal
          .replaceAll("{", "{\"")
          .replaceAll(", ", "\", \"")
          .replaceAll(": ", "\": \"")
          .replaceAll("}", "\"}");
      dataInner = codec.decode("""$sVal""");
      dateVaccine.add("'${dataInner["date"]}'");
      //Check if the data is present
      totalVaccine.add(int.parse(dataInner["total_vaccinations"] ??
          totalVaccine[count - 1].toString()));
      fullyVaccine.add(int.parse(dataInner["people_fully_vaccinated"] ??
          fullyVaccine[count].toString()));
      count++;
    });
    fullyVaccine.remove(0);
    if (mounted)
      setState(() {
        loading = false;
      });
  }

  double opacity;
  Image bg;

  @override
  void initState() {
    init();
    futureExec();

    super.initState();
  }

  init() async {
    int rand = Random().nextInt(2);
    bg = Image.asset(
      'assets/$rand.jpg',
      fit: BoxFit.cover,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
                Container(
                  height: 265,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: !loading
                          ? NeumorphicButton(
                        onPressed: () {},
                            child: Container(
                                margin: EdgeInsets.all(5),
                                child: DefaultTextStyle(
                                  style: TextStyle(
                                      color: theme.defaultTextColor,
                                      fontSize: 11),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Viet Nam",
                                        style: TextStyle(fontSize: 35),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Tổng số ca"),
                                              Text(
                                                "${int.parse(_confirmed[_confirmed.length - 1])}",
                                                style: TextStyle(
                                                  fontSize: 25,
                                                ),
                                              ),
                                              Text(
                                                  "Số ca hôm qua: ${int.parse(_confirmed[_confirmed.length - 1]) - int.parse(_confirmed[_confirmed.length - 2])}"),
                                            ],
                                          ),
                                          Expanded(child: SizedBox()),
                                          Container(
                                            width: 2,
                                            height: 50,
                                            color: theme.defaultTextColor,
                                          ),
                                          Expanded(child: SizedBox()),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Tổng số tử vong"),
                                              Text(
                                                "${int.parse(_deaths[_deaths.length - 1])}",
                                                style: TextStyle(
                                                  fontSize: 25,
                                                ),
                                              ),
                                              Text(
                                                  "Số tử vong hôm qua: ${int.parse(_deaths[_deaths.length - 1]) - int.parse(_deaths[_deaths.length - 2])}"),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 7,
                                      ),
                                      Center(
                                        child: Container(
                                          width: 250,
                                          height: 2,
                                          color: theme.defaultTextColor,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 7,
                                      ),
                                      Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Tổng số liều đã tiêm"),
                                              Text(
                                                "${totalVaccine[totalVaccine.length - 1]}",
                                                style: TextStyle(
                                                  fontSize: 25,
                                                ),
                                              ),
                                              Text(
                                                  "Số liều hôm qua: ${totalVaccine[totalVaccine.length - 1] - totalVaccine[totalVaccine.length - 2]}"),
                                            ],
                                          ),
                                          Expanded(child: SizedBox()),
                                          Container(
                                            width: 2,
                                            height: 50,
                                            color: theme.defaultTextColor,
                                          ),
                                          Expanded(child: SizedBox()),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Số người đã tiêm đủ liều"),
                                              Text(
                                                "${fullyVaccine[fullyVaccine.length - 1]}",
                                                style: TextStyle(
                                                  fontSize: 25,
                                                ),
                                              ),
                                              Text(
                                                  "Phần trăm: ${dataInner["people_vaccinated_per_hundred"] ?? 0}"),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
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
                ),
                Padding(
                  padding: const EdgeInsets.all(23.0),
                  child: Text(
                    "Biểu đồ thống kê",
                    style: TextStyle(
                        color: theme.defaultTextColor, fontSize: 35),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: !loading
                        ? ClipRRect(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)),
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
                        ? ClipRRect(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)),
                            child: Echarts(
                              extensions: [line],
                              theme: 'line',
                              option: '''
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
                                                data: ['Đã tiêm', 'Đủ liều']
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
                                                    markPoint: {
                                                        data: [
                                                            {type: 'max', name: 'latest'},
                                                        ]
                                                    },
                                                    areaStyle: {},
                                                    emphasis: {
                                                        focus: 'series'
                                                    },
                                                    data: $totalVaccine
                                                },
                                        
                                                {
                                                    name: 'Đủ liều',
                                                    type: 'line',
                                                    markPoint: {
                                                        data: [
                                                            {type: 'max', name: 'latest'},
                                                        ]
                                                    },
                                                    label: {
                                                        show: true,
                                                        position: 'top'
                                                    },
                                                    areaStyle: {},
                                                    emphasis: {
                                                        focus: 'series'
                                                    },
                                                    data: $fullyVaccine
                                                }
                                            ]
                                        }
                   ''',
                            ),
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

  @override
  bool get wantKeepAlive => true;
}

class CustomHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final Image bg;
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
        buildBackground(context, shrinkOffset, bg, theme),
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

  Widget buildBackground(BuildContext context,
      double shrinkOffset, Image bg, NeumorphicThemeData theme) {
    return Opacity(
        opacity: disappear(shrinkOffset), child: artBoard(bg, theme));
  }

  Widget artBoard(Image bg, NeumorphicThemeData theme) {
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
            child: bg);
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
