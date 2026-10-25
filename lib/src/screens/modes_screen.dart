import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/game_mode.dart';
import '../widgets/mode_card.dart';
import 'game_screen.dart';

class ModesScreen extends StatelessWidget {
  const ModesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Modes'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: GameMode.all.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final mode = GameMode.all[index];
          return ModeCard(
            mode: mode,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => GameScreen(
                    mode: mode,
                    vsBot: true,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}