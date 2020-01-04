import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:puzzle/models/game.dart';
import 'package:puzzle/screens/game/game_builder.dart';
import 'package:puzzle/screens/game/game_screen.dart';

class GameOverDialog extends StatefulWidget {
  const GameOverDialog({Key key}) : super(key: key);

  @override
  _GameOverDialogState createState() => _GameOverDialogState();
}

class _GameOverDialogState extends State<GameOverDialog> {
  Game game;
  String recordMessage;
  bool _show = false;

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
    if (!_show) {
      return Container();
    }

    return SimpleDialog(
      backgroundColor: Colors.pink[500],
      title: Center(
        child: Text(
          'GAME OVER',
          style: TextStyle(
            color: Colors.white,
            fontSize: 44,
            fontFamily: 'ShakaPow',
          ),
        ),
      ),
      children: <Widget>[
        highScoreText(),
        SimpleDialogOption(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => GameScreen(
                  dimension: game.dimension,
                  level: game.level,
                ),
              ),
            );
          },
          child: Center(
            child: Text(
              'REPLAY',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ),
        SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Center(
            child: Text(
              'HOME',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }

  // inits stream listens
  void _initListens() {
    // listen game end
    game.gameStatusStream.listen((newStatus) {
      setState(() {
        if (newStatus == GameStatus.Ended) {
          _show = true;
        } else {
          _show = false;
        }
      });
    });
  }

  Widget highScoreText() {
    if (game.isHighScore == null || game.isHighScore == false) {
      return Container(
        padding: const EdgeInsets.only(bottom: 24),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18.0),
      child: Center(
        child: Text(
          "Congrats! High Score!",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18
          ),
        ),
      ),
    );
  }
}
