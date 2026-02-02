import 'package:flutter/material.dart';
import 'package:echo/config/theme.dart';
import 'package:echo/screens/login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  final VoidCallback? onThemeToggle;
  
  const WelcomeScreen({super.key, this.onThemeToggle});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          // Theme Toggle Switch
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                Icon(
                  Icons.wb_sunny,
                  color: isDarkMode ? Colors.grey : AppTheme.primaryBlue,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Switch(
                  value: isDarkMode,
                  onChanged: (value) {
                    if (onThemeToggle != null) {
                      onThemeToggle!();
                    }
                  },
                  activeColor: AppTheme.primaryBlue,
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.nightlight_round,
                  color: isDarkMode ? AppTheme.primaryBlue : Colors.grey,
                  size: 20,
                ),
              ],
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Centered Logo
            Icon(
              Icons.flutter_dash,
              size: 120,
              color: AppTheme.primaryBlue,
            ),
            const SizedBox(height: 40),
            
            // Get Started Button
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 48,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Get Started',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
