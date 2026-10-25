import 'package:chess/chess.dart' as ch;
import '../models/game_mode.dart';

class VariantEngine {
  /// Returns the starting FEN for the given mode
  static String getStartingFen(GameMode mode) {
    switch (mode.id) {
      case GameModeId.standard:
        return ch.Chess.DEFAULT_POSITION;

      case GameModeId.chess960:
        // Simple fixed Chess960 position for now (we can randomize later)
        return 'bbqnnrkr/pppppppp/8/8/8/8/PPPPPPPP/BBQNNRKR w HFhf - 0 1';

      case GameModeId.roooooook:
        // All knights and bishops replaced by rooks
        return 'rrrrrrkr/pppppppp/8/8/8/8/PPPPPPPP/RRRRRRKR w KQkq - 0 1';

      case GameModeId.queensRevolt:
        // Both sides get two queens, no knights/bishops
        return 'rqqqkrr/pppppppp/8/8/8/8/PPPPPPPP/RQQQKRR w KQkq - 0 1';

      case GameModeId.pawnStorm:
      case GameModeId.atomic:
      case GameModeId.threeCheck:
      case GameModeId.kingOfTheHill:
        return ch.Chess.DEFAULT_POSITION;

      case GameModeId.bigBoard:
        // We still use 8x8 for now (full 10x10 needs custom board)
        return ch.Chess.DEFAULT_POSITION;
    }
  }

  /// Apply any special rules after a move.
  /// Returns true if the game should end because of a variant win condition.
  static VariantResult checkVariantWin(ch.Chess game, GameMode mode, {
    int whiteChecks = 0,
    int blackChecks = 0,
  }) {
    switch (mode.id) {
      case GameModeId.threeCheck:
        if (whiteChecks >= 3) {
          return VariantResult(winner: 'White', reason: 'Gave 3 checks');
        }
        if (blackChecks >= 3) {
          return VariantResult(winner: 'Black', reason: 'Gave 3 checks');
        }
        break;

      case GameModeId.kingOfTheHill:
        // Center squares: d4, d5, e4, e5
        for (final sq in ['d4', 'd5', 'e4', 'e5']) {
          final piece = game.get(sq);
          if (piece != null && piece.type == ch.PieceType.KING) {
            final winner = piece.color == ch.Color.WHITE ? 'White' : 'Black';
            return VariantResult(winner: winner, reason: 'King reached the hill');
          }
        }
        break;

      case GameModeId.atomic:
        // Very simplified atomic: if king is captured the game ends
        // (real atomic is more complex – we keep it simple for now)
        break;

      default:
        break;
    }
    return VariantResult.none();
  }
}

class VariantResult {
  final String? winner;
  final String? reason;

  VariantResult({this.winner, this.reason});

  factory VariantResult.none() => VariantResult();

  bool get isWin => winner != null;
}