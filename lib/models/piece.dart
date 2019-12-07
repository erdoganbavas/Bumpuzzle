import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' hide Colors;

import 'game.dart';

class Piece{
  Vector2 _gridPosition;
  Vector2 _screenPosition;
  double _size;
  Color color;

  final int pieceIndex;
  final int shapeIndex;
  final Duration despawnDuration = Duration(milliseconds: 400);
  final Duration spawnDuration = Duration(milliseconds: 400);

  StreamController<PieceState> _spawnAnimationController = StreamController<PieceState>.broadcast();
  Stream<PieceState> get spawnAnimation => _spawnAnimationController.stream;

  // sends commands to widget
  StreamController<String> _widgetCommanderController = StreamController<String>.broadcast();
  Stream<String> get widgetCommander => _widgetCommanderController.stream;


  Piece({this.pieceIndex, this.shapeIndex});

  void setPosition(Vector2 gridPosition, Vector2 screenPosition) {
    _gridPosition = gridPosition;
    _screenPosition = screenPosition;
  }

  Vector2 getGridPosition() {
    return _gridPosition;
  }

  Vector2 getScreenPosition() {
    return _screenPosition;
  }

  double getSize() {
    return _size;
  }

  void setSize(double size) {
    _size = size;
  }

  void setColor(Color c){
    color = c;
  }

  /// widget of piece / UI
  Widget pieceShapeWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Colors.white,
        child: Text("Default Shape ot supposed to be seen!?"),
      ),
    );
  }

  /// return Piece's positional vector relative to the Shape
  Vector2 getPieceVector(){
    if(pieceIndex == 1) return Vector2(-1, 1);
    if(pieceIndex == 2) return Vector2(1, 1);
    if(pieceIndex == 3) return Vector2(1, -1);
    if(pieceIndex == 4) return Vector2(-1, -1);

    return null;
  }

  /// check if supplied neighobr is in correct position
  bool isNeighborPieceFit(Vector2 neighborVector, Piece neighborPiece) {
    if(neighborPiece.shapeIndex != shapeIndex) return false; // not same shape

    Vector2 neighborPieceVector = neighborPiece.getPieceVector();

    // scale neighbor vector with 2 to avoid stuck aat origin
    Vector2 neighborVectorClone = neighborVector.clone();
    neighborVectorClone.scale(2.0);

    // sum neighbor direction vector with piece vector to find neighborPieceVector
    return (getPieceVector() + neighborVectorClone) == neighborPieceVector;
  }

  bool checkNeighbors(Game game){
    return false;
  }

  /// moves piece to new position and emits
  void moveTo(Vector2 newGridPosition, Vector2 newScreenPosition) {
    setPosition(newGridPosition, newScreenPosition);

    // first despawn
    _spawnAnimationController.sink.add(PieceState.despawn);

    // move after despawnDuration
    Future.delayed(despawnDuration, (){
      _spawnAnimationController.sink.add(PieceState.move);
    });

    // spawn after this millisecond
    Future.delayed(despawnDuration * 2, (){
      _spawnAnimationController.sink.add(PieceState.spawn);
    });

  }

  /// selected state of widget to true
  void select(){
    _widgetCommanderController.sink.add("select");
  }

  /// selected state of widget to false
  void deselect(){
    _widgetCommanderController.sink.add("deselect");
  }

  /// close all streams
  void closeStreams(){
    _spawnAnimationController.close();
    _widgetCommanderController.close();
  }

  String toString(){
    return "";// pieceIndex.toString() + "|" + shapeIndex.toString() + "|"+ getGridPosition().toString();
  }
}

enum PieceState{
  despawn,
  spawn,
  move
}