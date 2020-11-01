import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(0),
                  topRight: Radius.circular(0),
                  bottomRight: Radius.circular(360),
                  bottomLeft: Radius.circular(360))
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
