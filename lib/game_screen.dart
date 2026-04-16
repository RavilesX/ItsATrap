import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gal/gal.dart';
import 'game_logic.dart';
import 'l10n.dart';
import 'models.dart';
import 'settings.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final GameState game = GameState();
  GameMessage? _toast;
  bool _footerSad = false;
  GameMessage? _lastHandledMessage;
  final GlobalKey _captureKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    game.addListener(_onChange);
    Settings.I.addListener(_onChange);
  }

  @override
  void dispose() {
    game.removeListener(_onChange);
    Settings.I.removeListener(_onChange);
    game.dispose();
    super.dispose();
  }

  void _onChange() {
    if (!mounted) return;
    setState(() {});
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final toasts = game.drainToasts();
      if (toasts.isNotEmpty) {
        setState(() => _toast = toasts.last);
        Future.delayed(const Duration(milliseconds: 1800), () {
          if (mounted && _toast == toasts.last) {
            setState(() => _toast = null);
          }
        });
      }
      final msg = game.message;
      if (msg != null && msg != _lastHandledMessage) {
        _lastHandledMessage = msg;
        if (msg.type == MessageType.miopiaActivated ||
            msg.type == MessageType.correctionWasted) {
          setState(() => _footerSad = true);
          Future.delayed(const Duration(milliseconds: 2500), () {
            if (mounted) setState(() => _footerSad = false);
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final lang = Settings.I.lang;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          RepaintBoundary(
            key: _captureKey,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset('assets/images/background.webp', fit: BoxFit.cover),
                SafeArea(
                  child: Column(
                    children: [
                      _buildQuickMuteBar(),
                      _buildHeader(lang),
                      const SizedBox(height: 6),
                      _buildItemBar(lang),
                      Expanded(child: Center(child: _buildBoard())),
                      _buildFooter(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_toast != null) _buildToast(_toast!, lang),
          if (game.message != null) _buildFloatingMessage(game.message!, lang),
        ],
      ),
    );
  }

  Widget _buildQuickMuteBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 6, 10, 0),
      child: Row(
        children: [
          if (Settings.I.showsMineCount) _buildPandoraCounter(),
          const Spacer(),
          _muteButton(
            icon: Settings.I.musicOn ? Icons.music_note : Icons.music_off,
            active: Settings.I.musicOn,
            onTap: () => Settings.I.setMusicOn(!Settings.I.musicOn),
          ),
          const SizedBox(width: 8),
          _muteButton(
            icon: Settings.I.sfxOn ? Icons.volume_up : Icons.volume_off,
            active: Settings.I.sfxOn,
            onTap: () => Settings.I.setSfxOn(!Settings.I.sfxOn),
          ),
        ],
      ),
    );
  }

  Widget _buildPandoraCounter() {
    final remaining = game.remainingPandoras;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/images/box_closed.webp', width: 22, height: 22),
          const SizedBox(width: 6),
          Text(
            '$remaining',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w900,
              shadows: [
                Shadow(color: Colors.black87, blurRadius: 2, offset: Offset(0, 1)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _muteButton({
    required IconData icon,
    required bool active,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.35),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          size: 18,
          color: active ? Colors.white : Colors.white70,
        ),
      ),
    );
  }

  Widget _buildHeader(Lang lang) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 6, 8, 0),
      child: AspectRatio(
        aspectRatio: 1829 / 252,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset('assets/images/ribbon.webp', fit: BoxFit.fill),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: _goldText(
                  '${L10n.t('title', lang)} — ${L10n.t('level', lang)} ${game.levelIndex + 1}',
                  fontSize: 26,
                  strokeWidth: 2.2,
                  letterSpacing: 0.5,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _goldText(
    String text, {
    required double fontSize,
    double strokeWidth = 1.6,
    double letterSpacing = 0,
    TextAlign textAlign = TextAlign.start,
  }) {
    const outline = Color(0xFF1A0A00);
    const glow = Color(0xFFFFB300);
    final baseStyle = TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w900,
      letterSpacing: letterSpacing,
      height: 1.1,
    );
    return Stack(
      children: [
        Text(
          text,
          textAlign: textAlign,
          style: baseStyle.copyWith(
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = strokeWidth
              ..strokeJoin = StrokeJoin.round
              ..color = outline,
            shadows: [
              Shadow(
                color: glow.withValues(alpha: 0.85),
                blurRadius: 10,
              ),
              Shadow(
                color: glow.withValues(alpha: 0.55),
                blurRadius: 18,
              ),
            ],
          ),
        ),
        Text(
          text,
          textAlign: textAlign,
          style: baseStyle.copyWith(color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildItemBar(Lang lang) {
    final showHades = Settings.I.difficulty != Difficulty.hard;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: _itemSlot(
              iconAsset: 'assets/images/Argos_eye.webp',
              onTap: (game.ojoArgos > 0 && !game.peeking && !game.gameOver)
                  ? () => _confirmUseItem(
                        name: L10n.t('ojo', lang),
                        description: L10n.t('ojo_desc', lang),
                        onUse: game.useOjoArgos,
                      )
                  : null,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: _itemSlot(
              iconAsset: 'assets/images/Atenea_correction.webp',
              onTap: (game.correccion > 0 && !game.gameOver)
                  ? () => _confirmUseItem(
                        name: L10n.t('correction', lang),
                        description: L10n.t('correction_desc', lang),
                        onUse: game.useCorreccion,
                      )
                  : null,
            ),
          ),
          if (showHades) ...[
            const SizedBox(width: 6),
            Expanded(
              child: _itemSlot(
                iconAsset: 'assets/images/hades.webp',
                highlighted: game.hadesArmed,
                onTap: (game.hadesCascos > 0 &&
                        !game.gameOver &&
                        !game.hadesArmed)
                    ? () => _confirmUseItem(
                          name: L10n.t('hades', lang),
                          description: L10n.t('hades_desc', lang),
                          onUse: game.useHades,
                        )
                    : null,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _itemSlot({
    required String iconAsset,
    VoidCallback? onTap,
    bool highlighted = false,
  }) {
    final enabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: enabled || highlighted ? 1.0 : 0.55,
        child: AspectRatio(
          aspectRatio: 150 / 72,
          child: LayoutBuilder(builder: (ctx, cons) {
            final h = cons.maxHeight;
            return Stack(
              alignment: Alignment.center,
              children: [
                Image.asset('assets/images/items.webp', fit: BoxFit.fill),
                if (highlighted)
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(h * 0.2),
                      border:
                          Border.all(color: Colors.amberAccent, width: 2.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.amberAccent.withValues(alpha: 0.7),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.all(h * 0.14),
                  child: Image.asset(iconAsset, fit: BoxFit.contain),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Future<void> _confirmUseItem({
    required String name,
    required String description,
    required VoidCallback onUse,
  }) async {
    final lang = Settings.I.lang;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.w900)),
        content: Text(description),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(L10n.t('cancel', lang)),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(L10n.t('use', lang)),
          ),
        ],
      ),
    );
    if (ok == true) onUse();
  }

  Widget _buildBoard() {
    return LayoutBuilder(
      builder: (context, constraints) {
        const outerPad = 12.0;
        const cellMargin = 2.0;
        final maxW = constraints.maxWidth - outerPad;
        final maxH = constraints.maxHeight - outerPad;
        final cellW = (maxW - cellMargin * game.cols) / game.cols;
        final cellH = (maxH - cellMargin * game.rows) / game.rows;
        final size = cellW < cellH ? cellW : cellH;
        return Padding(
          padding: const EdgeInsets.all(6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(game.rows, (r) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children:
                    List.generate(game.cols, (c) => _buildCell(r, c, size)),
              );
            }),
          ),
        );
      },
    );
  }

  Widget _buildCell(int r, int c, double size) {
    final cell = game.grid[r][c];
    final showing = cell.revealed || cell.peeking;

    Widget? inner;
    String bgAsset = 'assets/images/covered_tile.webp';

    if (!showing) {
      bgAsset = 'assets/images/covered_tile.webp';
      if (cell.flagged) {
        inner = Padding(
          padding: EdgeInsets.all(size * 0.15),
          child: Image.asset('assets/images/spear.webp', fit: BoxFit.contain),
        );
      }
    } else if (cell.content == CellContent.pandora) {
      bgAsset = 'assets/images/opened_tile.webp';
      final isExploded =
          game.gameOver && !game.won && game.lostRow == r && game.lostCol == c;
      final pandoraAsset = isExploded
          ? 'assets/images/box_opened.webp'
          : 'assets/images/box_closed.webp';
      inner = Padding(
        padding: EdgeInsets.all(size * 0.1),
        child: Image.asset(pandoraAsset, fit: BoxFit.contain),
      );
    } else if (cell.content == CellContent.miopia) {
      bgAsset = 'assets/images/opened_tile.webp';
      inner = Padding(
        padding: EdgeInsets.all(size * 0.1),
        child: Image.asset('assets/images/Argos_myopia.webp',
            fit: BoxFit.contain),
      );
    } else {
      bgAsset = 'assets/images/opened_tile.webp';
      if (cell.adjacent > 0) {
        inner = Padding(
          padding: EdgeInsets.all(size * 0.18),
          child: Image.asset('assets/images/${cell.adjacent}.webp',
              fit: BoxFit.contain),
        );
      }
    }

    final isLostCell =
        game.gameOver && !game.won && game.lostRow == r && game.lostCol == c;

    return GestureDetector(
      onTap: () => game.reveal(r, c),
      onLongPress: () => game.toggleFlag(r, c),
      child: Container(
        width: size,
        height: size,
        margin: const EdgeInsets.all(1),
        decoration: isLostCell
            ? BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFB388FF).withValues(alpha: 0.95),
                    blurRadius: size * 0.45,
                    spreadRadius: size * 0.08,
                  ),
                  BoxShadow(
                    color: const Color(0xFF7C4DFF).withValues(alpha: 0.6),
                    blurRadius: size * 0.85,
                  ),
                ],
              )
            : null,
        foregroundDecoration: isLostCell
            ? BoxDecoration(
                border: Border.all(
                  color: const Color(0xFFD1B3FF),
                  width: 2.5,
                ),
              )
            : null,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(bgAsset, width: size, height: size, fit: BoxFit.fill),
            if (inner != null) SizedBox(width: size, height: size, child: inner),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: _confirmRestart,
            child: Image.asset('assets/images/restore.webp', width: 120, height: 120),
          ),
          const Spacer(),
          Image.asset(
            _toast != null
                ? 'assets/images/atenea_surprised.webp'
                : _footerSad
                    ? 'assets/images/atenea_sad.webp'
                    : 'assets/images/atenea_idle.webp',
            height: 110,
          ),
        ],
      ),
    );
  }

  Future<void> _confirmRestart() async {
    final lang = Settings.I.lang;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Text(L10n.t('confirm_restart', lang)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(L10n.t('cancel', lang))),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(L10n.t('restart', lang))),
        ],
      ),
    );
    if (ok == true) game.restart();
  }

  Widget _buildFloatingMessage(GameMessage msg, Lang lang) {
    final isLoss = game.gameOver && !game.won;
    return Positioned.fill(
      child: GestureDetector(
        onTap: game.dismissMessage,
        child: ColoredBox(
          color: Colors.black.withValues(alpha: 0.55),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Material(
                color: Colors.transparent,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildDialogBox(msg, lang),
                    Image.asset('assets/images/${msg.character}', height: 180),
                    const SizedBox(height: 14),
                    if (game.gameOver && game.won)
                      _dialogButton(
                        label: L10n.t('next', lang),
                        onTap: () {
                          game.dismissMessage();
                          game.nextLevel();
                        },
                      )
                    else if (isLoss)
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _dialogButton(
                            label: L10n.t('save_image', lang),
                            onTap: _saveToGallery,
                            width: 150,
                          ),
                          const SizedBox(height: 8),
                          _dialogButton(
                            label: L10n.t('close', lang),
                            onTap: game.dismissMessage,
                            width: 150,
                          ),
                        ],
                      )
                    else
                      _dialogButton(
                        label: L10n.t('close', lang),
                        onTap: game.dismissMessage,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveToGallery() async {
    final lang = Settings.I.lang;
    final messenger = ScaffoldMessenger.of(context);
    final pixelRatio = MediaQuery.of(context).devicePixelRatio;
    game.dismissMessage();
    await WidgetsBinding.instance.endOfFrame;
    try {
      final boundary = _captureKey.currentContext!.findRenderObject()
          as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: pixelRatio);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) throw Exception('encode failed');
      final bytes = byteData.buffer.asUint8List();

      final hasAccess = await Gal.hasAccess() || await Gal.requestAccess();
      if (!hasAccess) throw Exception('no access');

      await Gal.putImageBytes(
        bytes,
        name: 'ateneas_field_${DateTime.now().millisecondsSinceEpoch}',
        album: 'Atenea\'s Field',
      );
      messenger.showSnackBar(
        SnackBar(content: Text(L10n.t('saved_ok', lang))),
      );
    } catch (_) {
      messenger.showSnackBar(
        SnackBar(content: Text(L10n.t('saved_fail', lang))),
      );
    }
  }

  Widget _buildDialogBox(GameMessage msg, Lang lang) {
    return SizedBox(
      width: 320,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset('assets/images/dialog.webp', fit: BoxFit.fill),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 20, 22, 28),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (msg.iconAsset != null) ...[
                  Image.asset('assets/images/${msg.iconAsset}', width: 54),
                  const SizedBox(width: 10),
                ],
                Flexible(
                  child: Text(
                    L10n.t(msg.textKey, lang),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF4A2C0F),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dialogButton({
    required String label,
    required VoidCallback onTap,
    double width = 180,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset('assets/images/main_button.webp', width: width),
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: width <= 150 ? 14 : 17,
                fontWeight: FontWeight.w900,
                shadows: const [
                  Shadow(
                      color: Colors.black54,
                      blurRadius: 3,
                      offset: Offset(0, 2)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToast(GameMessage msg, Lang lang) {
    return Positioned(
      top: 110,
      left: 20,
      right: 20,
      child: IgnorePointer(
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.92),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.amber.shade400, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (msg.iconAsset != null) ...[
                  Image.asset('assets/images/${msg.iconAsset}', width: 40),
                  const SizedBox(width: 10),
                ],
                Flexible(
                  child: Text(
                    L10n.t(msg.textKey, lang),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF4A2C0F),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
