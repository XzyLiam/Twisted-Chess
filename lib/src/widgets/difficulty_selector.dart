import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum BotDifficulty { beginner, easy, medium, hard }

class DifficultySelector extends StatelessWidget {
  final BotDifficulty selected;
  final ValueChanged<BotDifficulty> onChanged;

  const DifficultySelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bot Difficulty',
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: BotDifficulty.values.map((diff) {
            final isSelected = diff == selected;
            return ChoiceChip(
              label: Text(_label(diff)),
              selected: isSelected,
              onSelected: (_) => onChanged(diff),
              selectedColor: Theme.of(context).colorScheme.primary,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : null,
                fontWeight: FontWeight.w600,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  String _label(BotDifficulty d) {
    switch (d) {
      case BotDifficulty.beginner:
        return 'Beginner';
      case BotDifficulty.easy:
        return 'Easy';
      case BotDifficulty.medium:
        return 'Medium';
      case BotDifficulty.hard:
        return 'Hard';
    }
  }
}