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
    return Scaffold(
      appBar: AppBar(title: const Text('Game Review')),
      body: history.isEmpty
          ? const Center(child: Text('No moves to review'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: history.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final m = history[index];
                return ListTile(
                  leading: CircleAvatar(
                    radius: 16,
                    backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.15),
                    child: Text(
                      '${m.moveNumber}',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(
                    m.san,
                    style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text('${m.from} → ${m.to}'),
                  trailing: m.isCheckmate
                      ? const Text('mate', style: TextStyle(color: Colors.red))
                      : m.isCheck
                          ? const Text('check', style: TextStyle(color: Colors.orange))
                          : null,
                );
              },
            ),
    );
  }
}