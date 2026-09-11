import 'package:flutter/material.dart';
import '../models/player.dart';
import '../theme/app_theme.dart';

/// Individual tile in the 3x3 Tic-Tac-Toe grid.
/// Supports smooth pop-in animation and radiant highlighting for winning lines.
class BoardCell extends StatelessWidget {
  final int index;
  final Player player;
  final bool isWinningCell;
  final bool isEnabled;
  final VoidCallback onTap;

  const BoardCell({
    super.key,
    required this.index,
    required this.player,
    required this.isWinningCell,
    required this.isEnabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color? cellBorderColor;
    Color cellBgColor = AppTheme.surface;
    List<BoxShadow>? shadows;

    if (isWinningCell) {
      cellBorderColor = AppTheme.winningGlow;
      cellBgColor = AppTheme.winningGlow.withValues(alpha: 0.18);
      shadows = [
        BoxShadow(
          color: AppTheme.winningGlow.withValues(alpha: 0.35),
          blurRadius: 12,
          spreadRadius: 2,
        ),
      ];
    } else {
      cellBorderColor = AppTheme.border.withValues(alpha: 0.7);
    }

    return AspectRatio(
      aspectRatio: 1.0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: cellBgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: cellBorderColor,
            width: isWinningCell ? 2.5 : 1.2,
          ),
          boxShadow: shadows,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: isEnabled ? onTap : null,
            splashColor: AppTheme.playerXColor.withValues(alpha: 0.2),
            highlightColor: AppTheme.surfaceLight.withValues(alpha: 0.3),
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (child, animation) {
                  return ScaleTransition(
                    scale: CurvedAnimation(
                      parent: animation,
                      curve: Curves.elasticOut,
                    ),
                    child: child,
                  );
                },
                child: _buildSymbol(player),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSymbol(Player player) {
    if (player == Player.none) {
      return const SizedBox.shrink(key: ValueKey('empty'));
    }

    final isX = player == Player.x;
    final color = isWinningCell
        ? AppTheme.winningGlow
        : (isX ? AppTheme.playerXColor : AppTheme.playerOColor);

    return Text(
      player.symbol,
      key: ValueKey('${player.symbol}_$index'),
      style: TextStyle(
        fontSize: 44,
        fontWeight: FontWeight.w900,
        color: color,
        shadows: [
          Shadow(
            color: color.withValues(alpha: 0.5),
            blurRadius: 12,
          ),
        ],
      ),
    );
  }
}
