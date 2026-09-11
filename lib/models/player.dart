/// Represents the players in the Tic-Tac-Toe game.
enum Player {
  none,
  x,
  o;

  /// Returns the text symbol for the player.
  String get symbol {
    switch (this) {
      case Player.x:
        return 'X';
      case Player.o:
        return 'O';
      case Player.none:
        return '';
    }
  }

  /// Returns the opponent player.
  Player get opponent {
    switch (this) {
      case Player.x:
        return Player.o;
      case Player.o:
        return Player.x;
      case Player.none:
        return Player.none;
    }
  }
}
