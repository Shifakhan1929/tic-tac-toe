import 'package:flutter/material.dart';
import '../models/game_mode.dart';
import '../models/game_status.dart';
import '../models/player.dart';
import '../theme/app_theme.dart';

/// Renders a dynamic status banner indicating the current turn,
/// AI thinking state, or final match outcome.
class StatusBanner extends StatelessWidget {
  final GameStatus status;
  final Player currentPlayer;
  final Player winner;
  final GameMode gameMode;
  final bool isComputerThinking;

  const StatusBanner({
    super.key,
    required this.status,
    required this.currentPlayer,
    required this.winner,
    required this.gameMode,
    required this.isComputerThinking,
  });

  @override
  Widget build(BuildContext context) {
    Color bannerColor;
    IconData icon;
    String message;

    if (isComputerThinking) {
      bannerColor = AppTheme.playerOColor;
      icon = Icons.smart_toy_outlined;
      message = 'Computer is thinking...';
    } else if (status == GameStatus.won) {
      bannerColor = AppTheme.winningGlow;
      icon = Icons.emoji_events;
      if (gameMode == GameMode.vsComputer) {
        message = winner == Player.x ? '🎉 Victory! You Won!' : '🤖 Computer Won!';
      } else {
        message = '🏆 Player ${winner.symbol} Wins!';
      }
    } else if (status == GameStatus.draw) {
      bannerColor = AppTheme.drawColor;
      icon = Icons.handshake_outlined;
      message = "It's a Draw!";
    } else {
      // In progress
      if (currentPlayer == Player.x) {
        bannerColor = AppTheme.playerXColor;
        icon = Icons.close;
        message = gameMode == GameMode.vsComputer ? 'Your turn (X)' : "Player X's turn";
      } else {
        bannerColor = AppTheme.playerOColor;
        icon = Icons.circle_outlined;
        message = "Player O's turn";
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: bannerColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: bannerColor.withValues(alpha: 0.6), width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isComputerThinking)
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(bannerColor),
              ),
            )
          else
            Icon(icon, color: bannerColor, size: 20),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              message,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: bannerColor,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
