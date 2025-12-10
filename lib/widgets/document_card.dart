import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../constants/colors.dart';

class DocumentCard extends StatelessWidget {
  final String title;
  final bool isSensitive;
  final String fileSize;
  final Timestamp? uploadedAt;
  final VoidCallback onTap;

  const DocumentCard({
    super.key,
    required this.title,
    required this.isSensitive,
    required this.fileSize,
    required this.uploadedAt,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final date = uploadedAt?.toDate();
    final formattedDate = date != null
        ? '${date.day}/${date.month}/${date.year}'
        : 'N/A';

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Icon(
          isSensitive ? Icons.lock_outline : Icons.insert_drive_file_outlined,
          color: isSensitive ? AppColors.accent : AppColors.primary,
          size: 40,
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          "$fileSize KB • $formattedDate",
          style: TextStyle(fontSize: 13, color: AppColors.grayText),
        ),
        onTap: onTap,
      ),
    );
  }
}