import 'game_mode.dart';
import 'move_record.dart';

enum GameResult { none, whiteWins, blackWins, draw }

class GameState {
  final GameMode mode;
  final String currentFen;
  final List<MoveRecord> moves;
  final GameResult result;
  final String? resultReason;
  final int whiteChecks;
  final int blackChecks;
  final bool isGameOver;

  const GameState({
    required this.mode,
    required this.currentFen,
    this.moves = const [],
    this.result = GameResult.none,
    this.resultReason,
    this.whiteChecks = 0,
    this.blackChecks = 0,
    this.isGameOver = false,
  });

  GameState copyWith({
    GameMode? mode,
    String? currentFen,
    List<MoveRecord>? moves,
    GameResult? result,
    String? resultReason,
    int? whiteChecks,
    int? blackChecks,
    bool? isGameOver,
  }) {
    return GameState(
      mode: mode ?? this.mode,
      currentFen: currentFen ?? this.currentFen,
      moves: moves ?? this.moves,
      result: result ?? this.result,
      resultReason: resultReason ?? this.resultReason,
      whiteChecks: whiteChecks ?? this.whiteChecks,
      blackChecks: blackChecks ?? this.blackChecks,
      isGameOver: isGameOver ?? this.isGameOver,
    );
  }
}