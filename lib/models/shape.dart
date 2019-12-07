import 'dart:math';

import 'package:flutter/material.dart';
import 'package:puzzle/models/piece.dart';
import 'package:puzzle/models/pieces/round.dart';
import 'package:puzzle/models/pieces/square.dart';

enum PieceType { Round, Square }

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
  PieceType pieceType;
  Color color;

  Shape(this.index, this.dimension, this.level){

    pieceType = getPieceType();
    color = getColor(index);

  }

  /// builds 4 pieces according to a selected random shape
  List<Piece> getPieces() {
    // TODO: level a göre piece seç

    switch (pieceType) {
      case PieceType.Round:
        return [
          Round(pieceIndex: 1, shapeIndex: index)..setColor(color),
          Round(pieceIndex: 2, shapeIndex: index)..setColor(color),
          Round(pieceIndex: 3, shapeIndex: index)..setColor(color),
          Round(pieceIndex: 4, shapeIndex: index)..setColor(color),
        ];
      case PieceType.Square:
        return [
          Square(pieceIndex: 1, shapeIndex: index)..setColor(color),
          Square(pieceIndex: 2, shapeIndex: index)..setColor(color),
          Square(pieceIndex: 3, shapeIndex: index)..setColor(color),
          Square(pieceIndex: 4, shapeIndex: index)..setColor(color),
        ];
      default:
        return [
          Round(pieceIndex: 1, shapeIndex: index)..setColor(color),
          Round(pieceIndex: 2, shapeIndex: index)..setColor(color),
          Round(pieceIndex: 3, shapeIndex: index)..setColor(color),
          Round(pieceIndex: 4, shapeIndex: index)..setColor(color),
        ];
    }
  }

  static Color getColor(int index) {
    return shapeColors[index % shapeColors.length];
  }

  PieceType getPieceType() {
    var rng = new Random();
    return rng.nextInt(10) > 5 ? PieceType.Round : PieceType.Square;
  }
}

