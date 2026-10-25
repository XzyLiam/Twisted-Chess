import 'package:flutter/material.dart';

class BoardTheme {
  final String id;
  final String name;
  final Color lightSquare;
  final Color darkSquare;
  final Color selected;
  final Color legal;
  final Color lastMove;

  const BoardTheme({
    required this.id,
    required this.name,
    required this.lightSquare,
    required this.darkSquare,
    required this.selected,
    required this.legal,
    required this.lastMove,
  });

  static const classic = BoardTheme(
    id: 'classic',
    name: 'Classic Green',
    lightSquare: Color(0xFFEEEED2),
    darkSquare: Color(0xFF769656),
    selected: Color(0xFFCDD26A),
    legal: Color(0x664A90A4),
    lastMove: Color(0x66CDD26A),
  );

  static const blue = BoardTheme(
    id: 'blue',
    name: 'Ocean Blue',
    lightSquare: Color(0xFFDCE3E8),
    darkSquare: Color(0xFF6D8BA4),
    selected: Color(0xFF8FBCDB),
    legal: Color(0x664A90A4),
    lastMove: Color(0x668FBCDB),
  );

  static const purple = BoardTheme(
    id: 'purple',
    name: 'Royal Purple',
    lightSquare: Color(0xFFEDE4F5),
    darkSquare: Color(0xFF7B6B93),
    selected: Color(0xFFB39DDB),
    legal: Color(0x669C27B0),
    lastMove: Color(0x66B39DDB),
  );

  static const brown = BoardTheme(
    id: 'brown',
    name: 'Walnut',
    lightSquare: Color(0xFFF0D9B5),
    darkSquare: Color(0xFFB58863),
    selected: Color(0xFFDAC08A),
    legal: Color(0x66A67C52),
    lastMove: Color(0x66DAC08A),
  );

  static const dark = BoardTheme(
    id: 'dark',
    name: 'Dark Mode',
    lightSquare: Color(0xFF3C3C3C),
    darkSquare: Color(0xFF262626),
    selected: Color(0xFF5A5A5A),
    legal: Color(0x664A90A4),
    lastMove: Color(0x665A5A5A),
  );

  static const red = BoardTheme(
    id: 'red',
    name: 'Crimson',
    lightSquare: Color(0xFFF0D0D0),
    darkSquare: Color(0xFFA65C5C),
    selected: Color(0xFFE09090),
    legal: Color(0x66C07070),
    lastMove: Color(0x66E09090),
  );

  static const List<BoardTheme> all = [
    classic,
    blue,
    purple,
    brown,
    dark,
    red,
  ];

  static BoardTheme fromId(String id) {
    return all.firstWhere((t) => t.id == id, orElse: () => classic);
  }
}