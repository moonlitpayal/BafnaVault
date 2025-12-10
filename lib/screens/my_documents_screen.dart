import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/colors.dart';

class MyDocumentsScreen extends StatefulWidget {
  const MyDocumentsScreen({super.key});

  @override
  State<MyDocumentsScreen> createState() => _MyDocumentsScreenState();
}

class _MyDocumentsScreenState extends State<MyDocumentsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: CustomScrollView(
        slivers: <Widget>[
          _buildSliverAppBar(),
          _buildDocumentsList(),
        ],
      ),
    );
  }

  SliverAppBar _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 150.0,
      floating: false,
      pinned: true,
      stretch: true,
      backgroundColor: AppColors.primary,
      iconTheme: const IconThemeData(color: AppColors.card),
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          'My Documents',
          style: TextStyle(
            color: AppColors.card,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.accent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentsList() {
    User? currentUser = _auth.currentUser;

    if (currentUser == null) {
      return const SliverFillRemaining(
        child: Center(child: Text("Please log in to see your documents.")),
      );
    }

    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('documents')
          .where('uploadedBy', isEqualTo: currentUser.uid)
          .orderBy('uploadedAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SliverFillRemaining(
            child: Center(
              child: CircularProgressIndicator(color: AppColors.accent),
            ),
          );
        }

        if (snapshot.hasError) {
          print('FIREBASE ERROR: ${snapshot.error}');
          return const SliverFillRemaining(
            child: Center(child: Text("Something went wrong! Check console.")),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          print('INFO: No documents found for user ${currentUser.uid}');
          return const SliverFillRemaining(
            child: _NoDocumentsView(),
          );
        }

        final documents = snapshot.data!.docs;
        print('INFO: Fetched ${documents.length} documents.');
        return SliverPadding(
          padding: const EdgeInsets.all(16.0),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final doc = documents[index];
                return _buildDocumentCard(doc);
              },
              childCount: documents.length,
            ),
          ),
        );
      },
    );
  }

  Widget _buildDocumentCard(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final String title = data['fileName'] ?? 'Untitled';
    final String fileURL = data['fileURL'] ?? '';
    final Timestamp? timestamp = data['uploadedAt'] as Timestamp?;
    final String date = timestamp != null
        ? '${timestamp.toDate().day}/${timestamp.toDate().month}/${timestamp.toDate().year}'
        : 'N/A';
    final bool isSensitive = data['isSensitive'] ?? false;

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Icon(
          isSensitive ? Icons.lock_outline : Icons.insert_drive_file_outlined,
          color: isSensitive ? AppColors.accent : AppColors.primary,
          size: 32,
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          "Uploaded on $date",
          style: TextStyle(fontSize: 13, color: AppColors.grayText),
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'rename') {
              _showRenameDialog(doc.id, title);
            } else if (value == 'delete') {
              _confirmDeleteDialog(doc.id, title, fileURL);
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: 'rename',
              child: Row(
                children: [
                  Icon(Icons.edit, color: AppColors.primary),
                  SizedBox(width: 8),
                  Text('Rename'),
                ],
              ),
            ),
            const PopupMenuItem<String>(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: AppColors.danger),
                  SizedBox(width: 8),
                  Text('Delete'),
                ],
              ),
            ),
          ],
        ),
        onTap: () => _handleDocumentTap(doc),
      ),
    );
  }


  Future<void> _handleDocumentTap(DocumentSnapshot doc) async {
    final data = doc.data() as Map<String, dynamic>;
    final bool isSensitive = data['isSensitive'] ?? false;
    final String fileURL = data['fileURL'] ?? '';


    final String correctPasskey = data['passkey'] ?? '';

    if (fileURL.isEmpty) {
      _showSnackBar("⚠️ File URL not found!", AppColors.danger);
      return;
    }

    if (isSensitive) {
      final enteredPasskey = await _showPasskeyDialog();
      if (enteredPasskey == correctPasskey) {
        _launchDocumentURL(fileURL);
      } else if (enteredPasskey != null) {
        _showSnackBar("❌ Incorrect Passkey!", AppColors.danger);
      }
    } else {

      _launchDocumentURL(fileURL);
    }
  }

  Future<void> _launchDocumentURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      _showSnackBar("⚠️ Could not open the file.", AppColors.danger);
    }
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



  Future<void> _deleteDocument(String docId, String fileURL) async {
    try {
      if (fileURL.isNotEmpty) {
        await _storage.refFromURL(fileURL).delete();
      }
      await _firestore.collection('documents').doc(docId).delete();
      if (mounted) _showSnackBar("✅ Document deleted successfully!", AppColors.success);
    } catch (e) {
      if (mounted) _showSnackBar("❌ Failed to delete document.", AppColors.danger);
    }
  }

  Future<void> _renameDocument(String docId, String newFileName) async {
    try {
      await _firestore.collection('documents').doc(docId).update({
        'fileName': newFileName,
        'fileNameLowercase': newFileName.toLowerCase(),
      });
      if (mounted) _showSnackBar("✅ Document renamed successfully!", AppColors.success);
    } catch (e) {
      if (mounted) _showSnackBar("❌ Failed to rename document.", AppColors.danger);
    }
  }

  Future<void> _confirmDeleteDialog(String docId, String fileName, String fileURL) async {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete "$fileName"?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () {
              Navigator.of(ctx).pop();
              _deleteDocument(docId, fileURL);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _showRenameDialog(String docId, String currentFileName) async {
    final controller = TextEditingController(text: currentFileName);
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Rename Document'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            decoration: const InputDecoration(hintText: "Enter new file name"),
            validator: (value) {
              if (value == null || value.trim().isEmpty) return 'Name cannot be empty.';
              if (value.trim() == currentFileName) return 'Please enter a new name.';
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          ElevatedButton(
            child: const Text('Rename'),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.of(ctx).pop();
                _renameDocument(docId, controller.text.trim());
              }
            },
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class _NoDocumentsView extends StatelessWidget {
  const _NoDocumentsView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.folder_off_outlined, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 20),
            const Text(
              "No Documents Found",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Your uploaded documents will appear here.",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.grayText),
            ),
          ],
        ),
      ),
    );
  }
}