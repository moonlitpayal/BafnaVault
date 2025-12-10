import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mime/mime.dart';

import 'package:bafna_vault/screens/home_screen.dart';
import 'package:bafna_vault/constants/colors.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedProjectCode;
  bool _isSensitive = false;
  bool _isLoading = false;
  PlatformFile? _pickedFile;

  final TextEditingController _fileNameController = TextEditingController();
  final TextEditingController _passkeyController = TextEditingController();

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(withData: true);
    if (result != null && result.files.isNotEmpty) {
      setState(() => _pickedFile = result.files.first);
    }
  }

  Future<void> _uploadDocument() async {
    if (!_formKey.currentState!.validate()) return;
    if (_pickedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select a file")));
      return;
    }
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please login to upload.")));
      return;
    }

    if (_pickedFile!.bytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Could not read file data. Try picking the file again.")));
      return;
    }

    setState(() => _isLoading = true);

    final fileName = _fileNameController.text.trim();
    final fileBytes = _pickedFile!.bytes!;
    final pickedName = _pickedFile!.name;
    final sizeKB = (fileBytes.lengthInBytes / 1024).toStringAsFixed(2);
    final timestamp = Timestamp.now();
    final passkey = _passkeyController.text.trim();

    try {
      final String? mimeType = lookupMimeType(pickedName);


      final metadata = SettableMetadata(
        contentType: mimeType,
        contentDisposition: 'attachment; filename="$pickedName"',
      );

      final storagePath = 'documents/$_selectedProjectCode/$fileName';
      final ref = FirebaseStorage.instance.ref().child(storagePath);

      await ref.putData(fileBytes, metadata);
      final String downloadURL = await ref.getDownloadURL();

      await FirebaseFirestore.instance.collection('documents').add({
        'fileName': fileName,
        'fileNameLowercase': fileName.toLowerCase(),
        'filePickedName': pickedName,
        'fileSizeKB': sizeKB,
        'uploadedBy': user.uid,
        'uploadedAt': timestamp,
        'project': _selectedProjectCode,
        'isSensitive': _isSensitive,
        'passkey': _isSensitive ? passkey : '',
        'fileURL': downloadURL,
      });

      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => AlertDialog(
            title: const Text("Upload Successful"),
            content: const Text("Your document has been uploaded."),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomeScreen()), (route) => false);
                },
                child: const Text("OK"),
              )
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = "Upload failed. Please try again.";
        if (e is FirebaseException) {
          errorMessage = "Firebase error: ${e.message ?? e.code}";
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text("Upload Document"),
        backgroundColor: AppColors.primary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("📤 Upload Document", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary)),
                const SizedBox(height: 8),
                const Text("Fill all the required fields before uploading.", style: TextStyle(fontSize: 14, color: Colors.black54)),
                const SizedBox(height: 32),

                const Text("Select Project", style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),

                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('projects')
                      .where('status', isEqualTo: 'active')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    var projectItems = snapshot.data!.docs.map((doc) {
                      final projectData = doc.data() as Map<String, dynamic>;
                      return DropdownMenuItem<String>(
                        value: projectData['code'],
                        child: Text(projectData['name']),
                      );
                    }).toList();

                    return DropdownButtonFormField<String>(
                      value: _selectedProjectCode,
                      items: projectItems,
                      onChanged: (value) {
                        setState(() {
                          _selectedProjectCode = value;
                          if (_fileNameController.text.isEmpty || !_fileNameController.text.contains('_')) {
                            _fileNameController.text = "${value}_";
                          }
                        });
                      },
                      validator: (value) => value == null ? "Please select a project" : null,
                      decoration: InputDecoration(
                        hintText: "Choose project",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 24),
                const Text("Suggested Format", style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                const Text("Format: <PROJECT_CODE>_<DocumentName>_<MonthYear>", style: TextStyle(fontSize: 13, color: Colors.black54, fontStyle: FontStyle.italic)),
                const Text("Example: ORC_Blueprint_Jul2025", style: TextStyle(fontSize: 13, color: Colors.black54, fontStyle: FontStyle.italic)),
                const SizedBox(height: 12),

                const Text("File Name", style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _fileNameController,
                  validator: (value) => value == null || value.isEmpty ? "Enter file name" : null,
                  decoration: InputDecoration(
                    hintText: "Enter document name",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
                const SizedBox(height: 24),

                Row(
                  children: [
                    const Text("Is this document sensitive?", style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(width: 12),
                    Switch(
                      value: _isSensitive,
                      onChanged: (val) => setState(() => _isSensitive = val),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                if (_isSensitive) ...[
                  const Text("Set 6-Digit Passkey", style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _passkeyController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    validator: (value) {
                      if (_isSensitive && (value == null || value.length != 6)) {
                        return 'Passkey must be exactly 6 digits';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "Enter 6-digit passkey",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                      counterText: '',
                    ),
                  ),
                  const SizedBox(height: 12),
                ],

                ElevatedButton.icon(
                  onPressed: _pickFile,
                  icon: const Icon(Icons.attach_file),
                  label: Text(_pickedFile != null ? "File: ${_pickedFile!.name}" : "Choose File"),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 32),

                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton.icon(
                  onPressed: _uploadDocument,
                  icon: const Icon(Icons.cloud_upload_rounded),
                  label: const Text("Upload Document", style: TextStyle(fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor: Colors.green.shade600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

