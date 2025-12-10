import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'change_password_screen.dart';
import 'my_documents_screen.dart';
import 'app_settings_screen.dart';
import 'auth/login_screen.dart';
import '../constants/colors.dart';
import 'recover_passkey_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? _currentUser;
  String name = '';
  String email = '';
  String phone = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkUserStatusAndFetchData();
  }
  Future<void> _checkUserStatusAndFetchData() async {
    if (!mounted) return;
    setState(() => isLoading = true);

    _currentUser = FirebaseAuth.instance.currentUser;

    if (_currentUser != null) {
      try {
        final doc = await FirebaseFirestore.instance.collection('users').doc(_currentUser!.uid).get();
        if (mounted && doc.exists) {
          final data = doc.data();
          setState(() {
            name = data?['fullName'] ?? 'N/A';
            email = data?['email'] ?? 'N/A';
            phone = data?['phone'] ?? 'N/A';
          });
        }
      } catch (e) {
        debugPrint('Error fetching user data: $e');
        if (mounted) {
          _showSnackBar('Failed to load profile data.', AppColors.danger);
        }
      }
    }
    if (mounted) {
      setState(() => isLoading = false);
    }
  }
  void logoutUser() async {
    try {
      await FirebaseAuth.instance.signOut();
      if (mounted) {
        _showSnackBar('Successfully logged out!', AppColors.success);
      }
      _checkUserStatusAndFetchData();
    } catch (e) {
      debugPrint('Error during logout: $e');
      if (mounted) {
        _showSnackBar('Failed to log out.', AppColors.danger);
      }
    }
  }
  void _navigateToLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    ).then((_) {
      _checkUserStatusAndFetchData();
    });
  }
  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(15),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 150.0,
            floating: false,
            pinned: true,
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'My Profile',
                style: TextStyle(
                  color: AppColors.card,
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.accent,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              stretchModes: const <StretchMode>[
                StretchMode.zoomBackground,
                StretchMode.blurBackground,
                StretchMode.fadeTitle,
              ],
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: isLoading
                ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.accent),
              ),
            )
                : _currentUser == null
                ? _buildGuestView()
                : _buildUserProfileView(),
          ),
        ],
      ),
    );
  }

  Widget _buildGuestView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.no_accounts_outlined,
              size: 120,
              color: AppColors.grayText.withOpacity(0.6),
            ),
            const SizedBox(height: 25),
            Text(
              'Log in to access your BafnaVault profile and documents.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: AppColors.grayText,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.card,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 8,
              ),
              onPressed: _navigateToLogin,
              icon: const Icon(Icons.login),
              label: const Text(
                'Log in Now',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildUserProfileView() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 30),
          CircleAvatar(
            radius: 60,
            backgroundColor: AppColors.accent,
            child: const Icon(Icons.person, size: 70, color: AppColors.card),
          ),
          const SizedBox(height: 25),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.darkText.withOpacity(0.08),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Personal Information',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.primary),
                ),
                const Divider(height: 25, thickness: 1, color: AppColors.bg),
                buildInfoRow('Name', name),
                buildInfoRow('Email', email),
                buildInfoRow('Phone', phone),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                _buildOptionTile("Reset Password", Icons.lock, () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const ChangePasswordScreen()));
                }),
                // Added the new "Recover Passkey" option here
                _buildOptionTile("Recover Passkey", Icons.vpn_key, () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const RecoverPasskeyScreen()));
                }),
                _buildOptionTile("My Documents", Icons.folder_open, () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const MyDocumentsScreen()));
                }),
                _buildOptionTile("App Settings", Icons.settings, () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const AppSettingsScreen()));
                }),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.danger,
                  foregroundColor: AppColors.card,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 8,
                ),
                onPressed: logoutUser,
                icon: const Icon(Icons.logout, color: AppColors.card),
                label: const Text("Logout",
                    style: TextStyle(color: AppColors.card, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: AppColors.darkText),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.grayText),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildOptionTile(String title, IconData icon, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: AppColors.card,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 28),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: AppColors.darkText),
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 18, color: AppColors.grayText),
            ],
          ),
        ),
      ),
    );
  }
}
