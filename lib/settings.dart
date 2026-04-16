import 'package:flutter/foundation.dart';
import 'l10n.dart';

enum Difficulty { easy, medium, hard }

class Settings extends ChangeNotifier {
  static final Settings I = Settings._();
  Settings._();

  Lang _lang = Lang.es;
  Difficulty _difficulty = Difficulty.medium;
  bool _musicOn = true;
  bool _sfxOn = true;
  double _musicVolume = 0.4;
  double _sfxVolume = 0.8;
  int _extraPandoras = 0;

  Lang get lang => _lang;
  Difficulty get difficulty => _difficulty;
  bool get musicOn => _musicOn;
  bool get sfxOn => _sfxOn;
  double get musicVolume => _musicVolume;
  double get sfxVolume => _sfxVolume;
  int get extraPandoras => _extraPandoras;
  bool get showsMineCount => _difficulty != Difficulty.hard;

  void addExtraPandora() {
    _extraPandoras++;
    notifyListeners();
  }

  void toggleLang() {
    _lang = _lang == Lang.es ? Lang.en : Lang.es;
    notifyListeners();
  }

  void setDifficulty(Difficulty d) {
    _difficulty = d;
    _extraPandoras = 0;
    notifyListeners();
  }

  void setMusicOn(bool v) {
    _musicOn = v;
    notifyListeners();
  }

  void setSfxOn(bool v) {
    _sfxOn = v;
    notifyListeners();
  }

  void setMusicVolume(double v) {
    _musicVolume = v.clamp(0.0, 1.0);
    notifyListeners();
  }

  void setSfxVolume(double v) {
    _sfxVolume = v.clamp(0.0, 1.0);
    notifyListeners();
  }
}
