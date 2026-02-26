import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const Lab3App());
}

class Lab3App extends StatelessWidget {
  const Lab3App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab3 Travel App',
      theme: AppTheme.lightTheme,
      home: const WelcomeScreen(),
    );
  }
}