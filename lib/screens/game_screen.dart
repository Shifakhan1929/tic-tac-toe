import 'package:flutter/material.dart';
import '../logic/tic_tac_toe_game.dart';
import '../models/game_mode.dart';
import '../models/game_status.dart';
import '../models/player.dart';
import '../theme/app_theme.dart';
import '../widgets/game_controls.dart';
import '../widgets/game_board.dart';
import '../widgets/mode_selector.dart';
import '../widgets/scoreboard_card.dart';
import '../widgets/status_banner.dart';

/// The primary screen hosting the Tic-Tac-Toe match,
/// score tracking, mode switching, and computer move orchestration.
class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late TicTacToeGame _game;
  GameMode _gameMode = GameMode.twoPlayers;

  // Score counters
  int _xWins = 0;
  int _oWins = 0;
  int _draws = 0;

  // AI thinking state lock
  bool _isComputerThinking = false;

  @override
  void initState() {
    super.initState();
    _game = TicTacToeGame();
  }

  /// Handles human player tapping on a cell.
  void _handleCellTap(int index) {
    if (_isComputerThinking || _game.isGameOver) return;

    try {
      final success = _game.tryMakeMove(index);
      if (!success) return;

      _processGameOutcome();

      // If playing against computer and game is still in progress,
      // trigger the computer's turn.
      if (!_game.isGameOver &&
          _gameMode == GameMode.vsComputer &&
          _game.currentPlayer == Player.o) {
        _triggerComputerMove();
      }
    } catch (e) {
      _showErrorNotice('An unexpected move error occurred: $e');
    }
  }

  /// Orchestrates the computer's turn with a natural delay and random move.
  Future<void> _triggerComputerMove() async {
    setState(() {
      _isComputerThinking = true;
    });

    // Realistic thinking pause so the move doesn't feel abrupt
    await Future.delayed(const Duration(milliseconds: 450));

    if (!mounted) return;

    try {
      final computerMove = _game.getRandomMove();
      if (computerMove != null) {
        _game.makeMove(computerMove);
        _processGameOutcome();
      }
    } catch (e) {
      _showErrorNotice('Computer move error: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isComputerThinking = false;
        });
      }
    }
  }

  /// Evaluates win or draw after any move and updates scoreboard counters.
  void _processGameOutcome() {
    setState(() {
      if (_game.status == GameStatus.won) {
        if (_game.winner == Player.x) {
          _xWins++;
        } else if (_game.winner == Player.o) {
          _oWins++;
        }
      } else if (_game.status == GameStatus.draw) {
        _draws++;
      }
    });
  }

  /// Resets the 3x3 board for a fresh round while preserving scores.
  void _restartMatch() {
    if (_isComputerThinking) return;

    setState(() {
      _game.reset(startingPlayer: Player.x);
    });
  }

  /// Switches between 2-Player mode and vs-Computer mode.
  void _handleModeChange(GameMode newMode) {
    if (_isComputerThinking || _gameMode == newMode) return;

    setState(() {
      _gameMode = newMode;
      _game.reset(startingPlayer: Player.x);
      // Reset scores when switching game modes for a clean slate
      _xWins = 0;
      _oWins = 0;
      _draws = 0;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Switched to ${newMode.title}'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Resets all accumulated scores to zero.
  void _resetScores() {
    if (_isComputerThinking) return;

    setState(() {
      _xWins = 0;
      _oWins = 0;
      _draws = 0;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Scores have been reset to 0.'),
        duration: Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Shows an informative bottom notice if an exception occurs.
  void _showErrorNotice(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Opens an informative dialog explaining the game and AI rules.
  void _showAboutDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppTheme.border),
        ),
        title: const Row(
          children: [
            Icon(Icons.info_outline, color: AppTheme.playerXColor),
            SizedBox(width: 8),
            Text('About Tic-Tac-Toe'),
          ],
        ),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Game Modes:',
                style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
              ),
              SizedBox(height: 4),
              Text(
                '• 2 Players: Pass and play with a friend on the same device.\n'
                '• vs Computer: Play against an AI making random moves.',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
              ),
              SizedBox(height: 12),
              Text(
                'Rules:',
                style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
              ),
              SizedBox(height: 4),
              Text(
                '• Match 3 of your marks in a horizontal, vertical, or diagonal line to win.\n'
                '• If all 9 cells are filled with no line formed, the round is a draw.',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isInteractive = !_game.isGameOver && !_isComputerThinking;

    return Scaffold(
      appBar: AppBar(
        title: const Text('TIC-TAC-TOE'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'About & Rules',
            onPressed: _showAboutDialog,
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Mode Selector Toggle
                  ModeSelector(
                    selectedMode: _gameMode,
                    onModeChanged: _handleModeChange,
                    isEnabled: !_isComputerThinking,
                  ),
                  const SizedBox(height: 16),

                  // Scoreboard
                  ScoreboardCard(
                    xWins: _xWins,
                    oWins: _oWins,
                    draws: _draws,
                    currentPlayer: _game.currentPlayer,
                    gameMode: _gameMode,
                    isGameOver: _game.isGameOver,
                  ),
                  const SizedBox(height: 16),

                  // Status / Turn Banner
                  StatusBanner(
                    status: _game.status,
                    currentPlayer: _game.currentPlayer,
                    winner: _game.winner,
                    gameMode: _gameMode,
                    isComputerThinking: _isComputerThinking,
                  ),
                  const SizedBox(height: 20),

                  // 3x3 Game Board
                  GameBoard(
                    board: _game.board,
                    winningLine: _game.winningLine,
                    isInteractive: isInteractive,
                    onCellTapped: _handleCellTap,
                  ),
                  const SizedBox(height: 20),

                  // Action Controls
                  GameControls(
                    onRestartMatch: _restartMatch,
                    onResetScore: _resetScores,
                    isEnabled: !_isComputerThinking,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
