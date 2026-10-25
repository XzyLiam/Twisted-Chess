import '../models/puzzle.dart';

class PuzzleService {
  // A small set of real puzzles (mate in 1 / simple tactics)
  static final List<Puzzle> _puzzles = [
    Puzzle(
      id: 'p1',
      fen: 'r1bqkb1r/pppp1ppp/2n2n2/4p2Q/2B1P3/8/PPPP1PPP/RNB1K1NR w KQkq - 4 4',
      solution: 'h5f7',
      theme: 'Mate in 1',
      rating: 1100,
    ),
    Puzzle(
      id: 'p2',
      fen: 'rnbqkbnr/pppp1ppp/8/4p3/6P1/5P2/PPPPP2P/RNBQKBNR b KQkq - 0 2',
      solution: 'd8h4',
      theme: 'Mate in 1',
      rating: 1000,
    ),
    Puzzle(
      id: 'p3',
      fen: '5rk1/6pp/8/8/8/8/5PPP/2R3K1 w - - 0 1',
      solution: 'c1c8',
      theme: 'Back rank',
      rating: 1150,
    ),
    Puzzle(
      id: 'p4',
      fen: 'r1bqk2r/pppp1ppp/2n2n2/2b1p3/2B1P3/3P1N2/PPP2PPP/RNBQK2R w KQkq - 0 1',
      solution: 'c4f7',
      theme: 'Fork',
      rating: 1250,
    ),
    Puzzle(
      id: 'p5',
      fen: '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      solution: 'e1e8',
      theme: 'Back rank',
      rating: 1050,
    ),
  ];

  /// Returns today's puzzle (simple rotation based on day of year)
  static Puzzle getDailyPuzzle() {
    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year)).inDays;
    return _puzzles[dayOfYear % _puzzles.length];
  }

  static List<Puzzle> getAll() => _puzzles;
}