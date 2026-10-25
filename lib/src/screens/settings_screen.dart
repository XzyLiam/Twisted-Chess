import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: Text('Sound Effects', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
            subtitle: const Text('Move and capture sounds'),
            value: settings.soundEnabled,
            onChanged: (_) => ref.read(settingsProvider.notifier).toggleSound(),
          ),
          SwitchListTile(
            title: Text('Dark Mode', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
            subtitle: const Text('Use dark theme'),
            value: settings.darkMode,
            onChanged: (_) => ref.read(settingsProvider.notifier).toggleDarkMode(),
          ),
          const Divider(height: 32),
          ListTile(
            title: Text('About TwistChess', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
            subtitle: const Text('Version 1.0.0 – Made with Flutter'),
          ),
        ],
      ),
    );
  }
}