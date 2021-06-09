import 'dart:io';
import 'dart:ui';

import 'package:air_quality/algorithms/apis.dart';
import 'package:air_quality/algorithms/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:rive/rive.dart' hide LinearGradient;
import 'package:skeleton_text/skeleton_text.dart';

// ignore: must_be_immutable
class COVID extends StatefulWidget {
  var value;

  COVID({Key key, this.value}) : super(key: key);

  @override
  _CO2State createState() => _CO2State();
}

class _CO2State extends State<COVID> with SingleTickerProviderStateMixin {
  RiveAnimationController _controller;
  Artboard _riveArtboard;
  double opacity;
  var covidInfo;
  String city = "Loading";

  @override
  void initState() {
    init();
    load();
    super.initState();
  }

  void animation() {}

  void load() {
    rootBundle.load('assets/housepole.riv').then(
      (data) async {
        var file = RiveFile.import(data);
        if (file != null) {
          var artboard = file.mainArtboard;
          artboard.addController(
            _controller = SimpleAnimation('start'),
          );
          _controller.isActive = true;
          setState(() => _riveArtboard = artboard);
        }
      },
    );
  }

  init() async {
    covidInfo = await ParseHTML.getInfoCOVID();
    //Prevent null returns, the database is not stable and not made for continuous loop hence sleep function
    while (covidInfo == null) {
      covidInfo = await ParseHTML.getInfoCOVID();
      sleep(Duration(milliseconds: 200));
    }
    city = (await Store.readFile())[0];
    setState(() {
      covidInfo = covidInfo;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = NeumorphicTheme.currentTheme(context);
    return Scaffold(
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          Container(
            child: SliverPersistentHeader(
              pinned: true,
              delegate: CustomHeaderDelegate(
                expandedHeight: 300,
                theme: theme,
                riveArtboard: _riveArtboard,
                city: city,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(
                  height: 150,
                ),
              ],
            ),
          ),
          if (covidInfo != null)
            content(theme, covidInfo)
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
  final Artboard riveArtboard;
  final NeumorphicThemeData theme;
  final String city;

  CustomHeaderDelegate(
      {@required this.expandedHeight,
      @required this.riveArtboard,
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
        buildBackground(shrinkOffset, riveArtboard, theme),
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
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: subtract(150, shrinkOffset * 1.25, 80),
              width: subtract(250, shrinkOffset, 140),
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.all(Radius.circular(15))),
            ),
            Positioned(
              top: add(3.0, shrinkOffset / 4, top / 2),
              right: 70,
              child: Text(
                '$city',
                style: TextStyle(fontSize: subtract(27, shrinkOffset / 7, 15)),
              ),
            ),
          ],
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
              title: Text("Dang on :L"),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBackground(
      double shrinkOffset, Artboard _riveArtboard, NeumorphicThemeData theme) {
    return Opacity(
        opacity: disappear(shrinkOffset),
        child: artBoard(_riveArtboard, theme));
  }

  Widget artBoard(Artboard _riveArtboard, NeumorphicThemeData theme) {
    return _riveArtboard == null
        ? const SizedBox(
            height: 300,
            width: 300,
          )
        : Stack(
            children: [
              Container(
                child: Rive(
                  fit: BoxFit.cover,
                  artboard: _riveArtboard,
                ),
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 1500),
                curve: Curves.easeInOutSine,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.center,
                    colors: [Colors.blue, Colors.transparent],
                  ),
                ),
              ),
            ],
          );
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

Widget content(NeumorphicThemeData theme, var listContent) => SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: Center(
              child: Container(
                height: 150,
                width: 300,
                child: NeumorphicButton(
                  style: NeumorphicStyle(
                    color: theme.variantColor,
                  ),
                  onPressed: () {},
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Icon(
                          Icons.lightbulb_outline_rounded,
                          color: theme.defaultTextColor,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        childCount: listContent.length,
      ),
    );
