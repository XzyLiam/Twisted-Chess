import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chess/chess.dart' as ch;
import 'package:google_fonts/google_fonts.dart';

import '../models/game_mode.dart';
import '../models/move_record.dart';
import '../services/bot_service.dart';
import '../services/sound_service.dart';
import '../services/variant_engine.dart';
import '../widgets/chess_board.dart';
import '../widgets/difficulty_selector.dart';
import '../theme/board_themes.dart';
import '../providers/settings_provider.dart';
import 'review_screen.dart';

class GameScreen extends ConsumerStatefulWidget {
  final GameMode mode;
  final bool vsBot;
  final BotDifficulty difficulty;

  const GameScreen({
    super.key,
    required this.mode,
    this.vsBot = true,
    this.difficulty = BotDifficulty.medium,
  });

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  late ch.Chess game;
  String? selectedSquare;
  List<String> legalTargets = [];
  String? lastFrom;
  String? lastTo;
  final List<MoveRecord> history = [];
  final BotService bot = BotService();
  final SoundService sound = SoundService();
  bool botThinking = false;
  String status = 'White to move';
  int whiteChecks = 0;
  int blackChecks = 0;

  @override
  void initState() {
    super.initState();
    _newGame();
  }

  void _newGame() {
    final fen = VariantEngine.getStartingFen(widget.mode);
    game = ch.Chess.fromFEN(fen);
    selectedSquare = null;
    legalTargets = [];
    lastFrom = null;
    lastTo = null;
    history.clear();
    botThinking = false;
    whiteChecks = 0;
    blackChecks = 0;
    status = 'White to move';
    setState(() {});
  }

  void _onSquareTap(String square) {
    if (botThinking || game.game_over) return;

    final piece = game.get(square);

    if (selectedSquare != null) {
      final move = <String, String>{
        'from': selectedSquare!,
        'to': square,
      };

      final moving = game.get(selectedSquare!);
      if (moving != null &&
          moving.type == ch.PieceType.PAWN &&
          (square[1] == '8' || square[1] == '1')) {
        move['promotion'] = 'q';
      }

      final success = game.move(move);
      if (success) {
        _afterMove(selectedSquare!, square, move['promotion']);
        return;
      }

      if (piece != null && piece.color == game.turn) {
        _select(square);
        return;
      }

      setState(() {
        selectedSquare = null;
        legalTargets = [];
      });
      return;
    }

    if (piece != null && piece.color == game.turn) {
      _select(square);
    }
  }

  void _select(String square) {
    final moves = game.generate_moves({'square': square});
    setState(() {
      selectedSquare = square;
      legalTargets = moves.map((m) => m.toAlgebraic).toList();
    });
  }

  void _afterMove(String from, String to, String? promo) {
    // Count checks for Three-Check mode
    if (game.in_check) {
      if (game.turn == ch.Color.BLACK) {
        whiteChecks++;
      } else {
        blackChecks++;
      }
    }

    final san = game.getHistory().isNotEmpty ? game.getHistory().last : '$from$to';

    final record = MoveRecord(
      from: from,
      to: to,
      promotion: promo,
      san: san,
      fenAfter: game.fen,
      isCheck: game.in_check,
      isCheckmate: game.in_checkmate,
      moveNumber: (history.length ~/ 2) + 1,
      isWhiteMove: game.turn == ch.Color.BLACK,
    );

    history.add(record);
    lastFrom = from;
    lastTo = to;
    selectedSquare = null;
    legalTargets = [];

    // Sounds
    final captured = game.get(to) != null;
    if (captured) {
      sound.playCapture();
    } else {
      sound.playMove();
    }
    if (game.in_check) sound.playCheck();

    // Variant win conditions
    final variantResult = VariantEngine.checkVariantWin(
      game,
      widget.mode,
      whiteChecks: whiteChecks,
      blackChecks: blackChecks,
    );

    if (variantResult.isWin) {
      status = '${variantResult.winner} wins! (${variantResult.reason})';
      sound.playGameEnd();
      setState(() {});
      _showGameOver();
      return;
    }

    _updateStatus();
    setState(() {});

    if (game.game_over) {
      sound.playGameEnd();
      _showGameOver();
      return;
    }

    // Bot move
    if (widget.vsBot && game.turn == ch.Color.BLACK) {
      _makeBotMove();
    }
  }

