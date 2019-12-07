import 'package:flutter/material.dart';
import 'package:puzzle/helpers/size_helper.dart';
import 'package:puzzle/screens/home/grid_list.dart';
import 'package:puzzle/screens/home/logo.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    // initiate this singleton for ease of use later
    SizeHelper sizeHelper = SizeHelper(context);

    return Container(
      color: Theme.of(context).backgroundColor,
      child: Center(
        child: Stack(
          children: [
            ...backgroundBubbles(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                LogoWidget(),
                GridList(dimension: 4),
                GridList(dimension: 6),
                GridList(dimension: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> backgroundBubbles(){
    Color color = Color(0x66F48FB1); // Colors.pink[50];
    return [
      Positioned(
        width: 150,
        height: 150,
        left: -20,
        top: 50,
        child: Container(
          decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.all(Radius.circular(100))
          ),
        ),
      ),
      Positioned(
        width: 200,
        height: 200,
        right: -40,
        top: 190,
        child: Container(
          decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.all(Radius.circular(100))
          ),
        ),
      ),
      Positioned(
        width: 250,
        height: 250,
        left: -75,
        bottom: -80,
        child: Container(
          decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.all(Radius.circular(100))
          ),
        ),
      ),
    ];
  }

}
