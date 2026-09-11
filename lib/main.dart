import 'package:flutter/material.dart';
import 'screens/game_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const TicTacToeApp());
}

/// Root widget of the application.
class TicTacToeApp extends StatelessWidget {
  const TicTacToeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic-Tac-Toe',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const GameScreen(),
    );
  }
}
