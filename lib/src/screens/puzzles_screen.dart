import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as ch;
import 'package:google_fonts/google_fonts.dart';
import '../models/puzzle.dart';
import '../services/puzzle_service.dart';
import '../widgets/chess_board.dart';
import '../theme/board_themes.dart';

class PuzzlesScreen extends StatefulWidget {
  const PuzzlesScreen({super.key});

  @override
  State<PuzzlesScreen> createState() => _PuzzlesScreenState();
}

class _PuzzlesScreenState extends State<PuzzlesScreen> {
  late Puzzle puzzle;
  late ch.Chess game;
  String? selectedSquare;
  List<String> legalTargets = [];
  bool solved = false;
  bool failed = false;
  String message = 'Find the best move!';

  @override
  void initState() {
    super.initState();
    _loadDaily();
  }

  void _loadDaily() {
    puzzle = PuzzleService.getDailyPuzzle();
    game = ch.Chess.fromFEN(puzzle.fen);
    selectedSquare = null;
    legalTargets = [];
    solved = false;
    failed = false;
    message = 'Theme: ${puzzle.theme}';
    setState(() {});
  }

  void _onSquareTap(String square) {
    if (solved || failed) return;

    final piece = game.get(square);

    if (selectedSquare != null) {
      final move = {
        'from': selectedSquare!,
        'to': square,
      };

      // Check if this is the correct solution (very simple version)
      final attempt = '${selectedSquare!}$square';
      final correct = puzzle.solution.replaceAll(' ', '');

      if (attempt == correct || puzzle.solution.startsWith(attempt)) {
        // Correct!
        game.move(move);
        setState(() {
          solved = true;
          message = 'Correct! Well done.';
          selectedSquare = null;
          legalTargets = [];
        });
        return;
      } else {
        // Wrong
        setState(() {
          failed = true;
          message = 'Wrong move. Try again tomorrow!';
          selectedSquare = null;
          legalTargets = [];
        });
        return;
      }
    }

    if (piece != null && piece.color == game.turn) {
      final moves = game.generate_moves({'square': square});
      setState(() {
        selectedSquare = square;
        legalTargets = moves.map((m) => m.toAlgebraic).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Puzzle'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDaily,
            tooltip: 'Reload',
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            color: theme.colorScheme.primary.withOpacity(0.09),
            child: Column(
              children: [
                Text(
                  message,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (solved)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'Rating: ${puzzle.rating}',
                      style: GoogleFonts.inter(fontSize: 13),
                    ),
                  ),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ChessBoard(
              game: game,
              selectedSquare: selectedSquare,
              legalTargets: legalTargets,
              onSquareTap: _onSquareTap,
              boardTheme: BoardTheme.classic,
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Text(
              solved
                  ? 'Puzzle solved!'
                  : failed
                      ? 'Better luck tomorrow'
                      : 'White to play',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ),
        ],
      ),
    );
  }
}