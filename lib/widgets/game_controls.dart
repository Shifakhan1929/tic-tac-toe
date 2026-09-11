import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Action controls for restarting current match or resetting scores.
class GameControls extends StatelessWidget {
  final VoidCallback onRestartMatch;
  final VoidCallback onResetScore;
  final bool isEnabled;

  const GameControls({
    super.key,
    required this.onRestartMatch,
    required this.onResetScore,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 12,
      runSpacing: 10,
      children: [
        // Restart Round Button
        ElevatedButton.icon(
          onPressed: isEnabled ? onRestartMatch : null,
          icon: const Icon(Icons.refresh, size: 18),
          label: const Text('New Round'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.surfaceLight,
            foregroundColor: AppTheme.textPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        // Reset Scores Button
        OutlinedButton.icon(
          onPressed: isEnabled ? () => _confirmScoreReset(context) : null,
          icon: const Icon(Icons.restore, size: 18),
          label: const Text('Reset Scores'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppTheme.textSecondary,
            side: const BorderSide(color: AppTheme.border),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  void _confirmScoreReset(BuildContext context) {
    showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppTheme.border),
        ),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: AppTheme.playerOColor),
            SizedBox(width: 8),
            Text('Reset Scores?'),
          ],
        ),
        content: const Text(
          'This will reset all wins, losses, and ties to zero. Do you want to continue?',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.playerOColor,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.of(dialogContext).pop(true);
              onResetScore();
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}
