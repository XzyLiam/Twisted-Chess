enum GameModeId {
  standard,
  chess960,
  roooooook,
  bigBoard,
  atomic,
  threeCheck,
  kingOfTheHill,
  pawnStorm,
  queensRevolt,
}

class GameMode {
  final GameModeId id;
  final String name;
  final String description;
  final String emoji;
  final bool isVariant;
  final int boardSize;

  const GameMode({
    required this.id,
    required this.name,
    required this.description,
    required this.emoji,
    this.isVariant = true,
    this.boardSize = 8,
  });

  static const List<GameMode> all = [
    GameMode(
      id: GameModeId.standard,
      name: 'Standard',
      description: 'Classic chess rules',
      emoji: '♟️',
      isVariant: false,
    ),
    GameMode(
      id: GameModeId.chess960,
      name: 'Chess960',
      description: 'Fischer Random starting position',
      emoji: '🎲',
    ),
    GameMode(
      id: GameModeId.roooooook,
      name: 'ROOOOOOK',
      description: 'Knights and Bishops are all replaced by Rooks',
      emoji: '♜',
    ),
    GameMode(
      id: GameModeId.bigBoard,
      name: 'Big Board',
      description: '10×10 board with extra pieces',
      emoji: '📐',
      boardSize: 10,
    ),
    GameMode(
      id: GameModeId.atomic,
      name: 'Atomic',
      description: 'Captures cause explosions',
      emoji: '💥',
    ),
    GameMode(
      id: GameModeId.threeCheck,
      name: 'Three-Check',
      description: 'First to give 3 checks wins',
      emoji: '✅',
    ),
    GameMode(
      id: GameModeId.kingOfTheHill,
      name: 'King of the Hill',
      description: 'Move your king to the center to win',
      emoji: '👑',
    ),
    GameMode(
      id: GameModeId.pawnStorm,
      name: 'Pawn Storm',
      description: 'Pawns can always move two squares',
      emoji: '🌪️',
    ),
    GameMode(
      id: GameModeId.queensRevolt,
      name: 'Queen\'s Revolt',
      description: 'Both sides start with two queens',
      emoji: '♕',
    ),
  ];
}