import 'package:flutter/material.dart';
import 'package:puzzle/models/game.dart';
import 'package:puzzle/models/piece.dart';
import 'package:vector_math/vector_math.dart' hide Colors;

class PieceWidget extends StatefulWidget {
  final Piece piece;
  final Game game;

  const PieceWidget({Key key, this.piece, this.game}) : super(key: key);

  @override
  _PieceWidgetState createState() => _PieceWidgetState();


}

class _PieceWidgetState extends State<PieceWidget> {
  bool isSelected = false;
  Vector2 screenPosition;

  @override
  void initState() {
    // init stream listens
    _initListens();

    screenPosition = widget.piece.getScreenPosition();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: screenPosition.y,
      left: screenPosition.x,
      width: widget.piece.getSize(),
      height: widget.piece.getSize(),
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
            decoration: BoxDecoration(
              color: isSelected ? Colors.black12 : Theme.of(context).backgroundColor,
            ),
            child: widget.piece.pieceShapeWidget(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    widget.piece.closeStreams();
    super.dispose();
  }

  // executes on tap
  void onTap() {
    // print(widget.piece.getGridPosition().toString());
    // tell game model
    if(widget.game.status == GameStatus.Playing){
      widget.game.onPieceTap(widget.piece);
    }
  }

  // inits stream listens
  void _initListens(){
    // set state of position
    widget.piece.spawnAnimation.listen((state){
      if(state==PieceState.move){
        setState(() {
          screenPosition = widget.piece.getScreenPosition();
        });
      }
    });

    // listen model's commands
    widget.piece.widgetCommander.listen((command){
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

  // piece selected
  void select(){
    setState(() {
      isSelected = true;
    });
  }

  // piece deselected
  void deselect(){
    setState(() {
      isSelected = false;
    });
  }
}
