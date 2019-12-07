import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:puzzle/helpers/size_helper.dart';
import 'package:puzzle/models/game.dart';
import 'package:puzzle/screens/game/game_builder.dart';

class GameHeader extends StatefulWidget {
  @override
  _GameHeaderState createState() => _GameHeaderState();
}

class _GameHeaderState extends State<GameHeader> {
  SizeHelper sizeHelper;
  Game game;
  int swapCount = 0;

  @override
  void initState() {
    sizeHelper = SizeHelper.instance();

    super.initState();
  }

  /// init context based stuff here b/c initState doesn't have proper context
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final game = GameBuilder.of(context).game;
    if (this.game != game) {
      this.game = game;

      // init listens here b/c initState doesn't have proper context
      _initListens();
    }
  }

  @override
  Widget build(BuildContext context) {
    int opacityOfCount = math.max<int>(50, swapCount*12);

    return SizedBox(
      height: sizeHelper.headerHeight,
      child: Center(
        child: Text(
          swapCount.toString(),
          style: TextStyle(
            fontFamily: 'ShakaPow',
            fontSize: 70,
            color: Color.fromARGB(opacityOfCount, 50, 50, 50)
          ),
        ),
      ),
    );
  }

  // inits stream listens
  void _initListens() {
    // listen swap count
    game.swapCountStream.listen((newCount) {
      setState(() {
        swapCount = newCount;
      });
    });
  }
}
