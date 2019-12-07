import 'package:vector_math/vector_math.dart';

class GridHelper {
  /// neighbor 8-direction for a cell, should be const
  static final List<Vector2> neighborVectors = [
    Vector2(1.0, 1.0),
    Vector2(1.0, 0.0),
    Vector2(1.0, -1.0),
    Vector2(0.0, -1.0),
    Vector2(-1.0, -1.0),
    Vector2(-1.0, 0.0),
    Vector2(-1.0, 1.0),
    Vector2(0.0, 1.0),
  ];

  /// returns Vector2 position on grid of specified neighbor
  static Vector2 getGridPositionOfNeighbor(
      int dimension, Vector2 gridPosition, Vector2 direction) {

    // clone grid position
    Vector2 neighborGridPosition = Vector2(gridPosition.x, gridPosition.y);

    // add direction
    neighborGridPosition.y += direction.y > 0 ? 1 : (direction.y < 0 ? -1 : 0);
    neighborGridPosition.x += direction.x > 0 ? 1 : (direction.x < 0 ? -1 : 0);

    if ((neighborGridPosition.x < 0 || neighborGridPosition.x > (dimension - 1) )
        || (neighborGridPosition.y < 0 || neighborGridPosition.y > (dimension - 1) )
    ) {
      return null;
    }

    return neighborGridPosition;
  }

  /// returns the index of specified neighbor in on pieces array
  static int getFlattenedIndexOfNeighbor(
      int dimension, Vector2 gridPosition, Vector2 direction) {

    var neighborGridPosition = getGridPositionOfNeighbor(dimension, gridPosition, direction);
    //print("neighborGridPosition => " + neighborGridPosition.toString());

    if (neighborGridPosition == null) return null;

    return getFlattenIndexOfGridPosition(dimension, neighborGridPosition);
  }

  /// turns grid position to flatten index
  static int getFlattenIndexOfGridPosition(
      int dimension, Vector2 gridPosition) {
    return (dimension * gridPosition.y.toInt()) + gridPosition.x.toInt();
  }
}
