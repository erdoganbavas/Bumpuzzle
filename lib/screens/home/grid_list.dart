import 'package:flutter/material.dart';
import 'package:puzzle/helpers/score_helper.dart';
import 'package:puzzle/screens/game/game_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GridList extends StatefulWidget {
  final int dimension;

  GridList({Key key, this.dimension}) : super(key: key);

  @override
  _GridListState createState() => _GridListState();
}

class _GridListState extends State<GridList> {
  final List<int> _levels = List.generate(4, (i) => i + 1);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Align(
            // grid name
            alignment: Alignment.centerLeft,
            child: Container(
              width: 60,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(7),
                  topRight: Radius.circular(7),
                  bottomRight: Radius.zero,
                  bottomLeft: Radius.zero,
                ),
              ),
              child: Center(
                child: Text(
                  widget.dimension.toString() +
                      "X" +
                      widget.dimension.toString(),
                ),
              ),
            ),
          ),
          Container(
            // grid level list
            width: MediaQuery.of(context).size.width,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.only(
                topLeft: Radius.zero,
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: _levels.map((level) {
                    // CELL
                    return FutureBuilder(
                      future: ScoreHelper.getScore(widget.dimension, level),
                      builder:
                          (BuildContext context, AsyncSnapshot<int> snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                            return Container();
                          case ConnectionState.active:
                          case ConnectionState.waiting:
                            return Container();
                          case ConnectionState.done:
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 4,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => GameScreen(
                                        dimension: widget.dimension,
                                        level: level,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 60.0,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    color: Colors.pink[
                                        snapshot.data == null ? 300 : 500],
                                  ),
                                  child: Stack(
                                    children: <Widget>[
                                      Center(
                                        child: Text(
                                          level.toString(),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                      snapshot.data != null
                                          ? Align(
                                              alignment: Alignment.bottomRight,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: Text(
                                                  snapshot.data.toString(),
                                                  style: TextStyle(
                                                      color: Colors.white70,
                                                    fontSize: 12
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Container()
                                    ],
                                  ),
                                ),
                              ),
                            );
                        }
                        return Container();
                      },
                    );
                  }).toList()),
            ),
          ),
        ],
      ),
    );
  }
}
