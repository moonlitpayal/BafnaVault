import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/colors.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

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
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Contact Us',
                style: TextStyle(
                  color: AppColors.card, // White text
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary, // Primary blue
                      AppColors.accent,  // Accent indigo
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
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  _buildSectionCard(
                    context: context,
                    title: 'Our Office',
                    icon: Icons.location_on_outlined,
                    children: [
                      Text(
                        'D. Bafna Group\n001, Ishanya Society, Chinchapada \nPen, Raigad, Maharashtra - 402107',
                        style: TextStyle(fontSize: 16, color: AppColors.grayText),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  _buildSectionCard(
                    context: context,
                    title: 'Phone',
                    icon: Icons.phone_outlined,
                    children: [
                      _buildContactTile(
                        context: context,
                        icon: Icons.phone_android,
                        label: 'Mobile',
                        value: '+91 98765 43210',
                        onTap: () => _callNumber(context, '+919876543210'),
                      ),
                      _buildContactTile(
                        context: context,
                        icon: Icons.phone,
                        label: 'Office',
                        value: '022 1234 5678',
                        onTap: () => _callNumber(context, '02212345678'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // 📧 Emails Section
                  _buildSectionCard(
                    context: context,
                    title: 'Email',
                    icon: Icons.email_outlined,
                    children: [
                      _buildContactTile(
                        context: context,
                        icon: Icons.email_outlined,
                        label: 'General',
                        value: 'info@dbafna.com',
                        onTap: () => _sendEmail(context, 'info@dbafna.com'),
                      ),
                      _buildContactTile(
                        context: context,
                        icon: Icons.email,
                        label: 'Support',
                        value: 'support@dbafna.com',
                        onTap: () => _sendEmail(context, 'support@dbafna.com'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
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
      elevation: 6, // Increased elevation for a more prominent look
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // More rounded corners
      ),
      color: AppColors.card, // White card background
      child: Padding(
        padding: const EdgeInsets.all(20), // Increased padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.primary, size: 28), // Primary color for section icon
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkText, // Dark text for titles
                  ),
                ),
              ],
            ),
            const Divider(height: 25, thickness: 1, color: AppColors.bg), // Divider with background color
            ...children, // Spread the children widgets
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
            Icon(Icons.arrow_forward_ios, size: 18, color: AppColors.grayText.withOpacity(0.7)), // Trailing arrow
          ],
        ),
      ),
    );
  }
}
