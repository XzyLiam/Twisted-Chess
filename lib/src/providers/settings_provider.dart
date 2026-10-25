import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/storage_service.dart';
import '../services/sound_service.dart';

class SettingsState {
  final bool soundEnabled;
  final bool darkMode;

  const SettingsState({
    this.soundEnabled = true,
    this.darkMode = false,
  });

  SettingsState copyWith({bool? soundEnabled, bool? darkMode}) {
    return SettingsState(
      soundEnabled: soundEnabled ?? this.soundEnabled,
      darkMode: darkMode ?? this.darkMode,
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
    _sound.enabled = sound;
    state = SettingsState(soundEnabled: sound, darkMode: dark);
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
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});