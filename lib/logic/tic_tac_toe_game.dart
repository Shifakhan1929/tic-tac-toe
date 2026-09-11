import 'dart:math';
import '../models/game_status.dart';
import '../models/player.dart';

/// Custom exception thrown when an illegal move is attempted.
class MoveException implements Exception {
  final String message;
  const MoveException(this.message);

  @override
  String toString() => 'MoveException: $message';
}

/// Pure Dart game engine for Tic-Tac-Toe.
/// Keeps business logic completely independent from UI widgets,
/// making it easy to test, maintain, and discuss during interviews.
class TicTacToeGame {
  static const int boardSize = 9;

  /// The 8 possible winning line patterns on a 3x3 grid.
  static const List<List<int>> winningPatterns = [
    [0, 1, 2], // Top row
    [3, 4, 5], // Middle row
    [6, 7, 8], // Bottom row
    [0, 3, 6], // Left column
    [1, 4, 7], // Middle column
    [2, 5, 8], // Right column
    [0, 4, 8], // Main diagonal
    [2, 4, 6], // Anti diagonal
  ];

  late List<Player> _board;
  Player _currentPlayer = Player.x;
  GameStatus _status = GameStatus.inProgress;
  Player _winner = Player.none;
  List<int>? _winningLine;

  TicTacToeGame({Player startingPlayer = Player.x}) {
    reset(startingPlayer: startingPlayer);
  }

  /// Unmodifiable view of the current board cells (index 0 to 8).
  List<Player> get board => List.unmodifiable(_board);

  /// The player whose turn it currently is.
  Player get currentPlayer => _currentPlayer;

  /// The current state of the game (inProgress, won, draw).
  GameStatus get status => _status;

  /// The winning player (Player.none if no winner yet or draw).
  Player get winner => _winner;

  /// The list of 3 cell indices forming the winning line, if game is won.
  List<int>? get winningLine => _winningLine != null ? List.unmodifiable(_winningLine!) : null;

  /// True if the match has concluded (either won or drawn).
  bool get isGameOver => _status.isGameOver;

  /// List of cell indices (0..8) that are currently empty.
  List<int> get availableMoves {
    final moves = <int>[];
    for (var i = 0; i < boardSize; i++) {
      if (_board[i] == Player.none) {
        moves.add(i);
      }
    }
    return moves;
  }

  /// Checks whether a move can legally be placed at [index].
  bool canMakeMove(int index) {
    if (index < 0 || index >= boardSize) return false;
    if (_status != GameStatus.inProgress) return false;
    if (_board[index] != Player.none) return false;
    return true;
  }

  /// Executes a move at the given [index] for [_currentPlayer].
  ///
  /// Throws [MoveException] if the move is invalid or the game is already over.
  void makeMove(int index) {
    if (index < 0 || index >= boardSize) {
      throw MoveException('Index $index is out of bounds (must be 0..8).');
    }
    if (_status != GameStatus.inProgress) {
      throw MoveException('Game is already over with status $_status.');
    }
    if (_board[index] != Player.none) {
      throw MoveException('Cell $index is already occupied by ${_board[index].symbol}.');
    }

    _board[index] = _currentPlayer;

    // Check if this move triggered a win
    final winningCombo = _findWinningCombination();
    if (winningCombo != null) {
      _status = GameStatus.won;
      _winner = _currentPlayer;
      _winningLine = winningCombo;
      return;
    }

    // Check if the board is completely filled with no winner (Draw)
    if (!_board.contains(Player.none)) {
      _status = GameStatus.draw;
      _winner = Player.none;
      _winningLine = null;
      return;
    }

    // Switch turns
    _currentPlayer = _currentPlayer.opponent;
  }

  /// Safe wrapper around [makeMove] that returns false instead of throwing.
  bool tryMakeMove(int index) {
    if (!canMakeMove(index)) return false;
    try {
      makeMove(index);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Returns a random empty cell index, or null if no moves are available.
  /// An optional [random] generator can be supplied (helpful for deterministic testing).
  int? getRandomMove([Random? random]) {
    final openCells = availableMoves;
    if (openCells.isEmpty) return null;
    final rng = random ?? Random();
    return openCells[rng.nextInt(openCells.length)];
  }

  /// Resets the game to an empty board.
  void reset({Player startingPlayer = Player.x}) {
    _board = List<Player>.filled(boardSize, Player.none);
    _currentPlayer = startingPlayer;
    _status = GameStatus.inProgress;
    _winner = Player.none;
    _winningLine = null;
  }

  /// Helper to check if any of the winning patterns are met.
  List<int>? _findWinningCombination() {
    for (final pattern in winningPatterns) {
      final a = _board[pattern[0]];
      final b = _board[pattern[1]];
      final c = _board[pattern[2]];

      if (a != Player.none && a == b && b == c) {
        return pattern;
      }
    }
    return null;
  }
}
