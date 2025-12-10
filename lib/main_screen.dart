import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'screens/home_screen.dart';
import 'screens/upload_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/auth/login_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  bool _isUserLoggedIn = false;

  final List<Widget> _screens = [
    const HomeScreen(),
    const UploadScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (mounted) {
        setState(() {
          _isUserLoggedIn = user != null;
          if (!_isUserLoggedIn && _currentIndex != 0) {
            _currentIndex = 0;
          }
        });
      }
    });
    _checkInitialLoginStatus();
  }

  void _checkInitialLoginStatus() {
    final user = FirebaseAuth.instance.currentUser;
    setState(() {
      _isUserLoggedIn = user != null;
    });
  }

  void _handleNavigation(int index) {
    if (index == 1) {
      if (!_isUserLoggedIn) {

        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      } else {
        setState(() {
          _currentIndex = index;
        });
      }
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.reactCircle,
        backgroundColor: const Color(0xFF1E88E5),
        activeColor: Colors.white,
        color: Colors.white70,
        curveSize: 80,
        elevation: 10,
        items: const [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.upload_file, title: 'Upload'),
          TabItem(icon: Icons.person, title: 'Profile'),
        ],
        initialActiveIndex: _currentIndex,
        onTap: _handleNavigation,
      ),
    );
  }
}
