import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/game_mode.dart';
import '../widgets/difficulty_selector.dart';
import 'game_screen.dart';
import 'modes_screen.dart';
import 'puzzles_screen.dart';
import 'settings_screen.dart';

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
              const SizedBox(height: 36),

              // Title
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