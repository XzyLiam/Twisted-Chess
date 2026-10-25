import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/settings_provider.dart';
import '../theme/board_themes.dart';

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
            title: Text('Sound Effects',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
            subtitle: const Text('Move and capture sounds'),
            value: settings.soundEnabled,
            onChanged: (_) =>
                ref.read(settingsProvider.notifier).toggleSound(),
          ),
          SwitchListTile(
            title: Text('Dark Mode',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
            subtitle: const Text('Use dark theme'),
            value: settings.darkMode,
            onChanged: (_) =>
                ref.read(settingsProvider.notifier).toggleDarkMode(),
          ),
          const Divider(height: 32),
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 12),
            child: Text(
              'Board Theme',
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ...BoardTheme.all.map((theme) {
            final isSelected = settings.boardThemeId == theme.id;
            return ListTile(
              title: Text(theme.name),
              leading: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey.shade400,
                    width: isSelected ? 2.5 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(child: Container(color: theme.lightSquare)),
                    Expanded(child: Container(color: theme.darkSquare)),
                  ],
                ),
              ),
              trailing: isSelected
                  ? Icon(Icons.check_circle,
                      color: Theme.of(context).colorScheme.primary)
                  : null,
              onTap: () {
                ref.read(settingsProvider.notifier).setBoardTheme(theme.id);
              },
            );
          }),
          const Divider(height: 32),
          ListTile(
            title: Text('About TwistChess',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
            subtitle: const Text('Version 1.0.0 – Made with Flutter'),
          ),
        ],
      ),
    );
  }
}