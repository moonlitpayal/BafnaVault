import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/colors.dart';

class RecoverPasskeyScreen extends StatefulWidget {
  const RecoverPasskeyScreen({super.key});

  @override
  State<RecoverPasskeyScreen> createState() => _RecoverPasskeyScreenState();
}

class _RecoverPasskeyScreenState extends State<RecoverPasskeyScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _newPasskeyController = TextEditingController();

  List<DocumentSnapshot> _userDocuments = [];
  String? _selectedDocumentId;
  bool _isLoading = true;
  bool _obscureNewPasskey = true;

  @override
  void initState() {
    super.initState();
    _fetchUserDocuments();
  }
  Future<void> _fetchUserDocuments() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      if (mounted) {
        _showSnackBar("Please log in to recover passkeys.", AppColors.danger);
        setState(() => _isLoading = false);
      }
      return;
    }

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('documents')
          .where('uploadedBy', isEqualTo: currentUser.uid)
          .get();
      _userDocuments = querySnapshot.docs.where((doc) {
        final data = doc.data() as Map<String, dynamic>?;
        return data != null &&
            data.containsKey('passkey') &&
            data['passkey'] != null &&
            (data['passkey'] as String).isNotEmpty;
      }).toList();

      if (_userDocuments.isNotEmpty) {
        _selectedDocumentId = _userDocuments.first.id;
      }
    } catch (e) {
      debugPrint('Error fetching user documents: $e');
      if (mounted) {
        _showSnackBar('Failed to load documents. Please try again.', AppColors.danger);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
  Future<void> _handleRecoverPasskey() async {
    if (!_formKey.currentState!.validate()) {
      return; // Stop if validation fails
    }

    if (_selectedDocumentId == null) {
      if (mounted) {
        _showSnackBar("Please select a document.", AppColors.danger);
      }
      return;
    }

    if (!mounted) return;
    setState(() => _isLoading = true);

    try {

      await FirebaseFirestore.instance
          .collection('documents')
          .doc(_selectedDocumentId)
          .update({'passkey': _newPasskeyController.text});

      if (mounted) {
        _showSnackBar("✅ Passkey updated successfully for the selected document!", AppColors.success);
        _newPasskeyController.clear();
      }
    } catch (e) {
      debugPrint('Error updating passkey: $e');
      if (mounted) {
        _showSnackBar("❌ Failed to update passkey. Please try again.", AppColors.danger);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
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
  void dispose() {
    _newPasskeyController.dispose();
    super.dispose();
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
                'Recover Passkey',
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
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Select a document to reset its passkey.',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: AppColors.darkText,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    _isLoading
                        ? Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.accent),
                      ),
                    )
                        : _userDocuments.isEmpty
                        ? Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        'No passkey-protected documents found for your account.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: AppColors.grayText),
                      ),
                    )
                        : DropdownButtonFormField<String>(
                      value: _selectedDocumentId,
                      decoration: InputDecoration(
                        labelText: "Select Document",
                        labelStyle: TextStyle(color: AppColors.grayText),
                        prefixIcon: Icon(Icons.description, color: AppColors.primary),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: AppColors.grayText),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: AppColors.grayText.withOpacity(0.5), width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: AppColors.primary, width: 2),
                        ),
                        filled: true,
                        fillColor: AppColors.card,
                      ),
                      items: _userDocuments.map<DropdownMenuItem<String>>((doc) {
                        return DropdownMenuItem<String>(
                          value: doc.id,
                          child: Text(doc['fileName'] ?? 'Untitled Document'), // Corrected to 'fileName'
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedDocumentId = newValue;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a document.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _newPasskeyController,
                      obscureText: _obscureNewPasskey,
                      style: TextStyle(color: AppColors.darkText),
                      decoration: InputDecoration(
                        labelText: "New Passkey",
                        labelStyle: TextStyle(color: AppColors.grayText),
                        prefixIcon: Icon(Icons.vpn_key, color: AppColors.primary),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureNewPasskey ? Icons.visibility_off : Icons.visibility,
                            color: AppColors.grayText,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureNewPasskey = !_obscureNewPasskey;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: AppColors.grayText),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: AppColors.grayText.withOpacity(0.5), width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: AppColors.primary, width: 2),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: AppColors.danger, width: 2),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: AppColors.danger, width: 2),
                        ),
                        filled: true,
                        fillColor: AppColors.card,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a new passkey.';
                        }
                        if (value.length < 4) {
                          return 'Passkey must be at least 4 characters.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    _isLoading
                        ? Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.accent),
                      ),
                    )
                        : ElevatedButton(
                      onPressed: _handleRecoverPasskey,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: AppColors.card,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 8,
                      ),
                      child: const Text(
                        "Update Document Passkey",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Your new passkey will immediately secure the selected document. Remember this passkey for future access.',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.grayText,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
