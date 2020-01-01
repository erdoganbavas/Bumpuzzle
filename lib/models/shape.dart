import 'dart:math';

import 'package:flutter/material.dart';
import 'package:puzzle/models/piece.dart';
import 'package:puzzle/models/pieces/round.dart';
import 'package:puzzle/models/pieces/square.dart';
import 'package:puzzle/models/pieces/zebra-round.dart';
import 'package:puzzle/models/pieces/zebra_square.dart';

enum PieceType { Round, Square, ZebraRound }

class Shape {
  static final List<Color> shapeColors = [
    const Color(0xFF9C8ADE),
    const Color(0xFFC8B4BA),
    const Color(0xFF2E8364),
    const Color(0xFFF3DDB3),
    const Color(0xFFF99A9C),
    const Color(0xFFC1CD97),
    const Color(0xFFA02C2D),
    const Color(0xFF909090),
    const Color(0xFFFEADB9),
    const Color(0xFF38908F),
    const Color(0xFFD7E7A9),
    const Color(0xFF5E96AE),
    const Color(0xFFF0A35E),
    const Color(0xFFCA7E8D),
  ];

  final int index;
  final int dimension;
  final int level;

  Function pieceBuilder;
  Color color;

  Shape(this.index, this.dimension, this.level){
    pieceBuilder = getPieceBuilder();
    color = getColor(index);
  }

  /// builds and return array of 4 pieces according to selected random shape
  List<Piece> getPieces() {
    return [
      pieceBuilder(pieceIndex: 1, shapeIndex: index)..setColor(color),
      pieceBuilder(pieceIndex: 2, shapeIndex: index)..setColor(color),
      pieceBuilder(pieceIndex: 3, shapeIndex: index)..setColor(color),
      pieceBuilder(pieceIndex: 4, shapeIndex: index)..setColor(color),
    ];
  }

  static Color getColor(int index) {
    return shapeColors[index % shapeColors.length];
  }

  /// returns a piece builder based on level
  Function getPieceBuilder() {
    List<Function> list = [Square.build, Round.build, ZebraRound.build, ZebraSquare.build];
    var rng = new Random();
    return list[rng.nextInt(list.length) % level];
  }
}