  Future<void> _makeBotMove() async {
    setState(() => botThinking = true);

    // Thinking time depends on difficulty
    final delay = 350 + (widget.difficulty.index * 180);
    await Future.delayed(Duration(milliseconds: delay));

    final move = bot.getMove(game, widget.difficulty);
    if (move != null && mounted) {
      final from = move['from']!;
      final to = move['to']!;
      game.move(move);
      _afterMove(from, to, move['promotion']);
    }

    if (mounted) {
      setState(() => botThinking = false);
    }
  }

  void _updateStatus() {
    if (game.in_checkmate) {
      status = game.turn == ch.Color.WHITE
          ? 'Black wins by checkmate!'
          : 'White wins by checkmate!';
    } else if (game.in_stalemate) {
      status = 'Draw by stalemate';
    } else if (game.in_draw) {
      status = 'Draw';
    } else if (game.in_check) {
      status = game.turn == ch.Color.WHITE ? 'White is in check' : 'Black is in check';
    } else {
      status = game.turn == ch.Color.WHITE ? 'White to move' : 'Black to move';
    }

    // Show check counter in Three-Check
    if (widget.mode.id == GameModeId.threeCheck) {
      status += '   ✓ $whiteChecks-$blackChecks';
    }
  }

  void _showGameOver() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(
          status,
          style: GoogleFonts.inter(fontWeight: FontWeight.w700),
        ),
        content: const Text('What would you like to do?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ReviewScreen(
                    history: history,
                    finalFen: game.fen,
                  ),
                ),
              );
            },
            child: const Text('Review Game'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _newGame();
            },
            child: const Text('New Game'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('Home'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final boardTheme = ref.watch(settingsProvider).boardTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.mode.name),
        actions: [
          if (botThinking)
            const Padding(
              padding: EdgeInsets.only(right: 14),
              child: Center(
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.2,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'New Game',
            onPressed: _newGame,
          ),
        ],
      ),
      body: Column(
  children: [
    // Status bar
    Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      color: theme.colorScheme.primary.withOpacity(0.09),
      child: Text(
        botThinking ? 'Bot is thinking...' : status,
        textAlign: TextAlign.center,
        style: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // Move list
    MoveList(moves: history),

    const Spacer(),

    // Board
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: ChessBoard(
        game: game,
        selectedSquare: selectedSquare,
        legalTargets: legalTargets,
        lastFrom: lastFrom,
        lastTo: lastTo,
        onSquareTap: _onSquareTap,
        boardTheme: boardTheme,
      ),
    ),

    const Spacer(),

    // Bottom info
    Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Text(
        widget.vsBot
            ? 'vs Bot  •  ${widget.difficulty.name}'
            : 'Local Game',
        style: GoogleFonts.inter(
          fontSize: 13,
          color: theme.colorScheme.onSurface.withOpacity(0.5),
        ),
      ),
    ),
  ],
),

          const Spacer(),

          // Board
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ChessBoard(
              game: game,
              selectedSquare: selectedSquare,
              legalTargets: legalTargets,
              lastFrom: lastFrom,
              lastTo: lastTo,
              onSquareTap: _onSquareTap,
              boardTheme: boardTheme,
            ),
          ),

          const Spacer(),

          // Bottom info
          Padding(
            padding: const EdgeInsets.only(bottom: 22),
            child: Text(
              widget.vsBot
                  ? 'vs Bot  •  ${widget.difficulty.name}'
                  : 'Local Game',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}