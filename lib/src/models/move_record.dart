class MoveRecord {
  final String from;
  final String to;
  final String? promotion;
  final String san;
  final String fenAfter;
  final bool isCapture;
  final bool isCheck;
  final bool isCheckmate;
  final int moveNumber;
  final bool isWhiteMove;

  const MoveRecord({
    required this.from,
    required this.to,
    this.promotion,
    required this.san,
    required this.fenAfter,
    this.isCapture = false,
    this.isCheck = false,
    this.isCheckmate = false,
    required this.moveNumber,
    required this.isWhiteMove,
  });
}