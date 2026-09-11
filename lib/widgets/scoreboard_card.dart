import 'package:flutter/material.dart';
import '../models/game_mode.dart';
import '../models/player.dart';
import '../theme/app_theme.dart';

/// Renders the score counters for Player X, Ties, and Player O (or Computer).
class ScoreboardCard extends StatelessWidget {
  final int xWins;
  final int oWins;
  final int draws;
  final Player currentPlayer;
  final GameMode gameMode;
  final bool isGameOver;

  const ScoreboardCard({
    super.key,
    required this.xWins,
    required this.oWins,
    required this.draws,
    required this.currentPlayer,
    required this.gameMode,
    required this.isGameOver,
  });

  @override
  Widget build(BuildContext context) {
    final oLabel = gameMode == GameMode.vsComputer ? 'Computer (O)' : 'Player (O)';
    final xLabel = gameMode == GameMode.vsComputer ? 'You (X)' : 'Player (X)';

    return Row(
      children: [
        Expanded(
          child: _buildItem(
            label: xLabel,
            score: xWins,
            color: AppTheme.playerXColor,
            isActive: !isGameOver && currentPlayer == Player.x,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildItem(
            label: 'Ties',
            score: draws,
            color: AppTheme.drawColor,
            isActive: false,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildItem(
            label: oLabel,
            score: oWins,
            color: AppTheme.playerOColor,
            isActive: !isGameOver && currentPlayer == Player.o,
          ),
        ),
      ],
    );
  }

  Widget _buildItem({
    required String label,
    required int score,
    required Color color,
    required bool isActive,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isActive ? color : AppTheme.border.withValues(alpha: 0.5),
          width: isActive ? 2 : 1,
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: color.withValues(alpha: 0.25),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isActive ? color : AppTheme.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '$score',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
