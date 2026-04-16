import 'dart:math';
import 'package:flutter/foundation.dart';
import 'audio_service.dart';
import 'models.dart';
import 'settings.dart';

class GameState extends ChangeNotifier {
  static const Map<Difficulty, List<LevelConfig>> difficulties = {
    Difficulty.easy: [
      LevelConfig(8, 8, 8),
      LevelConfig(9, 9, 10),
      LevelConfig(10, 10, 14),
      LevelConfig(11, 11, 18),
      LevelConfig(12, 12, 22),
    ],
    Difficulty.medium: [
      LevelConfig(9, 9, 12),
      LevelConfig(10, 10, 16),
      LevelConfig(12, 12, 24),
      LevelConfig(13, 13, 30),
      LevelConfig(14, 14, 38),
    ],
    Difficulty.hard: [
      LevelConfig(10, 10, 18),
      LevelConfig(12, 12, 28),
      LevelConfig(13, 13, 36),
      LevelConfig(14, 14, 44),
      LevelConfig(16, 16, 58),
    ],
  };

  int levelIndex = 0;
  late int rows;
  late int cols;
  late int mineCount;
  late List<List<Cell>> grid;

  bool firstClick = true;
  bool gameOver = false;
  bool won = false;
  bool peeking = false;
  bool numbersDirty = false;

  int ojoArgos = 0;
  int correccion = 0;
  int hadesCascos = 0;
  bool _hadesShieldNext = false;

  int? lostRow;
  int? lostCol;

  bool get hadesArmed => _hadesShieldNext;

  GameMessage? message;

  final Random _rng = Random();
  final Set<int> _completedRows = {};
  final Set<int> _completedCols = {};
  final List<GameMessage> _toasts = [];

  GameState() {
    _setupLevel();
  }

  List<LevelConfig> get _levels =>
      difficulties[Settings.I.difficulty] ?? difficulties[Difficulty.medium]!;

  LevelConfig get config => _levels[min(levelIndex, _levels.length - 1)];

  int get flaggedCount {
    int n = 0;
    for (final row in grid) {
      for (final cell in row) {
        if (cell.flagged) n++;
      }
    }
    return n;
  }

  int get remainingPandoras => mineCount - flaggedCount;

  List<GameMessage> drainToasts() {
    final out = List<GameMessage>.from(_toasts);
    _toasts.clear();
    return out;
  }

  void _setupLevel() {
    final cfg = config;
    rows = cfg.rows;
    cols = cfg.cols;
    final maxPossible = rows * cols - 15;
    mineCount = (cfg.mines + Settings.I.extraPandoras).clamp(1, maxPossible);
    grid = List.generate(rows, (_) => List.generate(cols, (_) => Cell()));
    firstClick = true;
    gameOver = false;
    won = false;
    peeking = false;
    numbersDirty = false;
    _hadesShieldNext = false;
    lostRow = null;
    lostCol = null;
    _completedRows.clear();
    _completedCols.clear();
    message = null;
    notifyListeners();
  }

  void _placeMines(int safeR, int safeC) {
    final banned = <int>{_idx(safeR, safeC)};
    for (final nb in _neighbors(safeR, safeC)) {
      banned.add(_idx(nb.$1, nb.$2));
    }

    int placed = 0;
    while (placed < mineCount) {
      final r = _rng.nextInt(rows);
      final c = _rng.nextInt(cols);
      if (banned.contains(_idx(r, c))) continue;
      if (grid[r][c].content != CellContent.empty) continue;
      grid[r][c].content = CellContent.pandora;
      placed++;
    }

    while (true) {
      final r = _rng.nextInt(rows);
      final c = _rng.nextInt(cols);
      if (banned.contains(_idx(r, c))) continue;
      if (grid[r][c].content != CellContent.empty) continue;
      grid[r][c].content = CellContent.miopia;
      break;
    }

    _recalcNumbers();
  }

  int _idx(int r, int c) => r * cols + c;

  Iterable<(int, int)> _neighbors(int r, int c) sync* {
    for (int dr = -1; dr <= 1; dr++) {
      for (int dc = -1; dc <= 1; dc++) {
        if (dr == 0 && dc == 0) continue;
        final nr = r + dr;
        final nc = c + dc;
        if (nr < 0 || nr >= rows || nc < 0 || nc >= cols) continue;
        yield (nr, nc);
      }
    }
  }

