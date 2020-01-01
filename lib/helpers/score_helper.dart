import 'package:shared_preferences/shared_preferences.dart';

class ScoreHelper {
  static Future<int> getScore(int dimension, int level) async {
    String key = dimension.toString() + "-" + level.toString();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getInt(key);
  }

  static Future<bool> setScore(int dimension, int level, int newScore) async {
    String key = dimension.toString() + "-" + level.toString();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int oldScore = await ScoreHelper.getScore(dimension, level);

    if (oldScore == null || newScore > oldScore) {
      prefs.setInt(key, newScore);
      return true;
    } else {
      return false;
    }
  }
}
