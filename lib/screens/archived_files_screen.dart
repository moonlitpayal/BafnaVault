import 'package:bafna_vault/widgets/document_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';
import 'document_preview_screen.dart';

class ArchivedFilesScreen extends StatelessWidget {
  final String projectName;
  final String projectCode;

  const ArchivedFilesScreen({
    super.key,
    required this.projectName,
    required this.projectCode,
  });


  Future<void> _handleDocumentTap(DocumentSnapshot doc, BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DocumentPreviewScreen(
          documentId: doc.id,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(projectName),
        backgroundColor: AppColors.primary,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('documents')
            .where('project', isEqualTo: projectCode)
            .where('status', isEqualTo: 'archived')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No archived documents found for "$projectName".'),
            );
          }

          final documents = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: documents.length,
            itemBuilder: (context, index) {

              final doc = documents[index];
              final data = doc.data() as Map<String, dynamic>;

              return DocumentCard(
                title: data['fileName'] ?? 'No Name',
                isSensitive: data['isSensitive'] ?? false,
                fileSize: data['fileSizeKB'] ?? '0',
                uploadedAt: data['uploadedAt'],
                onTap: () => _handleDocumentTap(doc, context),
              );
            },
          );
        },
      ),
    );
  }
}