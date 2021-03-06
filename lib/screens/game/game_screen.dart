import 'package:flutter/material.dart';
import 'package:puzzle/models/game.dart';
import 'package:puzzle/screens/game/game_over_dialog.dart';
import 'package:puzzle/screens/game/grid.dart';
import 'package:puzzle/screens/game/game_header.dart';
import 'package:puzzle/screens/game/game_builder.dart';

class GameScreen extends StatefulWidget {
  final int level;
  final int dimension;

  GameScreen({this.dimension, this.level});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  Game game;

  @override
  void initState() {
    game = Game(widget.level, widget.dimension);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GameBuilder(
      game: game,
      child: Scaffold(
        body: Center(
          child: Stack(
            children: <Widget>[
              Container(
                color: Theme.of(context).backgroundColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GameHeader(),
                    Grid(),
                  ],
                ),
              ),
              GameOverDialog()
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    game.closeStreams();
    super.dispose();
  }
}
