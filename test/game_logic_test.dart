import 'package:flutter_test/flutter_test.dart';
import 'package:tic_tac_toe/logic/tic_tac_toe_game.dart';
import 'package:tic_tac_toe/models/game_status.dart';
import 'package:tic_tac_toe/models/player.dart';

void main() {
  group('TicTacToeGame Engine Tests', () {
    late TicTacToeGame game;

    setUp(() {
      game = TicTacToeGame();
    });

    test('Initial state is clean and Player X starts', () {
      expect(game.board.length, 9);
      expect(game.board.every((cell) => cell == Player.none), isTrue);
      expect(game.currentPlayer, Player.x);
      expect(game.status, GameStatus.inProgress);
      expect(game.winner, Player.none);
      expect(game.winningLine, isNull);
      expect(game.availableMoves.length, 9);
    });

    test('Alternates players after valid moves', () {
      game.makeMove(0); // X plays at 0
      expect(game.board[0], Player.x);
      expect(game.currentPlayer, Player.o);

      game.makeMove(1); // O plays at 1
      expect(game.board[1], Player.o);
      expect(game.currentPlayer, Player.x);
    });

    test('Detects row win and assigns winning line', () {
      // X: 0, 1, 2
      // O: 3, 4
      game.makeMove(0); // X
      game.makeMove(3); // O
      game.makeMove(1); // X
      game.makeMove(4); // O
      game.makeMove(2); // X wins top row

      expect(game.status, GameStatus.won);
      expect(game.winner, Player.x);
      expect(game.winningLine, [0, 1, 2]);
      expect(game.isGameOver, isTrue);
    });

    test('Detects column win', () {
      // O wins column 1: (1, 4, 7)
      game.makeMove(0); // X
      game.makeMove(1); // O
      game.makeMove(2); // X
      game.makeMove(4); // O
      game.makeMove(5); // X
      game.makeMove(7); // O wins

      expect(game.status, GameStatus.won);
      expect(game.winner, Player.o);
      expect(game.winningLine, [1, 4, 7]);
    });

    test('Detects diagonal win', () {
      // X wins diagonal: (0, 4, 8)
      game.makeMove(0); // X
      game.makeMove(1); // O
      game.makeMove(4); // X
      game.makeMove(2); // O
      game.makeMove(8); // X wins

      expect(game.status, GameStatus.won);
      expect(game.winner, Player.x);
      expect(game.winningLine, [0, 4, 8]);
    });

    test('Detects draw when all 9 cells filled without winner', () {
      // Deterministic draw sequence resulting in filled board:
      // Top: X, O, X | Mid: X, O, O | Bot: O, X, X
      final safeDrawMoves = [
        0, // X: 0
        1, // O: 1
        2, // X: 2
        4, // O: 4
        3, // X: 3
        5, // O: 5
        7, // X: 7
        6, // O: 6
        8, // X: 8
      ];

      for (final move in safeDrawMoves) {
        game.makeMove(move);
      }

      expect(game.status, GameStatus.draw);
      expect(game.winner, Player.none);
      expect(game.isGameOver, isTrue);
      expect(game.winningLine, isNull);
    });

    group('Error Handling', () {
      test('Throws MoveException when cell is already occupied', () {
        game.makeMove(0);
        expect(
          () => game.makeMove(0),
          throwsA(isA<MoveException>().having(
            (e) => e.message,
            'message',
            contains('already occupied'),
          )),
        );
      });

      test('Throws MoveException when index is out of bounds', () {
        expect(() => game.makeMove(-1), throwsA(isA<MoveException>()));
        expect(() => game.makeMove(9), throwsA(isA<MoveException>()));
      });

      test('Throws MoveException when attempting move after game is over', () {
        // X wins quickly
        game.makeMove(0); // X
        game.makeMove(3); // O
        game.makeMove(1); // X
        game.makeMove(4); // O
        game.makeMove(2); // X wins

        expect(game.status, GameStatus.won);
        expect(
          () => game.makeMove(5),
          throwsA(isA<MoveException>().having(
            (e) => e.message,
            'message',
            contains('Game is already over'),
          )),
        );
      });

      test('tryMakeMove safely returns false without throwing', () {
        game.makeMove(0);
        final success = game.tryMakeMove(0);
        expect(success, isFalse);
      });
    });

    group('Random Computer Move', () {
      test('Random move selects only from unoccupied cells', () {
        game.makeMove(0);
        game.makeMove(1);
        game.makeMove(2);

        for (var i = 0; i < 20; i++) {
          final move = game.getRandomMove();
          expect(move, isNotNull);
          expect([0, 1, 2].contains(move), isFalse);
          expect(game.board[move!], Player.none);
        }
      });

      test('Returns null when no moves remain', () {
        // Fill board using valid draw sequence so all 9 cells are filled
        final drawMoves = [0, 1, 2, 4, 3, 5, 7, 6, 8];
        for (final move in drawMoves) {
          game.makeMove(move);
        }
        expect(game.availableMoves.isEmpty, isTrue);
        expect(game.getRandomMove(), isNull);
      });
    });
  });
}
