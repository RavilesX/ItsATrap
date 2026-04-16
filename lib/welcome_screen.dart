import 'package:flutter/material.dart';
import 'audio_service.dart';
import 'game_screen.dart';
import 'l10n.dart';
import 'settings.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    Settings.I.addListener(_onSettings);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AudioService.I.startMusic();
    });
  }

  @override
  void dispose() {
    Settings.I.removeListener(_onSettings);
    super.dispose();
  }

  void _onSettings() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final lang = Settings.I.lang;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/background.webp', fit: BoxFit.cover),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                SizedBox(
                  height: 120,
                  child: Image.asset(
                    'assets/images/title_${lang == Lang.es ? 'es' : 'en'}.webp',
                    fit: BoxFit.contain,
                  ),
                ),
                const Spacer(flex: 2),
                Image.asset('assets/images/logo.webp', height: 312),
                const SizedBox(height: 14),
                _buildStartButton(lang),
                const Spacer(flex: 3),
                _buildOptionsRow(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStartButton(Lang lang) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const GameScreen()),
        );
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset('assets/images/main_button.webp', width: 240),
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              L10n.t('start', lang),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
                shadows: [
                  Shadow(color: Colors.black54, blurRadius: 4, offset: Offset(0, 2)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _circleAsset(
          asset: Settings.I.lang == Lang.es
              ? 'assets/images/spanish.webp'
              : 'assets/images/english.webp',
          onTap: Settings.I.toggleLang,
        ),
        const SizedBox(width: 20),
        _circleAsset(
          asset: 'assets/images/sound.webp',
          onTap: _openAudioSheet,
        ),
        const SizedBox(width: 20),
        _circleAsset(
          asset: 'assets/images/gear.webp',
          onTap: _openDifficultySheet,
        ),
      ],
    );
  }

  Widget _circleAsset({required String asset, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.7),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Image.asset(asset, width: 48, height: 48),
      ),
    );
  }

  void _openAudioSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFFFFF8E1),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setSheet) {
          final lang = Settings.I.lang;
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(L10n.t('audio', lang),
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                SwitchListTile(
                  title: Text(L10n.t('music', lang)),
                  value: Settings.I.musicOn,
                  onChanged: (v) {
                    Settings.I.setMusicOn(v);
                    setSheet(() {});
                  },
                ),
                Slider(
                  value: Settings.I.musicVolume,
                  onChanged: (v) {
                    Settings.I.setMusicVolume(v);
                    setSheet(() {});
                  },
                ),
                SwitchListTile(
                  title: Text(L10n.t('sfx', lang)),
                  value: Settings.I.sfxOn,
                  onChanged: (v) {
                    Settings.I.setSfxOn(v);
                    setSheet(() {});
                  },
                ),
                Slider(
                  value: Settings.I.sfxVolume,
                  onChanged: (v) {
                    Settings.I.setSfxVolume(v);
                    setSheet(() {});
                  },
                ),
              ],
            ),
          );
        });
      },
    );
  }

  void _openDifficultySheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFFFFF8E1),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setSheet) {
          final lang = Settings.I.lang;
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(L10n.t('difficulty', lang),
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                for (final d in Difficulty.values)
                  RadioListTile<Difficulty>(
                    title: Text(L10n.t(_difficultyKey(d), lang)),
                    value: d,
                    groupValue: Settings.I.difficulty,
                    onChanged: (v) {
                      if (v != null) {
                        Settings.I.setDifficulty(v);
                        setSheet(() {});
                      }
                    },
                  ),
                if (Settings.I.showsMineCount) ...[
                  const Divider(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Image.asset('assets/images/box_closed.webp',
                            width: 28, height: 28),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            L10n.t('extra_pandoras', lang),
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                        ),
                        Text(
                          '+${Settings.I.extraPandoras}',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(width: 10),
                        InkWell(
                          onTap: () {
                            Settings.I.addExtraPandora();
                            setSheet(() {});
                          },
                          customBorder: const CircleBorder(),
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: Colors.amber.shade700,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.25),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(Icons.add,
                                color: Colors.white, size: 22),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          );
        });
      },
    );
  }

  String _difficultyKey(Difficulty d) {
    switch (d) {
      case Difficulty.easy:
        return 'easy';
      case Difficulty.medium:
        return 'medium';
      case Difficulty.hard:
        return 'hard';
    }
  }
}
