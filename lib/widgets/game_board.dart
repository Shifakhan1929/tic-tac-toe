import 'package:flutter/material.dart';
import '../models/player.dart';
import 'board_cell.dart';

/// Renders the 3x3 grid for Tic-Tac-Toe.
/// Constrained to maintain a sleek, centered square on any screen width.
class GameBoard extends StatelessWidget {
  final List<Player> board;
  final List<int>? winningLine;
  final bool isInteractive;
  final ValueChanged<int> onCellTapped;

  const GameBoard({
    super.key,
    required this.board,
    required this.winningLine,
    required this.isInteractive,
    required this.onCellTapped,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 380, maxHeight: 380),
      child: AspectRatio(
        aspectRatio: 1.0,
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(8),
          itemCount: 9,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            final isWinning = winningLine?.contains(index) ?? false;
            final isCellEmpty = board[index] == Player.none;

            return BoardCell(
              index: index,
              player: board[index],
              isWinningCell: isWinning,
              isEnabled: isInteractive && isCellEmpty,
              onTap: () => onCellTapped(index),
            );
          },
        ),
      ),
    );
  }
}
