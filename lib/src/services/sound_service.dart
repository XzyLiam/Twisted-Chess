import 'package:flutter/services.dart';

class SoundService {
  static final SoundService _instance = SoundService._();
  factory SoundService() => _instance;
  SoundService._();

  bool enabled = true;

  Future<void> playMove() async {
    if (!enabled) return;
    SystemSound.play(SystemSoundType.click);
  }

  Future<void> playCapture() async {
    if (!enabled) return;
    SystemSound.play(SystemSoundType.click);
  }

  Future<void> playCheck() async {
    if (!enabled) return;
    SystemSound.play(SystemSoundType.alert);
  }

  Future<void> playGameEnd() async {
    if (!enabled) return;
    SystemSound.play(SystemSoundType.alert);
  }

  void toggle() {
    enabled = !enabled;
  }
}