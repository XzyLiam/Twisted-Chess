import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/move_record.dart';

class ReviewScreen extends StatelessWidget {
  final List<MoveRecord> history;
  final String finalFen;

  const ReviewScreen({
    super.key,
    required this.history,
    required this.finalFen,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Review'),
      ),
      body: history.isEmpty
          ? Center(
              child: Text(
                'No moves were played.',
                style: GoogleFonts.inter(fontSize: 16),
              ),
            )
          : Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  color: theme.colorScheme.primary.withOpacity(0.08),
                  child: Text(
                    '${history.length} moves',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: history.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final m = history[index];
                      final isWhite = m.isWhiteMove;

                      return ListTile(
                        leading: CircleAvatar(
                          radius: 15,
                          backgroundColor: theme.colorScheme.primary.withOpacity(0.12),
                          child: Text(
                            '${m.moveNumber}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          isWhite ? '${m.moveNumber}. ${m.san}' : m.san,
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text('${m.from} → ${m.to}'),
                        trailing: m.isCheckmate
                            ? Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'Mate',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              )
                            : m.isCheck
                                ? Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.orange.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Text(
                                      'Check',
                                      style: TextStyle(
                                        color: Colors.orange,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  )
                                : null,
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}