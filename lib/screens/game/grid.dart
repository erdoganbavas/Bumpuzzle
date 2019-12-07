import 'package:flutter/material.dart';
import 'package:puzzle/helpers/size_helper.dart';
import 'package:puzzle/models/game.dart';
import 'package:puzzle/screens/game/game_builder.dart';
import 'package:puzzle/screens/game/piece_widget.dart';

class Grid extends StatefulWidget {
  @override
  _GridState createState() => _GridState();
}

class _GridState extends State<Grid> {
  SizeHelper sizeHelper = SizeHelper.instance();
  double cellDimension;
  Game game;

  /// init context based stuff here b/c initState doesn't have proper context
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final game = GameBuilder.of(context).game;
    if (this.game != game) {
      this.game = game;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: sizeHelper.gridPadding(),
      child: SizedBox(
        height: sizeHelper.bodyHeight(),
        width: sizeHelper.width,
        child: Container(
          color: Theme.of(context).backgroundColor,
          child: Stack(
            children: game.pieces.map((piece) {
              return PieceWidget(
                piece: piece,
                game: game,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
