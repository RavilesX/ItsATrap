import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'settings.dart';

class AudioService {
  static final AudioService I = AudioService._();
  AudioService._() {
    Settings.I.addListener(_onSettingsChanged);
    _configureMixing();
  }

  final AudioPlayer _music = AudioPlayer();
  final AudioPlayer _sfx = AudioPlayer();
  final Random _rng = Random();
  bool _musicStarted = false;
  int _currentTrack = 0;

  static const List<String> _tracks = [
    'sounds/soundtrack01.mp3',
    'sounds/soundtrack02.mp3',
  ];

  Future<void> _configureMixing() async {
    final ctx = AudioContext(
      iOS: AudioContextIOS(
        category: AVAudioSessionCategory.playback,
        options: const {AVAudioSessionOptions.mixWithOthers},
      ),
      android: const AudioContextAndroid(
        isSpeakerphoneOn: false,
        stayAwake: false,
        contentType: AndroidContentType.music,
        usageType: AndroidUsageType.media,
        audioFocus: AndroidAudioFocus.none,
      ),
    );
    await AudioPlayer.global.setAudioContext(ctx);
    await _music.setAudioContext(ctx);
    await _sfx.setAudioContext(ctx);
  }

  Future<void> startMusic() async {
    if (!Settings.I.musicOn) return;
    if (_musicStarted) {
      await _music.resume();
      return;
    }
    _musicStarted = true;
    _currentTrack = _rng.nextInt(_tracks.length);
    await _music.setReleaseMode(ReleaseMode.loop);
    await _music.setVolume(Settings.I.musicVolume);
    await _music.play(AssetSource(_tracks[_currentTrack]));
  }

  Future<void> pauseMusic() async {
    await _music.pause();
  }

  void _onSettingsChanged() {
    _music.setVolume(Settings.I.musicVolume);
    if (!Settings.I.musicOn) {
      _music.pause();
    } else if (_musicStarted) {
      _music.resume();
    }
  }

  Future<void> sfx(String asset) async {
    if (!Settings.I.sfxOn) return;
    await _sfx.stop();
    await _sfx.setVolume(Settings.I.sfxVolume);
    await _sfx.play(AssetSource('sounds/$asset'));
  }

  Future<void> dispose() async {
    Settings.I.removeListener(_onSettingsChanged);
    await _music.dispose();
    await _sfx.dispose();
  }
}
