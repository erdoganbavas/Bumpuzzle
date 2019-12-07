import 'dart:math';
import 'package:vector_math/vector_math.dart' hide Colors;
import 'package:flutter/material.dart';
import 'package:puzzle/helpers/grid_helper.dart';
import 'package:puzzle/models/game.dart';
import '../piece.dart';

class Round extends Piece {
  Round({pieceIndex, shapeIndex})
      : super(pieceIndex: pieceIndex, shapeIndex: shapeIndex);

  @override
  Widget pieceShapeWidget() {
    return RoundWidget(this);
    /*
    return Container(
      child: Text("R " + shapeIndex.toString()),
      decoration: BoxDecoration(
        color: color,
        borderRadius: getBorderRadius(),
      ),
    );
     */
  }

  /// this is piece of square, 3 neighbor must fit to say Piece is OK
  /// no worry about order of fitted neighbors,
  /// other pieces raise false on this situation
  @override
  bool checkNeighbors(Game game) {
    int fittedPieceCount = 0;

    GridHelper.neighborVectors.forEach((neighborVector) {
      // print(neighborVector.toString());
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
          // print("FIT " + piece.pieceIndex.toString());
          fittedPieceCount++;
        } else {
          /*if(shapeIndex == 1){
            print("NO FIT " +
                neighborVector.toString() + " " +
                toString() + " => " + neighborPiece.toString()
            );
          }*/
        }
      }
    });

    return fittedPieceCount==3;
  }

  @override
  String toString() {
    return "";//"""R " + super.toString();
  }

  BorderRadius getBorderRadius() {
    switch (pieceIndex) {
      case 1:
        return BorderRadius.only(topLeft: Radius.circular(100));
      case 2:
        return BorderRadius.only(topRight: Radius.circular(100));
      case 3:
        return BorderRadius.only(bottomRight: Radius.circular(100));
      case 4:
        return BorderRadius.only(bottomLeft: Radius.circular(100));
      default:
        return BorderRadius.only(bottomLeft: Radius.circular(100));
    }
  }

}

class RoundWidget extends StatefulWidget {
  final Round round;

  RoundWidget(this.round);

  @override
  _RoundWidgetState createState() => _RoundWidgetState();
}

class _RoundWidgetState extends State<RoundWidget> {
  double size = 0;
  BorderRadius borderRadius = BorderRadius.zero;

  @override
  void initState() {
    _initListens();

    // start spawn state
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
        width: size,
        height: size,
        duration: widget.round.spawnDuration,
        child: Text(widget.round.toString()),
        decoration: BoxDecoration(
          color: widget.round.color,
          borderRadius: borderRadius,
        ),
      ),
    );
  }

  // sets spawn variables
  void setSpawnState() {
    setState(() {
      size = widget.round.getSize();
      borderRadius = widget.round.getBorderRadius();
    });
  }

  // sets despawn variables
  void setDespawnState() {
    setState(() {
      size = 0;
      borderRadius = BorderRadius.zero;
    });
  }

  // inits stream listens
  void _initListens() {
    widget.round.spawnAnimation.listen((command) {
      if (command == PieceState.spawn) {
        setSpawnState();
      } else if (command == PieceState.despawn) {
        setDespawnState();
      }
    });
  }
}
