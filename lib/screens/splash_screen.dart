import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/docs.json',
              height: 220,
              width: 220,
              fit: BoxFit.contain,
            ),

            const SizedBox(height: 36),
            const Text(
              'BafnaVault',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E88E5),
                letterSpacing: 2,
              ),
            ),

            const SizedBox(height: 12),

            // 📝 Tagline
            const Text(
              'Your Secure Digital Locker',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF757575),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
