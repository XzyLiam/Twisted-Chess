import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/move_record.dart';

class MoveList extends StatelessWidget {
  final List<MoveRecord> moves;

  const MoveList({super.key, required this.moves});

  @override
  Widget build(BuildContext context) {
    if (moves.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      height: 48,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: moves.length,
        itemBuilder: (context, index) {
          final m = moves[index];
          final isWhite = m.isWhiteMove;

          return Container(
            margin: const EdgeInsets.only(right: 6),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                isWhite ? '${m.moveNumber}. ${m.san}' : m.san,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}