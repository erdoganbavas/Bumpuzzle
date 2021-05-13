import 'dart:async';

import 'package:puzzle/helpers/grid_helper.dart';
import 'package:puzzle/helpers/score_helper.dart';
import 'package:puzzle/helpers/size_helper.dart';
import 'package:puzzle/models/piece.dart';
import 'package:puzzle/models/shape.dart';
import 'package:vector_math/vector_math.dart';

class Game {
  /// game's level
  final int level;

  /// grid s dimension
  final int dimension;

  /// count of swaps on board
  int swapCount = 0;

  /// is game ended with a high score
  bool isHighScore;

  /// status of game
  GameStatus status = GameStatus.Inited;

  /// pieces / cells of grid
  List<Piece> pieces;

  /// tapped pieces
  List<Piece> tappedPieces = new List<Piece>(2);

  /// size helper
  SizeHelper _sizeHelper = SizeHelper.instance();

  /// stream game state changes
  StreamController<GameStatus> _gameStatusController =
  StreamController<GameStatus>.broadcast();
  Stream<GameStatus> get gameStatusStream => _gameStatusController.stream;

  /// stream game state changes
  StreamController<int> _swapCountStreamController =
  StreamController<int>.broadcast();
  Stream<int> get swapCountStream => _swapCountStreamController.stream;

  /// contructor
  Game(this.level, this.dimension) {
    // init pieces
    _initPieces();

    // init streams
    // no streams yet

    // change status
    setGameStatus(GameStatus.Playing);
  }

  /// inits pieces for grid
  void _initPieces() {
    List<Piece> piecesTemp = List<Piece>();

    // one cell's dimension
    double cellSize = getCellSize();

    double shapeCount = (dimension / 2) * (dimension / 2);
    for (int x = 0; x < shapeCount; x++) {
      // get 4 Pieces of a Shape and merge with previous Pieces
      piecesTemp = [...piecesTemp, ...Shape(x, dimension, level).getPieces()];
    }

    pieces = List<Piece>(piecesTemp.length);

    // shuffle pieces
    piecesTemp.shuffle();

    int pieceIndex = 0;
    for (int x = 0; x < dimension; x++) {
      for (int y = 0; y < dimension; y++) {
        pieceIndex = (dimension * y) + x;

        // init piece
        Piece piece = piecesTemp[pieceIndex];

        // piece's coordinate on grid
        Vector2 gridPosition = Vector2(x.toDouble(), y.toDouble());

        // set piece position on grid and screen
        piece.setPosition(gridPosition, _gridToScreenPosition(gridPosition));

        // set size - width & height
        piece.setSize(cellSize);

        // add pieces to stack
        pieces[pieceIndex] = piece;
      }
    }
  }

  ///grid position to screen position - base is grid
  Vector2 _gridToScreenPosition(Vector2 gridPosition) {
    Vector2 position;

    double cellSize = _sizeHelper.gridSide() / dimension;

    position = gridPosition.scaled(cellSize);

    return position;
  }

  /// pieces / cells one side's size
  double getCellSize() {
    return (_sizeHelper.gridSide() / dimension).floorToDouble();
  }

  /// checks if all pieces are correctly positioned
  bool checkPiecesFitted() {
    bool allFit = true;

    pieces.forEach((piece) {
      if (allFit) {
        allFit = piece.checkNeighbors(this);
      }
    });

    return allFit;
  }

  /// executes on a piece tapped in game
  void onPieceTap(Piece piece) {
    if (tappedPieces[0] == null) {
      // NO tapped piece, add this
      tappedPieces[0] = piece;
      tappedPieces[0].select();
    } else if (tappedPieces[1] == null) {
      // second tapped pieces, check and swap

      // check if same piece tapped
      if (tappedPieces[0] == piece) {
        // same piece tapped again

        // tell piece to deselect
        tappedPieces[0].deselect();

        tappedPieces[0] = null;
      } else {
        tappedPieces[1] = piece;

        // swap

        // update positions, notify pieces
        Vector2 firstPieceGridPosition = tappedPieces[0].getGridPosition();
        Vector2 secondPieceGridPosition = tappedPieces[1].getGridPosition();

        // update pieces indexes on pieces variable
        pieces[GridHelper.getFlattenIndexOfGridPosition(
            dimension, firstPieceGridPosition)] = tappedPieces[1];
        pieces[GridHelper.getFlattenIndexOfGridPosition(
            dimension, secondPieceGridPosition)] = tappedPieces[0];

        // tell pieces to move to new position
        tappedPieces[0].moveTo(secondPieceGridPosition,
            _gridToScreenPosition(secondPieceGridPosition));
        tappedPieces[1].moveTo(firstPieceGridPosition,
            _gridToScreenPosition(firstPieceGridPosition));

        // tell pieces to deselect
        tappedPieces[0].deselect();
        tappedPieces[1].deselect();

        // reset tapped pieces
        tappedPieces[0] = null;
        tappedPieces[1] = null;

        // add one more swap
        increaseSwapCount();

        // check if pieces fitted / game end
        if (checkPiecesFitted()) {
          // emit that game ends
          endGame();
        }
      }
    } else {
      // already have two tapped piece, error
      tappedPieces[0] = null;
      tappedPieces[1] = null;
    }
  }

  /// ends game. changes status. saves score
  void endGame() async {
    print("game end");

    // save score if
    isHighScore = await ScoreHelper.setScore(dimension, level, swapCount);
    if(isHighScore){
      print("High score! Saved");
    }

    setGameStatus(GameStatus.Ended);
  }

  void setGameStatus(GameStatus newStatus) {
    status = newStatus;
    _gameStatusController.sink.add(newStatus);
  }

  void closeStreams() {
    _gameStatusController.close();
    _swapCountStreamController.close();
  }

  void increaseSwapCount() {
    swapCount++;
    _swapCountStreamController.sink.add(swapCount);

  }
}

enum GameStatus { Inited, Playing, Paused, Ended }
