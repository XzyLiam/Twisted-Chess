import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'modes_screen.dart';
import 'game_screen.dart';
import 'puzzles_screen.dart';
import 'settings_screen.dart';
import '../models/game_mode.dart';
import '../widgets/difficulty_selector.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),
              Text(
                'TwistChess',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  color: theme.colorScheme.primary,
                  letterSpacing: -0.8,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Chess with a twist',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  color: theme.colorScheme.onSurface.withOpacity(0.55),
                ),
              ),
              const SizedBox(height: 36),

              _bigButton(
                context,
                icon: Icons.smart_toy_rounded,
                title: 'Play vs Bot',
                subtitle: 'Choose mode & difficulty',
                onTap: () => _openBotGame(context),
              ),
              const SizedBox(height: 12),
              _bigButton(
                context,
                icon: Icons.people_rounded,
                title: 'Local Game',
                subtitle: 'Pass and play',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => GameScreen(
                        mode: GameMode.all.first,
                        vsBot: false,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              _bigButton(
                context,
                icon: Icons.extension_rounded,
                title: 'Game Modes',
                subtitle: 'ROOOOOOK, Atomic, Big Board...',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ModesScreen()),
                  );
                },
              ),
              const SizedBox(height: 12),
              _bigButton(
                context,
                icon: Icons.lightbulb_rounded,
                title: 'Daily Puzzle',
                subtitle: 'Train your tactics',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PuzzlesScreen()),
                  );
                },
              ),

              const Spacer(),

              TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SettingsScreen()),
                  );
                },
                icon: const Icon(Icons.settings_rounded),
                label: const Text('Settings'),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bigButton(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: theme.colorScheme.primary, size: 26),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: theme.colorScheme.onSurface.withOpacity(0.55),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded,
                  color: theme.colorScheme.onSurface.withOpacity(0.35)),
            ],
          ),
        ),
      ),
    );
  }

  void _openBotGame(BuildContext context) {
    BotDifficulty difficulty = BotDifficulty.medium;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Play vs Bot',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 20),
                  DifficultySelector(
                    selected: difficulty,
                    onChanged: (d) => setState(() => difficulty = d),
                  ),
                  const SizedBox(height: 28),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => GameScreen(
                            mode: GameMode.all.first,
                            vsBot: true,
                            difficulty: difficulty,
                          ),
                        ),
                      );
                    },
                    child: const Text('Start Game'),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            );
          },
        );
      },
    );
  }
}