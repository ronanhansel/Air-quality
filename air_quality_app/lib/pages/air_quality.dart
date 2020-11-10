import 'package:flutter/material.dart';

class AirQuality extends StatefulWidget {
  @override
  _AirQualityState createState() => _AirQualityState();
}

class _AirQualityState extends State<AirQuality> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: Hero(
            tag: "air_quality",
            child: Material(
              color: Colors.transparent,
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Color(0xFF42E695),
                    Color(0xFF3BB2B8)
                  ]),
                  borderRadius: BorderRadius.all(
                      Radius.circular(0)),
                ),
                child: Center(
                  child: CustomScrollView(
                    physics: BouncingScrollPhysics(),
                    slivers: [
                      SliverAppBar(
                        pinned: true,
                        expandedHeight: 200,
                        stretch: true,
                        shape: ContinuousRectangleBorder(
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(40),
                                bottomLeft: Radius.circular(40))),
                        flexibleSpace: FlexibleSpaceBar(
                            stretchModes: [
                              StretchMode.fadeTitle,
                            ],
                            title: Text('Hello')
                        ),
                      ),
                      SliverList(
                          delegate: SliverChildListDelegate(
                              [
                                Text('The air quality is good')
                              ]
                          ))
                    ],
                  )
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
