import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as ch;
import '../theme/board_themes.dart';

class ChessBoard extends StatelessWidget {
  final ch.Chess game;
  final String? selectedSquare;
  final List<String> legalTargets;
  final String? lastFrom;
  final String? lastTo;
  final Function(String square) onSquareTap;
  final BoardTheme boardTheme;
  final bool flipped;

  const ChessBoard({
    super.key,
    required this.game,
    required this.selectedSquare,
    required this.legalTargets,
    required this.onSquareTap,
    this.lastFrom,
    this.lastTo,
    this.boardTheme = BoardTheme.classic,
    this.flipped = false,
  });

  String _symbol(ch.Piece piece) {
    const map = {
      'K': '♔', 'Q': '♕', 'R': '♖', 'B': '♗', 'N': '♘', 'P': '♙',
      'k': '♚', 'q': '♛', 'r': '♜', 'b': '♝', 'n': '♞', 'p': '♟',
    };
    final key = piece.color == ch.Color.WHITE
        ? piece.type.toString().toUpperCase()[0]
        : piece.type.toString().toLowerCase()[0];
    // Better mapping
    if (piece.type == ch.PieceType.KING) return piece.color == ch.Color.WHITE ? '♔' : '♚';
    if (piece.type == ch.PieceType.QUEEN) return piece.color == ch.Color.WHITE ? '♕' : '♛';
    if (piece.type == ch.PieceType.ROOK) return piece.color == ch.Color.WHITE ? '♖' : '♜';
    if (piece.type == ch.PieceType.BISHOP) return piece.color == ch.Color.WHITE ? '♗' : '♝';
    if (piece.type == ch.PieceType.KNIGHT) return piece.color == ch.Color.WHITE ? '♘' : '♞';
    if (piece.type == ch.PieceType.PAWN) return piece.color == ch.Color.WHITE ? '♙' : '♟';
    return '?';
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 8,
          ),
          itemCount: 64,
          itemBuilder: (context, index) {
            final rank = flipped ? (index ~/ 8) : 7 - (index ~/ 8);
            final file = flipped ? 7 - (index % 8) : index % 8;
            final square = '${String.fromCharCode(97 + file)}${rank + 1}';
            final isLight = (rank + file) % 2 == 1;
            final piece = game.get(square);
            final isSelected = selectedSquare == square;
            final isLegal = legalTargets.contains(square);
            final isLast = square == lastFrom || square == lastTo;

            Color color = isLight ? boardTheme.lightSquare : boardTheme.darkSquare;
            if (isSelected) color = boardTheme.selected;
            else if (isLast) color = boardTheme.lastMove;

            return GestureDetector(
              onTap: () => onSquareTap(square),
              child: Container(
                color: color,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (isLegal)
                      Container(
                        width: piece != null ? 38 : 16,
                        height: piece != null ? 38 : 16,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: piece != null ? Colors.transparent : boardTheme.legal,
                          border: piece != null
                              ? Border.all(color: boardTheme.legal, width: 4)
                              : null,
                        ),
                      ),
                    if (piece != null)
                      Text(
                        _symbol(piece),
                        style: TextStyle(
                          fontSize: 32,
                          height: 1,
                          color: piece.color == ch.Color.WHITE ? Colors.white : Colors.black87,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 1.5,
                              offset: const Offset(0.8, 0.8),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
} 