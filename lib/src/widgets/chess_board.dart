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

  String _pieceSymbol(ch.Piece piece) {
    if (piece.type == ch.PieceType.KING) {
      return piece.color == ch.Color.WHITE ? '♔' : '♚';
    }
    if (piece.type == ch.PieceType.QUEEN) {
      return piece.color == ch.Color.WHITE ? '♕' : '♛';
    }
    if (piece.type == ch.PieceType.ROOK) {
      return piece.color == ch.Color.WHITE ? '♖' : '♜';
    }
    if (piece.type == ch.PieceType.BISHOP) {
      return piece.color == ch.Color.WHITE ? '♗' : '♝';
    }
    if (piece.type == ch.PieceType.KNIGHT) {
      return piece.color == ch.Color.WHITE ? '♘' : '♞';
    }
    if (piece.type == ch.PieceType.PAWN) {
      return piece.color == ch.Color.WHITE ? '♙' : '♟';
    }
    return '?';
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.22),
              blurRadius: 14,
              offset: const Offset(0, 5),
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
            final isLastMove = square == lastFrom || square == lastTo;

            Color squareColor = isLight ? boardTheme.lightSquare : boardTheme.darkSquare;
            if (isSelected) {
              squareColor = boardTheme.selected;
            } else if (isLastMove) {
              squareColor = boardTheme.lastMove;
            }

            return GestureDetector(
              onTap: () => onSquareTap(square),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 120),
                color: squareColor,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Legal move indicator
                    if (isLegal)
                      Container(
                        width: piece != null ? 40 : 17,
                        height: piece != null ? 40 : 17,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: piece != null ? Colors.transparent : boardTheme.legal,
                          border: piece != null
                              ? Border.all(color: boardTheme.legal, width: 4.5)
                              : null,
                        ),
                      ),

                    // Piece
                    if (piece != null)
                      Text(
                        _pieceSymbol(piece),
                        style: TextStyle(
                          fontSize: 34,
                          height: 1.0,
                          color: piece.color == ch.Color.WHITE
                              ? Colors.white
                              : Colors.black87,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.35),
                              blurRadius: 2,
                              offset: const Offset(1, 1),
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