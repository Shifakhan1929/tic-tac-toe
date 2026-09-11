/// Represents the game mode selected by the user.
enum GameMode {
  twoPlayers,
  vsComputer;

  /// User-friendly title for the mode.
  String get title {
    switch (this) {
      case GameMode.twoPlayers:
        return '2 Players (Pass & Play)';
      case GameMode.vsComputer:
        return 'Player vs Computer';
    }
  }

  /// Shorter label for toggle buttons/tabs.
  String get shortLabel {
    switch (this) {
      case GameMode.twoPlayers:
        return '2 Players';
      case GameMode.vsComputer:
        return 'vs Computer';
    }
  }
}
