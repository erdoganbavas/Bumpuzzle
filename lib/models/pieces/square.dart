import 'dart:math';

import 'package:flutter/material.dart';
import 'package:puzzle/helpers/grid_helper.dart';
import 'package:puzzle/models/game.dart';
import 'package:vector_math/vector_math.dart' hide Colors;

import '../piece.dart';

class Square extends Piece {
  Square({pieceIndex, shapeIndex}) : super(pieceIndex:pieceIndex, shapeIndex:shapeIndex);

  @override
  Widget pieceShapeWidget() {
    return SquareWidget(this);
  }

  @override
  bool isNeighborPieceFit(Vector2 neighborVector, Piece neighborPiece) {
    if(neighborPiece.shapeIndex != shapeIndex) return false; // not same shape

    // square doesn't matter which piece
    return true;
  }

  /// this is piece of square, 3 neighbor must fit to say Piece is OK
  /// no worry about order of fitted neighbors,
  /// other pieces raise false on this situation
  @override
  bool checkNeighbors(Game game) {
    int fittedPieceCount = 0;

    GridHelper.neighborVectors.forEach((neighborVector) {
      // get neighbor index on flatten pieces array
      Vector gridPosition = getGridPosition();

      int neighborIndex = GridHelper.getFlattenedIndexOfNeighbor(
          game.dimension,
          gridPosition,
          neighborVector
      );

      if (neighborIndex != null) {
        Piece neighborPiece = game.pieces[neighborIndex];

        if (isNeighborPieceFit(neighborVector, neighborPiece)) {
          fittedPieceCount++;
        }
      }
    });

    return fittedPieceCount==3;
  }

  @override
  String toString() {
    return "";//"""S " + super.toString();
  }
}

class SquareWidget extends StatefulWidget {
  final Square square;

  // TODO: const olmalı mı???????
  SquareWidget(this.square);

  @override
  _SquareWidgetState createState() => _SquareWidgetState();
}

class _SquareWidgetState extends State<SquareWidget> {
  double size = 0;
  double borderWidth = 0;

  @override
  void initState() {
    _initListens();

    // set spawn state with a random lateny
    Future.delayed(Duration(milliseconds: Random().nextInt(300) + 500), () {
      setSpawnState();
    });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: AnimatedContainer(
        duration: widget.square.spawnDuration,
        width: size,
        height: size,
        child: Text(widget.square.toString()),
        decoration: BoxDecoration(
          color: widget.square.color,
          border: borderWidth == 0 ? null : Border.all(
            color: Colors.blueGrey,
            width: borderWidth
          )
        ),
      ),
    );
  }


  // sets spawn variables
  void setSpawnState() {
    setState(() {
      size = widget.square.getSize();
    });
  }

  // sets despawn variables
  void setDespawnState() {
    setState(() {
      size = 0;
    });
  }

  // piece selected
  void select(){
    setState(() {
      borderWidth = 3;
    });
  }

  // piece deselected
  void deselect(){
    setState(() {
      borderWidth = 0;
    });
  }

  // inits stream listens
  void _initListens() {
    widget.square.spawnAnimation.listen((command) {
      if (command == PieceState.spawn) {
        setSpawnState();
      } else if (command == PieceState.despawn) {
        setDespawnState();
      }
    });

    // listen model's commands
    widget.square.widgetCommander.listen((command){
      switch(command){
        case "select":{
          select();
        }
        break;
        case "deselect":{
          deselect();
        }
      }
    });
  }
}
