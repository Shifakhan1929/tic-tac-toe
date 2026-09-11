import 'package:flutter/material.dart';
import '../models/game_mode.dart';
import '../theme/app_theme.dart';

/// A sleek segmented toggle to switch between 2-Player and vs-Computer modes.
class ModeSelector extends StatelessWidget {
  final GameMode selectedMode;
  final ValueChanged<GameMode> onModeChanged;
  final bool isEnabled;

  const ModeSelector({
    super.key,
    required this.selectedMode,
    required this.onModeChanged,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border, width: 1),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          Expanded(
            child: _buildModeOption(
              mode: GameMode.twoPlayers,
              icon: Icons.people_outline,
              label: GameMode.twoPlayers.shortLabel,
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: _buildModeOption(
              mode: GameMode.vsComputer,
              icon: Icons.smart_toy_outlined,
              label: GameMode.vsComputer.shortLabel,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeOption({
    required GameMode mode,
    required IconData icon,
    required String label,
  }) {
    final isSelected = selectedMode == mode;

    return InkWell(
      onTap: isEnabled ? () => onModeChanged(mode) : null,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.surfaceLight : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: AppTheme.playerXColor.withValues(alpha: 0.6), width: 1)
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? AppTheme.playerXColor : AppTheme.textSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? AppTheme.textPrimary : AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