  void _recalcNumbers() {
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        if (grid[r][c].content == CellContent.pandora) continue;
        int n = 0;
        for (final nb in _neighbors(r, c)) {
          if (grid[nb.$1][nb.$2].content == CellContent.pandora) n++;
        }
        grid[r][c].adjacent = n;
      }
    }
    numbersDirty = false;
  }

  void reveal(int r, int c) {
    if (gameOver || peeking) return;
    final cell = grid[r][c];
    if (cell.revealed || cell.flagged) return;

    if (firstClick) {
      _placeMines(r, c);
      firstClick = false;
    }

    if (_hadesShieldNext) {
      _hadesShieldNext = false;
      if (cell.content != CellContent.empty) {
        cell.content = CellContent.empty;
      }
      _floodReveal(r, c);
      AudioService.I.sfx('tile.mp3');
      _addHadesPandoras();
      numbersDirty = true;
      _checkRowColBonus();
      _checkWin();
      notifyListeners();
      return;
    }

    if (cell.content == CellContent.pandora) {
      cell.revealed = true;
      lostRow = r;
      lostCol = c;
      gameOver = true;
      _revealAll();
      const pandoraKeys = [
        'pandora_msg',
        'pandora_msg_1',
        'pandora_msg_2',
        'pandora_msg_3',
        'pandora_msg_4',
        'pandora_msg_5',
        'pandora_msg_6',
        'pandora_msg_7',
        'pandora_msg_8',
        'pandora_msg_9',
        'pandora_msg_10',
        'pandora_msg_11',
        'pandora_msg_12',
        'pandora_msg_13',
        'pandora_msg_14',
        'pandora_msg_15',
        'pandora_msg_16',
        'pandora_msg_17',
        'pandora_msg_18',
        'pandora_msg_19',
        'pandora_msg_20',
        'pandora_msg_21',
        'pandora_msg_22',
        'pandora_msg_23',
        'pandora_msg_24',
        'pandora_msg_25',
        'pandora_msg_26',
      ];
      message = GameMessage(
        type: MessageType.pandoraHit,
        textKey: pandoraKeys[_rng.nextInt(pandoraKeys.length)],
        character: 'atenea_angry.webp',
        iconAsset: 'box_opened.webp',
      );
      AudioService.I.sfx('atenea_angry.mp3');
      notifyListeners();
      return;
    }

    if (cell.content == CellContent.miopia) {
      cell.revealed = true;
      _shuffleMines();
      numbersDirty = true;
      AudioService.I.sfx('argos_myopia.mp3');
      message = const GameMessage(
        type: MessageType.miopiaActivated,
        textKey: 'miopia_msg',
        character: 'atenea_sad.webp',
        iconAsset: 'Argos_myopia.webp',
      );
      Future.delayed(const Duration(milliseconds: 400),
          () => AudioService.I.sfx('atenea_sad.mp3'));
      notifyListeners();
      return;
    }

    _floodReveal(r, c);
    AudioService.I.sfx('tile.mp3');
    _checkRowColBonus();
    _checkWin();
    notifyListeners();
  }

  void _floodReveal(int r, int c) {
    final stack = <(int, int)>[(r, c)];
    while (stack.isNotEmpty) {
      final (cr, cc) = stack.removeLast();
      final cell = grid[cr][cc];
      if (cell.revealed || cell.flagged) continue;
      if (cell.content == CellContent.pandora) continue;
      if (cell.content == CellContent.miopia) continue;

      cell.revealed = true;

      if (cell.adjacent == 0) {
        for (final nb in _neighbors(cr, cc)) {
          stack.add((nb.$1, nb.$2));
        }
      }
    }
    _rollItemReward();
  }

  void _rollItemReward() {
    final canHades =
        Settings.I.difficulty != Difficulty.hard && hadesCascos < 1;
    if (canHades && _rng.nextDouble() < 0.01) {
      hadesCascos++;
      _toasts.add(const GameMessage(
        type: MessageType.itemHades,
        textKey: 'item_hades',
        character: 'atenea_surprised.webp',
        iconAsset: 'hades.webp',
      ));
      AudioService.I.sfx('item.mp3');
      Future.delayed(const Duration(milliseconds: 350),
          () => AudioService.I.sfx('atenea_surprised.mp3'));
      return;
    }

    final canOjo = ojoArgos < 1;
    final canCor = correccion < 1;
    if (!canOjo && !canCor) return;

    final roll = _rng.nextDouble();
    if (roll >= 0.05) return;

    final options = <String>[];
    if (canOjo) options.add('ojo');
    if (canCor) options.add('cor');
    final pick = options[_rng.nextInt(options.length)];

    if (pick == 'ojo') {
      ojoArgos++;
      _toasts.add(const GameMessage(
        type: MessageType.itemOjo,
        textKey: 'item_ojo',
        character: 'atenea_surprised.webp',
        iconAsset: 'Argos_eye.webp',
      ));
    } else {
      correccion++;
      _toasts.add(const GameMessage(
        type: MessageType.itemCorrection,
        textKey: 'item_correction',
        character: 'atenea_surprised.webp',
        iconAsset: 'Atenea_correction.webp',
      ));
    }

    AudioService.I.sfx('item.mp3');
    Future.delayed(const Duration(milliseconds: 350),
        () => AudioService.I.sfx('atenea_surprised.mp3'));
  }

  void _addHadesPandoras() {
    final candidates = <(int, int)>[];
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        final cell = grid[r][c];
        if (cell.revealed || cell.flagged) continue;
        if (cell.content != CellContent.empty) continue;
        candidates.add((r, c));
      }
    }
    if (candidates.length <= 2) return;
    candidates.shuffle(_rng);
    for (int i = 0; i < 2; i++) {
      final (r, c) = candidates[i];
      grid[r][c].content = CellContent.pandora;
      mineCount++;
    }
  }

  void useHades() {
    if (gameOver || hadesCascos <= 0 || _hadesShieldNext) return;
    hadesCascos--;
    _hadesShieldNext = true;
    _toasts.add(const GameMessage(
      type: MessageType.hadesArmed,
      textKey: 'hades_armed',
      character: 'atenea_surprised.webp',
      iconAsset: 'hades.webp',
    ));
    AudioService.I.sfx('item.mp3');
    notifyListeners();
  }

  void _checkRowColBonus() {
    for (int r = 0; r < rows; r++) {
      if (_completedRows.contains(r)) continue;
      bool complete = true;
      for (int c = 0; c < cols; c++) {
        final cell = grid[r][c];
        if (cell.content == CellContent.empty && !cell.revealed) {
          complete = false;
          break;
        }
      }
      if (complete) {
        _completedRows.add(r);
        _grantCorrection();
      }
    }
    for (int c = 0; c < cols; c++) {
      if (_completedCols.contains(c)) continue;
      bool complete = true;
      for (int r = 0; r < rows; r++) {
        final cell = grid[r][c];
        if (cell.content == CellContent.empty && !cell.revealed) {
          complete = false;
          break;
        }
      }
      if (complete) {
        _completedCols.add(c);
        _grantCorrection();
      }
    }
  }

  void _grantCorrection() {
    if (correccion >= 1) return;
    correccion++;
    _toasts.add(const GameMessage(
      type: MessageType.itemCorrection,
      textKey: 'item_correction',
      character: 'atenea_surprised.webp',
      iconAsset: 'Atenea_correction.webp',
    ));
    AudioService.I.sfx('item.mp3');
  }

  void _shuffleMines() {
    final removed = <(int, int)>[];
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        final cell = grid[r][c];
        if (cell.content == CellContent.pandora && !cell.flagged) {
          removed.add((r, c));
          cell.content = CellContent.empty;
        }
      }
    }

    final candidates = <(int, int)>[];
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        final cell = grid[r][c];
        if (cell.revealed) continue;
        if (cell.flagged) continue;
        if (cell.content != CellContent.empty) continue;
        candidates.add((r, c));
      }
    }
    candidates.shuffle(_rng);

    final toPlace = min(removed.length, candidates.length);
    for (int i = 0; i < toPlace; i++) {
      final (r, c) = candidates[i];
      grid[r][c].content = CellContent.pandora;
    }
  }

  void toggleFlag(int r, int c) {
    if (gameOver) return;
    final cell = grid[r][c];
    if (cell.revealed) return;
    cell.flagged = !cell.flagged;
    AudioService.I.sfx(cell.flagged ? 'spear_on.mp3' : 'spear_off.mp3');
    notifyListeners();
  }

  Future<void> useOjoArgos() async {
    if (gameOver || peeking || ojoArgos <= 0) return;
    ojoArgos--;
    peeking = true;
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        final cell = grid[r][c];
        if (!cell.revealed) cell.peeking = true;
      }
    }
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        grid[r][c].peeking = false;
      }
    }
    peeking = false;
    message = const GameMessage(
      type: MessageType.ojoFinished,
      textKey: 'ojo_used',
      character: 'atenea_surprised.webp',
      iconAsset: 'Argos_eye.webp',
    );
    AudioService.I.sfx('atenea_surprised.mp3');
    notifyListeners();
  }

  void useCorreccion() {
    if (gameOver || correccion <= 0) return;
    correccion--;
    if (!numbersDirty) {
      final keys = [
        'correction_waste_1',
        'correction_waste_2',
        'correction_waste_3',
        'correction_waste_4',
      ];
      message = GameMessage(
        type: MessageType.correctionWasted,
        textKey: keys[_rng.nextInt(keys.length)],
        character: 'atenea_angry.webp',
        iconAsset: 'Atenea_correction.webp',
      );
      AudioService.I.sfx('atenea_angry.mp3');
      notifyListeners();
      return;
    }
    _recalcNumbers();
    message = const GameMessage(
      type: MessageType.correctionApplied,
      textKey: 'correction_applied',
      character: 'atenea_idle.webp',
      iconAsset: 'Atenea_correction.webp',
    );
    notifyListeners();
  }

  void _checkWin() {
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        final cell = grid[r][c];
        if (cell.content == CellContent.empty && !cell.revealed) return;
      }
    }
    won = true;
    gameOver = true;
    message = const GameMessage(
      type: MessageType.levelWon,
      textKey: 'win_msg',
      character: 'atenea_win.webp',
    );
    AudioService.I.sfx('atenea_celebrating.mp3');
  }

  void _revealAll() {
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        grid[r][c].revealed = true;
      }
    }
  }

  void nextLevel() {
    if (!won) return;
    levelIndex++;
    _setupLevel();
  }

  void restart() {
    ojoArgos = 0;
    correccion = 0;
    hadesCascos = 0;
    _setupLevel();
  }

  void dismissMessage() {
    message = null;
    notifyListeners();
  }
}
