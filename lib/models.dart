enum CellContent { empty, pandora, miopia }

class Cell {
  CellContent content;
  bool revealed;
  bool flagged;
  bool peeking;
  int adjacent;

  Cell({
    this.content = CellContent.empty,
    this.revealed = false,
    this.flagged = false,
    this.peeking = false,
    this.adjacent = 0,
  });
}

class LevelConfig {
  final int rows;
  final int cols;
  final int mines;
  const LevelConfig(this.rows, this.cols, this.mines);
}

enum MessageType {
  itemOjo,
  itemCorrection,
  itemHades,
  hadesArmed,
  miopiaActivated,
  ojoFinished,
  correctionApplied,
  correctionWasted,
  pandoraHit,
  levelWon,
}

class GameMessage {
  final MessageType type;
  final String textKey;
  final String? iconAsset;
  final String character;
  const GameMessage({
    required this.type,
    required this.textKey,
    required this.character,
    this.iconAsset,
  });
}
