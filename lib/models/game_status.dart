/// Represents the current outcome or state of a Tic-Tac-Toe match.
enum GameStatus {
  inProgress,
  won,
  draw;

  /// Returns true if the match has reached a terminal state.
  bool get isGameOver => this == GameStatus.won || this == GameStatus.draw;
}
