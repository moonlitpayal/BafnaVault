import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/colors.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  void _callNumber(BuildContext context, String number) async {
    final uri = Uri(scheme: 'tel', path: number);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        _showSnackBar(context, 'Could not launch $number', AppColors.danger);
      }
    } catch (e) {
      _showSnackBar(context, 'Error launching dialer: $e', AppColors.danger);
    }
  }

  void _sendEmail(BuildContext context, String email) async {
    final uri = Uri(scheme: 'mailto', path: email);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        _showSnackBar(context, 'Could not launch email to $email', AppColors.danger);
      }
    } catch (e) {
      _showSnackBar(context, 'Error launching email client: $e', AppColors.danger);
    }
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
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
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.card), // White icon
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Terms & Conditions',
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
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  _buildSectionCard(
                    context: context,
                    title: 'Welcome to BafnaVault',
                    icon: Icons.info_outline,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        'These Terms & Conditions govern your use of the BafnaVault platform developed for the D. Bafna Group. '
                            'By accessing or using the platform, you agree to be bound by these terms. Please read them carefully.',
                        style: _paragraphStyle,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  _buildSectionCard(
                    context: context,
                    title: '1. Platform Purpose',
                    icon: Icons.business_center_outlined,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        'BafnaVault is an internal, secure document management solution tailored for employees and associates of the D. Bafna Group. '
                            'It allows for uploading, managing, and accessing sensitive project-related files with enhanced control and security.',
                        style: _paragraphStyle,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  _buildSectionCard(
                    context: context,
                    title: '2. Data Confidentiality',
                    icon: Icons.lock_outline,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        'All uploaded documents are strictly confidential. Only authorized users may view or interact with sensitive files. '
                            'Any unauthorized access, copying, or redistribution is strictly prohibited and may result in disciplinary action.',
                        style: _paragraphStyle,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  _buildSectionCard(
                    context: context,
                    title: '3. User Responsibilities',
                    icon: Icons.person_outline,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        'You agree to use the platform solely for intended work purposes. You are responsible for maintaining the confidentiality of your account credentials. '
                            'Any activity conducted under your account will be deemed your responsibility.',
                        style: _paragraphStyle,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),


                  _buildSectionCard(
                    context: context,
                    title: '4. Security & Integrity',
                    icon: Icons.security,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        'Sensitive documents such as contracts, blueprints, and financial data may require additional verification such as a passkey. '
                            'We employ industry-standard encryption and security practices to safeguard your data.',
                        style: _paragraphStyle,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  _buildSectionCard(
                    context: context,
                    title: '5. Modification of Terms',
                    icon: Icons.update,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        'The D. Bafna Group reserves the right to update or modify these terms at any time. Changes will be communicated through in-app updates or internal announcements.',
                        style: _paragraphStyle,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),


                  _buildSectionCard(
                    context: context,
                    title: '6. Contact & Queries',
                    icon: Icons.contact_support_outlined,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        'For any questions, clarifications, or concerns related to these Terms & Conditions, please reach out to us at:',
                        style: _paragraphStyle,
                      ),
                      const SizedBox(height: 12),
                      _buildContactTile(
                        context: context,
                        icon: Icons.email_outlined,
                        label: 'Email',
                        value: 'info@dbafna.com',
                        onTap: () => _sendEmail(context, 'info@dbafna.com'),
                      ),
                      _buildContactTile(
                        context: context,
                        icon: Icons.phone_android,
                        label: 'Phone',
                        value: '+91 98765 43210',
                        onTap: () => _callNumber(context, '+919876543210'),
                      ),
                      _buildContactTile(
                        context: context,
                        icon: Icons.location_on_outlined,
                        label: 'Address',
                        value: 'D. Bafna Group, 001 Block, Ishanya Society, Chinchapada, Pen, Raigad, Maharashtra',
                        onTap: () {
                          _showSnackBar(context, 'Address details', AppColors.primary);
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),
                  Center(
                    child: Text(
                      '© 2025 D. Bafna Group. All rights reserved.',
                      style: TextStyle(color: AppColors.grayText.withOpacity(0.7)),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildSectionCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: AppColors.card,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.primary, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.darkText,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 25, thickness: 1, color: AppColors.bg),
            ...children,
          ],
        ),
      ),
    );
  }
  Widget _buildContactTile({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          children: [
            Icon(icon, color: AppColors.accent, size: 24),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColors.darkText,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.grayText,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 18, color: AppColors.grayText.withOpacity(0.7)),
          ],
        ),
      ),
    );
  }
}

const TextStyle _paragraphStyle = TextStyle(
  fontSize: 14.5,
  height: 1.6,
  color: AppColors.darkText,
);
