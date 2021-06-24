import 'dart:ui';

import 'package:air_quality/algorithms/apis.dart';
import 'package:air_quality/algorithms/getvalues.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:rive/rive.dart' hide LinearGradient;
import 'package:skeleton_text/skeleton_text.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

// ignore: must_be_immutable
class CO extends StatefulWidget {
  var value;

  CO({Key key, this.value}) : super(key: key);

  @override
  _COState createState() => _COState();
}

class _COState extends State<CO> with SingleTickerProviderStateMixin {
  double co = 0.0;
  RiveAnimationController _controller;
  Artboard _riveArtboard;
  double opacity;
  Color colorShadow = Colors.green;
  var listTips;

  getDataRepeat7() async {
    var number;
    database.onValue.listen((event) {
      var snapshot = event.snapshot;
      number = snapshot.value["7"];
      if (this.mounted) {
        mountFunc(number);
      }
    });
    return number;
  }

  mountFunc(var number) async {
    setState(() {
      co = number.toDouble() ?? 0.0;
    });
    setShadow();
  }

  @override
  void initState() {
    init();
    load();
    super.initState();
  }

  void animation() {}

  void load() {
    rootBundle.load('assets/mountain_view.riv').then(
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
    listTips = await getTips("cotips");
    print(listTips);
    print(listTips.length);
    co = widget.value ?? 0.0;
    getDataRepeat7();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  setShadow() {
    if (co > 35) {
      colorShadow = Colors.redAccent;
    } else {
      colorShadow = Colors.green;
    }
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
                co: co,
                theme: theme,
                riveArtboard: _riveArtboard,
                colorShadow: colorShadow,
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
          if (listTips != null)
            content(theme, listTips)
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
                            child: Container(),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          height: 40,
                          width: 70,
                          child: SkeletonAnimation(
                            shimmerDuration: 50,
                            child: Container(),
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
  final double co;
  final Artboard riveArtboard;
  final NeumorphicThemeData theme;
  final Color colorShadow;

  CustomHeaderDelegate(
      {@required this.expandedHeight,
      @required this.co,
      @required this.riveArtboard,
      @required this.theme,
      @required this.colorShadow});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final top = expandedHeight - shrinkOffset - 70;
    return Stack(
      fit: StackFit.expand,
      clipBehavior: Clip.none,
      children: [
        buildBackground(shrinkOffset, riveArtboard, theme, co),
        buildAppBar(context, co, shrinkOffset),
        Positioned(
            top: subtract(expandedHeight / 2, shrinkOffset - 70, 50),
            right: subtract((MediaQuery.of(context).size.width - 200) / 2,
                shrinkOffset, 15),
            child: bar(co, theme, shrinkOffset))
      ],
    );
  }

  double appear(shrinkOffset) => shrinkOffset / expandedHeight;

  double disappear(shrinkOffset) => 1 - shrinkOffset / expandedHeight;

  Widget buildAppBar(BuildContext context, double co, double shrinkOffset) {
    return Opacity(
      opacity: appear(shrinkOffset),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            height: kToolbarHeight,
            child: AppBar(
              backgroundColor: colorShadow.withOpacity(0.2),
              title: Text("CO"),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBackground(double shrinkOffset, Artboard _riveArtboard,
      NeumorphicThemeData theme, double co) {
    print(co);
    return Opacity(
        opacity: disappear(shrinkOffset),
        child: artBoard(_riveArtboard, theme, co, colorShadow));
  }

  Widget artBoard(Artboard _riveArtboard, NeumorphicThemeData theme, double co,
      Color colorShadow) {
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
                    colors: [colorShadow, Colors.transparent],
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

  Widget bar(double co, NeumorphicThemeData theme, double shrinkOffset) =>
      SleekCircularSlider(
        appearance: CircularSliderAppearance(
            animDurationMultiplier: 2.5,
            size: subtract(200, shrinkOffset, 60),
            customWidths: CustomSliderWidths(progressBarWidth: 10),
            customColors: CustomSliderColors(
                progressBarColors: [
                  Colors.red,
                  Colors.redAccent,
                  Colors.yellowAccent,
                  Colors.green,
                  Colors.greenAccent,
                ],
                shadowColor: co <= 35 ? Colors.green[300] : Colors.red[300],
                shadowStep: 10,
                shadowMaxOpacity: 2,
                trackColor: Colors.transparent,
                dotColor: Colors.transparent)),
        min: 0,
        max: 50,
        initialValue: co,
        innerWidget: (double wvalue) {
          return Center(
            child: Container(
              height: subtract(130, shrinkOffset, 65),
              decoration: BoxDecoration(
                  color: theme.variantColor, shape: BoxShape.circle),
              child: Center(
                child: Text(
                  '${wvalue.toStringAsFixed(2)}',
                  style: TextStyle(
                      fontSize: subtract(40, shrinkOffset / 3, 20),
                      color: theme.defaultTextColor),
                ),
              ),
            ),
          );
        },
      );

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}

Widget content(NeumorphicThemeData theme, var listTips) => SliverList(
  delegate: SliverChildBuilderDelegate(
        (context, index) {
      String key = listTips.keys.elementAt(index);
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
              child: DefaultTextStyle(
                style:
                TextStyle(color: theme.defaultTextColor, fontSize: 15),
                child: Wrap(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.lightbulb_outline_rounded,
                          color: theme.defaultTextColor,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "$key",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text("${listTips[key]}"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
    childCount: listTips.length,
  ),
);
