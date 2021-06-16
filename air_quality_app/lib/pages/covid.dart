import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:air_quality/algorithms/apis.dart';
import 'package:air_quality/algorithms/getvalues.dart';
import 'package:air_quality/algorithms/storage.dart';
import 'package:air_quality/charts/line.dart' show line;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:intl/intl.dart';
import 'package:skeleton_text/skeleton_text.dart';

// ignore: must_be_immutable
class COVID extends StatefulWidget {
  var value;

  COVID({Key key, this.value}) : super(key: key);

  @override
  _CO2State createState() => _CO2State();
}

class _CO2State extends State<COVID> with SingleTickerProviderStateMixin {
  //Graph
  var _xAxis;
  List<String> _dates = [];
  var _deaths;
  var _confirmed;
  var _recovered;
  bool loading = true;
  var today = DateTime.now();
  bool warning = false;
  bool webViewLoading = true;
  DateFormat dateFormat = DateFormat("dd-MM-yy");

  change() {
    setState(() {
      warning = true;
    });
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
    if (mounted) setState(() {
      loading = false;
    });
  }

  double opacity;
  var covidInfo;
  String bg;
  String city = "Đang định vị";

  @override
  void initState() {
    init();
    futureExec();

    super.initState();
  }

  init() async {
    city = (await Store.readFile())[0];
    Map listImages = await getImages();
    int rand = Random().nextInt(listImages['bg'].length);
    bg = '${await listImages['bg'][rand]}';
    //Prevent null returns, the database is not stable and not made for continuous loop
    // hence sleep function
    covidInfo = await compute(loopCovidInfo, covidInfo);
    if (mounted)
      setState(() {
        covidInfo = covidInfo;
      });
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
              city: city,
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(
                  height: 100,
                ),
                Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: city != "Đang định vị"
                        ? Text(
                            !warning
                                ? "Có vẻ như thành phố của bạn không nằm trong danh sách của Bộ Y Tế "
                                    "nhưng bạn vẫn cần phải cẩn thận và nâng cao cảnh giác nhé!"
                                : "Thành phố của bạn nằm trong danh sách của Bộ Y Tế, không "
                                    "ra khỏi nhà trừ khi thực sự cần thiết. Việt Nam quyết thằng COVID!!!",
                            style: TextStyle(color: theme.defaultTextColor),
                          )
                        : Container()),
                Column(
                  children: [
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
                    Container(
                        height: 55,
                        width: 300,
                        decoration: BoxDecoration(
                          color: theme.variantColor,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 2,
                                  child: Text(
                                    'Tỉnh/Thành Phố',
                                    style: TextStyle(
                                        color: theme.defaultTextColor),
                                  )),
                              Expanded(
                                  flex: 1,
                                  child: Text(
                                    'Số ca mắc',
                                    style: TextStyle(
                                        color: theme.defaultTextColor),
                                  )),
                              Expanded(
                                  flex: 1,
                                  child: Text(
                                    'Tử vong',
                                    style: TextStyle(
                                        color: theme.defaultTextColor),
                                  )),
                              Expanded(
                                  flex: 1,
                                  child: Text(
                                    'Đã khỏi',
                                    style: TextStyle(
                                        color: theme.defaultTextColor),
                                  ))
                            ],
                          ),
                        )),
                  ],
                )
              ],
            ),
          ),
          if (covidInfo != null)
            content(theme, covidInfo, city, change)
          else
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          height: 150,
                          width: 300,
                          child: SkeletonAnimation(
                            borderRadius: BorderRadius.circular(25),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            height: 40,
                            width: 70,
                            child: SkeletonAnimation(
                              borderRadius: BorderRadius.circular(25),
                              shimmerDuration: 800,
                              child: Container(),
                            ),
                          ),
                        ),
                      ],
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
  final String city;

  CustomHeaderDelegate(
      {@required this.expandedHeight,
      @required this.bg,
      @required this.theme,
      @required this.city});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final top = subtract(expandedHeight / 2, shrinkOffset - 70, 35);
    return Stack(
      fit: StackFit.expand,
      clipBehavior: Clip.none,
      children: [
        buildBackground(shrinkOffset, bg, theme),
        buildAppBar(context, shrinkOffset),
        Positioned(
          top: top,
          right: subtract(
              (MediaQuery.of(context).size.width - 250) / 2, shrinkOffset, 15),
          child: bar(shrinkOffset, city, top),
        ),
      ],
    );
  }

  Widget bar(double shrinkOffset, String city, double top) => Container(
        child: Container(
          height: subtract(150, shrinkOffset * 1.25, 80),
          width: subtract(250, shrinkOffset, 140),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '$city',
                    style: TextStyle(
                        fontSize: subtract(27, shrinkOffset / 7, 15),
                        color: theme.defaultTextColor),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Cập nhật: ${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}',
                    style: TextStyle(
                        fontSize: subtract(18, shrinkOffset / 7, 10),
                        color: theme.defaultTextColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

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

Widget content(NeumorphicThemeData theme, List listContent, String city,
        Function callback) =>
    SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          int i = 0;
          Map<dynamic, dynamic> fullMapContent = {};
          listContent.reversed.forEach((child) {
            Map<String, dynamic> mapContent = {};
            String elementString = child.toString().replaceAll('[]{}', '');
            List element = elementString.split(', ');
            element.forEach((valueUnformatted) {
              String value = valueUnformatted.replaceAll('{', '');
              value = value.replaceAll('}', '');
              mapContent['${value.substring(0, value.indexOf(":"))}'] = value
                  .substring(value.indexOf(": "), value.length)
                  .replaceAll(':', '');
            });
            if (mapContent["province_name"] == city) {
              print(
                  "${mapContent["province_name"]} ...........................");
              print(city);
              callback();
            }
            fullMapContent[i] = mapContent;
            i++;
          });
          return Center(
            child: Container(
              height: 55,
              width: 300,
              decoration: BoxDecoration(
                color: theme.variantColor,
              ),
              child: fullMapContent[index]['province_name'] !=
                      'Đang cập nhật vui lòng thử lại sau'
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 2,
                              child: Text(
                                fullMapContent[index]['province_name'] ?? '',
                                style: TextStyle(color: theme.defaultTextColor),
                              )),
                          Expanded(
                              flex: 1,
                              child: Text(
                                fullMapContent[index]['confirmed'] ?? '',
                                style: TextStyle(color: theme.defaultTextColor),
                              )),
                          Expanded(
                              flex: 1,
                              child: Text(
                                fullMapContent[index]['deaths'] ?? '',
                                style: TextStyle(color: theme.defaultTextColor),
                              )),
                          Expanded(
                              flex: 1,
                              child: Text(
                                fullMapContent[index]['recovered'] ?? '',
                                style: TextStyle(color: theme.defaultTextColor),
                              ))
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        fullMapContent[index]['province_name'],
                        style: TextStyle(color: theme.defaultTextColor),
                      ),
                    ),
            ),
          );
        },
        childCount: listContent.length,
      ),
    );

loopCovidInfo(covidInfo) async {
  int i = 1;
  while (covidInfo == null && i < 16) {
    print("Retrying..............$i............");
    covidInfo = await ParseHTML.getInfoCOVID();
    sleep(Duration(seconds: 1));
    i++;
  }
  if (covidInfo == null) {
    print('Failed.........................');
    covidInfo = [
      {'province_name': 'Đang cập nhật vui lòng thử lại sau'}
    ];
  }
  return covidInfo;
}
