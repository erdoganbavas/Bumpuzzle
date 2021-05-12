import 'package:flutter/material.dart';
import 'package:puzzle/models/game.dart';

class GameBuilder extends InheritedWidget{
  final Widget child;
  final Game game;

  GameBuilder({this.child, this.game}) : super(child: child);

  static GameBuilder of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<GameBuilder>();
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    return false;
  }

}
