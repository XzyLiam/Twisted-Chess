class Puzzle {
  final String id;
  final String fen;
  final String solution; // e.g. "e2e4" or "e2e4 e7e5"
  final String theme;
  final int rating;

  const Puzzle({
    required this.id,
    required this.fen,
    required this.solution,
    required this.theme,
    this.rating = 1200,
  });
}