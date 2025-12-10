import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:developer' as developer;

import '../widgets/document_card.dart';
import 'no_documents_screen.dart';
import 'upload_screen.dart';
import 'profile_screen.dart';
import 'app_settings_screen.dart';
import 'auth/login_screen.dart';
import 'admin_panel.dart';
import '../constants/colors.dart';
import 'archives_screen.dart';
import 'about_us_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isUserLoggedIn = false;

  final TextEditingController _searchController = TextEditingController();
  final ValueNotifier<String> _searchQueryNotifier = ValueNotifier('');

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (mounted) {
        setState(() {
          isUserLoggedIn = user != null;
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchQueryNotifier.dispose();
    super.dispose();
  }


  Future<void> _downloadFile(DocumentSnapshot doc) async {
    final data = doc.data() as Map<String, dynamic>;
    final bool isSensitive = data['isSensitive'] ?? false;
    final String fileURL = data['fileURL'] ?? '';

    if (isSensitive && !isUserLoggedIn) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please log in to download sensitive documents.")));
      return;
    }

    final String correctPasskey = data['passkey'] ?? '';

    if (fileURL.isEmpty) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("⚠️ Download link not found!")));
      return;
    }

    if (isSensitive) {
      final enteredPasskey = await _showPasskeyDialog();
      if (enteredPasskey == correctPasskey) {
        _launchURL(fileURL);
      } else if (enteredPasskey != null) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("❌ Incorrect Passkey!")));
      }
    } else {
      _launchURL(fileURL);
    }
  }

  void _navigateToUpload(BuildContext context) {
    if (isUserLoggedIn) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const UploadScreen()));
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
    }
  }

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("🔓 Logged out successfully")));
    }
  }

  void _handleAdminPanelTap() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && currentUser.email == 'admin@gmail.com') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminPanel()));
    } else {
      _showUnauthorizedAccessDialog();
    }
  }

  void _showUnauthorizedAccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Row(children: [Icon(Icons.lock_person_sharp, color: AppColors.danger), SizedBox(width: 10), Text('Access Denied')]),
          content: const Text("You can't access this screen."),
          actions: <Widget>[TextButton(child: const Text('Back'), onPressed: () => Navigator.of(context).pop())],
        );
      },
    );
  }

  Future<String?> _showPasskeyDialog() {
    final passkeyController = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter Passkey'),
        content: TextField(
          controller: passkeyController,
          keyboardType: TextInputType.number,
          maxLength: 6,
          obscureText: true,
          decoration: const InputDecoration(hintText: '6-digit passkey', counterText: ''),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(context, passkeyController.text), child: const Text('Verify')),
        ],
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("⚠️ Could not open the file: $url")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('projects').where('status', isEqualTo: 'active').orderBy('createdAt').snapshots(),
      builder: (context, projectSnapshot) {
        if (projectSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (projectSnapshot.hasError) {
          return Scaffold(body: Center(child: Padding(padding: const EdgeInsets.all(16.0), child: Text('Error: ${projectSnapshot.error}'))));
        }
        if (!projectSnapshot.hasData || projectSnapshot.data!.docs.isEmpty) {
          return _buildEmptyHomeScreen();
        }
        final projects = projectSnapshot.data!.docs;
        return DefaultTabController(
          length: projects.length,
          child: Scaffold(
            drawer: _buildDrawer(),
            appBar: _buildAppBarWithTabs(projects),
            body: TabBarView(
              children: projects.map((doc) {
                final projectData = doc.data() as Map<String, dynamic>;
                return _buildProjectDocumentList(projectData['name'], projectData['code']);
              }).toList(),
            ),
            floatingActionButton: _buildFloatingActionButton(),
          ),
        );
      },
    );
  }

  Widget _buildEmptyHomeScreen() {
    return Scaffold(
      drawer: _buildDrawer(),
      appBar: AppBar(
        title: const Text('BafnaVault', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: const Center(
        child: Padding(padding: const EdgeInsets.all(24.0), child: Text('No active projects found.\nAdd a project from the Admin Panel.', textAlign: TextAlign.center)),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  AppBar _buildAppBarWithTabs(List<QueryDocumentSnapshot> projects) {
    return AppBar(
      title: const Text('BafnaVault', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      backgroundColor: AppColors.primary,
      iconTheme: const IconThemeData(color: Colors.white),
      centerTitle: true,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(110),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  _searchQueryNotifier.value = value.toLowerCase();
                },
                decoration: InputDecoration(
                  hintText: "Search documents...",
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: (){
                      _searchController.clear();
                      _searchQueryNotifier.value = '';
                    },
                  ),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            SizedBox(
              height: 40,
              child: TabBar(
                isScrollable: true,
                indicatorColor: Colors.white,
                tabs: projects.map((doc) {
                  final projectData = doc.data() as Map<String, dynamic>;
                  return Tab(child: Text(projectData['name']));
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectDocumentList(String projectName, String projectCode) {
    return ValueListenableBuilder<String>(
      valueListenable: _searchQueryNotifier,
      builder: (context, searchQuery, child) {

        Query query = FirebaseFirestore.instance.collection('documents').where('project', isEqualTo: projectCode);
        if (searchQuery.isNotEmpty) {
          query = query
              .where('fileNameLowercase', isGreaterThanOrEqualTo: searchQuery)
              .where('fileNameLowercase', isLessThanOrEqualTo: '$searchQuery\uf8ff');
        } else {
          query = query.orderBy('uploadedAt', descending: true);
        }

        return StreamBuilder<QuerySnapshot>(
          stream: query.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
            if (snapshot.hasError) return Center(child: Text('Please create a Firestore Index. The link is in the Debug Console.'));
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return searchQuery.isNotEmpty
                  ? const Center(child: Text("No documents found for your search."))
                  : NoDocumentsScreen(projectName: projectName);
            }

            final docs = snapshot.data!.docs;

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final doc = docs[index];
                final data = doc.data() as Map<String, dynamic>;
                return DocumentCard(
                  title: data['fileName'] ?? 'No Name',
                  isSensitive: data.containsKey('isSensitive') ? data['isSensitive'] : false,
                  fileSize: data.containsKey('fileSizeKB') ? data['fileSizeKB'] : '0',
                  uploadedAt: data['uploadedAt'],
                  onTap: () => _downloadFile(doc),
                );
              },
            );
          },
        );
      },
    );
  }

  FloatingActionButton _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () => _navigateToUpload(context),
      backgroundColor: AppColors.primary,
      icon: const Icon(Icons.upload_file),
      label: const Text("Upload"),
    );
  }

  Drawer _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: AppColors.primary),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shield_outlined, color: Colors.white, size: 40),
                SizedBox(height: 10),
                Text('BafnaVault', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          if (isUserLoggedIn) ...[
            _drawerTile(Icons.person_outline, 'Profile', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()))),
            _drawerTile(Icons.admin_panel_settings_outlined, 'Admin Panel', _handleAdminPanelTap),
          ],
          _drawerTile(Icons.settings_outlined, 'Settings', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AppSettingsScreen()))),
          const Divider(),
          _drawerTile(Icons.archive_outlined, 'Archives', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ArchivesScreen()))),
          _drawerTile(Icons.info_outline, 'About Us', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutUsScreen()))),
          const Divider(),
          if (isUserLoggedIn)
            ListTile(
              leading: const Icon(Icons.logout, color: AppColors.danger),
              title: const Text('Logout', style: TextStyle(color: AppColors.danger)),
              onTap: () => _logout(context),
            ),
        ],
      ),
    );
  }

  Widget _drawerTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }
}





