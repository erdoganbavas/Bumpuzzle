import 'dart:math';
import 'package:vector_math/vector_math.dart' hide Colors;
import 'package:flutter/material.dart';
import 'package:puzzle/helpers/grid_helper.dart';
import 'package:puzzle/models/game.dart';
import '../piece.dart';

class ZebraRound extends Piece {
  ZebraRound({pieceIndex, shapeIndex})
      : super(pieceIndex: pieceIndex, shapeIndex: shapeIndex);

  static ZebraRound build({pieceIndex, shapeIndex}) {
    return ZebraRound(pieceIndex: pieceIndex, shapeIndex: shapeIndex);
  }

  @override
  Widget pieceShapeWidget() {
    return ZebraRoundWidget(this);
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
          game.dimension, gridPosition, neighborVector);

      if (neighborIndex != null) {
        Piece neighborPiece = game.pieces[neighborIndex];

        if (isNeighborPieceFit(neighborVector, neighborPiece)) {
          fittedPieceCount++;
        }
      }
    });

    return fittedPieceCount == 3;
  }

  @override
  String toString() {
    return "";
  }

  BorderRadius getCornerRadius() {
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

  Alignment getGradientCenter() {
    switch (pieceIndex) {
      case 1:
        return Alignment.bottomRight;
      case 2:
        return Alignment.bottomLeft;
      case 3:
        return Alignment.topLeft;
      case 4:
        return Alignment.topRight;
      default:
        return Alignment.bottomLeft;
    }
  }
}

class ZebraRoundWidget extends StatefulWidget {
  final ZebraRound round;

  ZebraRoundWidget(this.round);

  @override
  _ZebraRoundWidgetState createState() => _ZebraRoundWidgetState();
}

class _ZebraRoundWidgetState extends State<ZebraRoundWidget> {
  double size = 0;
  BorderRadius borderRadius = BorderRadius.zero;
  Alignment gradientCenter = Alignment.center;
  List<Color> _colors;
  List<double> _stops;

  @override
  void initState() {
    _colors = [
      widget.round.color.withAlpha(200).withRed(255),
      widget.round.color,
      widget.round.color,
      widget.round.color.withAlpha(200).withRed(255),
      widget.round.color.withAlpha(200).withRed(255),
      widget.round.color,
      widget.round.color
    ];
    // add a small fraction to overlapping stops, better result on transitions
    _stops = [1 / 4, 1.01 / 4, 2 / 4, 2.01 / 4, 3 / 4, 3.01 / 4, 4 / 4];

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
          gradient: RadialGradient(
            center: gradientCenter,
            colors: _colors,
            stops: _stops,
            radius: 1,
          ),
        ),
      ),
    );
  }

  // sets spawn variables
  void setSpawnState() {
    setState(() {
      size = widget.round.getSize();
      borderRadius = widget.round.getCornerRadius();
      gradientCenter = widget.round.getGradientCenter();
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
