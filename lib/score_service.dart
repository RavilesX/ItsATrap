import 'package:shared_preferences/shared_preferences.dart';

class ScoreService {
  static const _keyScore = 'high_score';
  static const _keyInitials = 'high_score_initials';

  static int _highScore = 0;
  static String _highScoreInitials = '';

  static int get highScore => _highScore;
  static String get highScoreInitials => _highScoreInitials;

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _highScore = prefs.getInt(_keyScore) ?? 0;
    _highScoreInitials = prefs.getString(_keyInitials) ?? '';
  }

  static Future<void> save(int score, String initials) async {
    _highScore = score;
    _highScoreInitials =
        initials.toUpperCase().substring(0, initials.length.clamp(0, 4));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyScore, score);
    await prefs.setString(_keyInitials, _highScoreInitials);
  }
}
