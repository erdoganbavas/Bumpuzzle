import 'package:flutter/material.dart';
import 'package:puzzle/screens/game/game_screen.dart';

class GridList extends StatelessWidget {
  final int dimension;
  final List<int> _levels = List.generate(10, (i) => i + 1); // no zero

  GridList({Key key, this.dimension}) : super(key: key);

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
                  child:
                      Text(dimension.toString() + "X" + dimension.toString())),
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
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 4),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GameScreen(
                                dimension: dimension,
                                level: level,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: 60.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: Colors.pink[400], // Theme.of(context).buttonColor,
                          ),
                          child: Center(
                            child: Text(
                              level.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList()),
            ),
          ),
        ],
      ),
    );
  }
}
