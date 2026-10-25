import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/storage_service.dart';
import '../services/sound_service.dart';
import '../theme/board_themes.dart';

class SettingsState {
  final bool soundEnabled;
  final bool darkMode;
  final String boardThemeId;

  const SettingsState({
    this.soundEnabled = true,
    this.darkMode = false,
    this.boardThemeId = 'classic',
  });

  BoardTheme get boardTheme => BoardTheme.fromId(boardThemeId);

  SettingsState copyWith({
    bool? soundEnabled,
    bool? darkMode,
    String? boardThemeId,
  }) {
    return SettingsState(
      soundEnabled: soundEnabled ?? this.soundEnabled,
      darkMode: darkMode ?? this.darkMode,
      boardThemeId: boardThemeId ?? this.boardThemeId,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  final StorageService _storage = StorageService();
  final SoundService _sound = SoundService();

  SettingsNotifier() : super(const SettingsState()) {
    _load();
  }

  Future<void> _load() async {
    final sound = await _storage.getSoundEnabled();
    final dark = await _storage.getDarkMode();
    final themeId = await _storage.getBoardTheme() ?? 'classic';
    _sound.enabled = sound;
    state = SettingsState(
      soundEnabled: sound,
      darkMode: dark,
      boardThemeId: themeId,
    );
  }

  Future<void> toggleSound() async {
    final newValue = !state.soundEnabled;
    _sound.enabled = newValue;
    await _storage.setSoundEnabled(newValue);
    state = state.copyWith(soundEnabled: newValue);
  }

  Future<void> toggleDarkMode() async {
    final newValue = !state.darkMode;
    await _storage.setDarkMode(newValue);
    state = state.copyWith(darkMode: newValue);
  }

  Future<void> setBoardTheme(String id) async {
    await _storage.setBoardTheme(id);
    state = state.copyWith(boardThemeId: id);
  }
}

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});