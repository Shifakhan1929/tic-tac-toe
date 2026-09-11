import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tic_tac_toe/main.dart';
import 'package:tic_tac_toe/widgets/board_cell.dart';

void main() {
  group('TicTacToe Widget Tests', () {
    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
    });

    testWidgets('Renders all primary components on screen', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(const TicTacToeApp());
      await tester.pumpAndSettle();

      // Verify Title
      expect(find.text('TIC-TAC-TOE'), findsOneWidget);

      // Verify Mode Selector
      expect(find.text('2 Players'), findsOneWidget);
      expect(find.text('vs Computer'), findsOneWidget);

      // Verify Scoreboard labels
      expect(find.text('Player (X)'), findsOneWidget);
      expect(find.text('Ties'), findsOneWidget);
      expect(find.text('Player (O)'), findsOneWidget);

      // Verify 9 Board Cells
      expect(find.byType(BoardCell), findsNWidgets(9));

      // Verify Control buttons
      expect(find.text('New Round'), findsOneWidget);
      expect(find.text('Reset Scores'), findsOneWidget);
    });

    testWidgets('Tapping cells places X then O in 2-Player mode', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(const TicTacToeApp());
      await tester.pumpAndSettle();

      // Tap cell 0
      await tester.tap(find.byType(BoardCell).at(0));
      await tester.pumpAndSettle();
      expect(find.text('X'), findsOneWidget);

      // Tap cell 1
      await tester.tap(find.byType(BoardCell).at(1));
      await tester.pumpAndSettle();
      expect(find.text('O'), findsOneWidget);
    });

    testWidgets('Restart round resets the board', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(const TicTacToeApp());
      await tester.pumpAndSettle();

      // Play a move at cell 0
      await tester.tap(find.byType(BoardCell).at(0));
      await tester.pumpAndSettle();
      expect(find.text('X'), findsOneWidget);

      // Tap New Round
      await tester.ensureVisible(find.text('New Round'));
      await tester.tap(find.text('New Round'));
      await tester.pumpAndSettle();

      // Verify board cell marks are cleared
      expect(find.text('X'), findsNothing);
      expect(find.text('O'), findsNothing);
    });

    testWidgets('Switching mode updates scoreboard labels', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(const TicTacToeApp());
      await tester.pumpAndSettle();

      // Tap vs Computer
      await tester.tap(find.text('vs Computer'));
      await tester.pumpAndSettle();

      expect(find.text('You (X)'), findsOneWidget);
      expect(find.text('Computer (O)'), findsOneWidget);
    });

    testWidgets('Computer responds with random move in vs Computer mode', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(const TicTacToeApp());
      await tester.pumpAndSettle();

      // Switch to vs Computer mode
      await tester.tap(find.text('vs Computer'));
      await tester.pumpAndSettle();

      // Player taps cell 0
      await tester.tap(find.byType(BoardCell).at(0));
      await tester.pump(); // Mark X placed

      // Computer is thinking banner
      expect(find.text('Computer is thinking...'), findsOneWidget);

      // Advance clock past the artificial thinking delay (450ms)
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      // Verify O was placed by the computer
      expect(find.text('O'), findsOneWidget);
      expect(find.text('Your turn (X)'), findsOneWidget);
    });
  });
}
