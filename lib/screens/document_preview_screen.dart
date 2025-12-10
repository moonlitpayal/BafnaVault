import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/colors.dart';

class DocumentPreviewScreen extends StatefulWidget {
  // It now takes the documentId instead of title and isSensitive
  final String documentId;

  const DocumentPreviewScreen({
    super.key,
    required this.documentId,
  });

  @override
  State<DocumentPreviewScreen> createState() => _DocumentPreviewScreenState();
}

class _DocumentPreviewScreenState extends State<DocumentPreviewScreen> {
  // New state variables for all the data
  String title = 'Loading...';
  bool isSensitive = false;
  String uploaderName = 'Loading...';
  String uploadedAt = 'Loading...';
  String fileSize = 'Loading...';
  String fileURL = '';
  String fileType = 'other';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMetadata();
  }


  Future<void> _fetchMetadata() async {
    try {

      final docSnapshot = await FirebaseFirestore.instance
          .collection('documents')
          .doc(widget.documentId)
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data()!;
        final uploaderUID = data['uploadedBy'] ?? '';
        final pickedName = (data['filePickedName'] as String?)?.toLowerCase() ?? '';


        if (uploaderUID.isNotEmpty) {
          final userDoc = await FirebaseFirestore.instance.collection('users').doc(uploaderUID).get();
          if (userDoc.exists) {
            uploaderName = userDoc.data()?['fullName'] ?? 'Unknown User';
          }
        } else {
          uploaderName = 'Unknown User';
        }


        if (pickedName.endsWith('.jpg') || pickedName.endsWith('.jpeg') || pickedName.endsWith('.png')) {
          fileType = 'image';
        }

        setState(() {
          title = data['fileName'] ?? 'No Name';
          isSensitive = data['isSensitive'] ?? false;
          uploadedAt = (data['uploadedAt'] as Timestamp?)?.toDate().toString().split('.')[0] ?? 'Unknown';
          fileSize = "${data['fileSizeKB'] ?? '?'} KB";
          fileURL = data['fileURL'] ?? '';
          isLoading = false;
        });
      } else {
        _handleNotFound();
      }
    } catch (e) {
      _handleNotFound();
    }
  }

  void _handleNotFound() {
    setState(() {
      uploaderName = 'Not found';
      title = 'Document Not Found';
      isLoading = false;
    });
  }

  Future<void> _downloadOrOpenFile() async {
    if (fileURL.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("File URL not available")));
      return;
    }
    try {
      final uri = Uri.parse(fileURL);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw "Could not launch $fileURL";
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("⚠️ Failed to open file: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Document Details'),
        backgroundColor: AppColors.primary,
      ),
      backgroundColor: AppColors.bg,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.darkText,
              ),
            ),
            const SizedBox(height: 15),

            if (isSensitive)
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '🔒 Sensitive Document',
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

            const SizedBox(height: 30),

            Expanded(
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                clipBehavior: Clip.antiAlias,
                child: _buildPreviewWidget(),
              ),
            ),

            const SizedBox(height: 30),

            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildInfoRow(Icons.person_outline, "Uploaded by", uploaderName),
                    const Divider(height: 20),
                    _buildInfoRow(Icons.access_time_rounded, "Uploaded on", uploadedAt),
                    const Divider(height: 20),
                    _buildInfoRow(Icons.sd_storage_outlined, "File Size", fileSize),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: _downloadOrOpenFile,
              icon: const Icon(Icons.download_rounded),
              label: const Text("Download / Open"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewWidget() {
    if (fileType == 'image' && fileURL.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: fileURL,
        fit: BoxFit.contain,
        placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.red, size: 80),
      );
    } else {
      return Center(
        child: Icon(
          Icons.insert_drive_file_rounded,
          size: 120,
          color: isSensitive ? Colors.red.shade300 : Colors.grey.shade400,
        ),
      );
    }
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.grayText),
        const SizedBox(width: 12),
        Text("$label:", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const Spacer(),
        Flexible(child: Text(value, style: const TextStyle(fontSize: 16, color: AppColors.grayText))),
      ],
    );
  }
}