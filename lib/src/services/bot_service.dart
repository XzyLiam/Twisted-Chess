import 'dart:math';
import 'package:chess/chess.dart' as ch;
import '../widgets/difficulty_selector.dart';

class BotService {
  final Random _random = Random();

  /// Returns a move in the format {'from': 'e2', 'to': 'e4', 'promotion': 'q'}
  Map<String, String>? getMove(ch.Chess game, BotDifficulty difficulty) {
    final moves = game.generate_moves();
    if (moves.isEmpty) return null;

    // Convert internal moves to algebraic
    final List<Map<String, String>> legal = [];
    for (final m in moves) {
      final map = <String, String>{
        'from': m.fromAlgebraic,
        'to': m.toAlgebraic,
      };
      if (m.promotion != null) {
        map['promotion'] = m.promotion!.name[0].toLowerCase();
      }
      legal.add(map);
    }

    if (legal.isEmpty) return null;

    switch (difficulty) {
      case BotDifficulty.beginner:
        // Completely random
        return legal[_random.nextInt(legal.length)];

      case BotDifficulty.easy:
        // Prefer captures sometimes
        final captures = legal.where((m) {
          final piece = game.get(m['to']!);
          return piece != null;
        }).toList();
        if (captures.isNotEmpty && _random.nextBool()) {
          return captures[_random.nextInt(captures.length)];
        }
        return legal[_random.nextInt(legal.length)];

      case BotDifficulty.medium:
        // Simple material evaluation (1-ply)
        return _bestByMaterial(game, legal, depth: 1);

      case BotDifficulty.hard:
        // Slightly deeper
        return _bestByMaterial(game, legal, depth: 2);
    }
  }

  Map<String, String> _bestByMaterial(
    ch.Chess game,
    List<Map<String, String>> legal, {
    required int depth,
  }) {
    int bestScore = -99999;
    Map<String, String>? bestMove;

    for (final move in legal) {
      final copy = ch.Chess.fromFEN(game.fen);
      copy.move(move);

      int score = _evaluate(copy);
      if (copy.turn == ch.Color.BLACK) score = -score;

      if (score > bestScore) {
        bestScore = score;
        bestMove = move;
      }
    }

    return bestMove ?? legal.first;
  }

  int _evaluate(ch.Chess g) {
    if (g.in_checkmate) return g.turn == ch.Color.WHITE ? -10000 : 10000;
    if (g.in_draw) return 0;

    const values = {
      ch.PieceType.PAWN: 100,
      ch.PieceType.KNIGHT: 320,
      ch.PieceType.BISHOP: 330,
      ch.PieceType.ROOK: 500,
      ch.PieceType.QUEEN: 900,
      ch.PieceType.KING: 20000,
    };

    int score = 0;
    for (var rank = 1; rank <= 8; rank++) {
      for (var file = 0; file < 8; file++) {
        final sq = '${String.fromCharCode(97 + file)}$rank';
        final p = g.get(sq);
        if (p != null) {
          final val = values[p.type] ?? 0;
          score += p.color == ch.Color.WHITE ? val : -val;
        }
      }
    }
    return score;
  }
}