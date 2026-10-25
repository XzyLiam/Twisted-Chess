import 'package:flutter/material.dart';

class BoardTheme {
  final String name;
  final Color lightSquare;
  final Color darkSquare;
  final Color selected;
  final Color legal;
  final Color lastMove;

  const BoardTheme({
    required this.name,
    required this.lightSquare,
    required this.darkSquare,
    required this.selected,
    required this.legal,
    required this.lastMove,
  });

  static const classic = BoardTheme(
    name: 'Classic',
    lightSquare: Color(0xFFEEEED2),
    darkSquare: Color(0xFF769656),
    selected: Color(0xFFCDD26A),
    legal: Color(0x664A90A4),
    lastMove: Color(0x66CDD26A),
  );

  static const blue = BoardTheme(
    name: 'Blue',
    lightSquare: Color(0xFFDCE3E8),
    darkSquare: Color(0xFF6D8BA4),
    selected: Color(0xFF8FBCDB),
    legal: Color(0x664A90A4),
    lastMove: Color(0x668FBCDB),
  );

  static const purple = BoardTheme(
    name: 'Purple',
    lightSquare: Color(0xFFE8E0F0),
    darkSquare: Color(0xFF7B6B93),
    selected: Color(0xFFB39DDB),
    legal: Color(0x669C27B0),
    lastMove: Color(0x66B39DDB),
  );

  static const List<BoardTheme> all = [classic, blue, purple];
}