import 'package:flutter/material.dart';
import 'contact_us_screen.dart';
import 'terms_and_conditions_screen.dart';
import 'privacy_policy_screen.dart';

class AppSettingsScreen extends StatefulWidget {
  const AppSettingsScreen({super.key});

  @override
  State<AppSettingsScreen> createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends State<AppSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              title: 'Feedback',
              children: [
                _buildOptionTile(
                  icon: Icons.star_outline,
                  iconBgColor: Colors.amber.shade400,
                  title: 'Rate Our App',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Rating feature coming soon!")),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 30),


            _buildSection(
              title: 'Support & Legal',
              children: [
                _buildOptionTile(
                  icon: Icons.support_agent_outlined,
                  iconBgColor: Colors.green.shade400,
                  title: 'Contact Us',
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const ContactUsScreen()));
                  },
                ),
                _buildDivider(),
                _buildOptionTile(
                  icon: Icons.gavel_outlined,
                  iconBgColor: Colors.red.shade400,
                  title: 'Terms & Conditions',
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const TermsConditionsScreen()));
                  },
                ),
                _buildDivider(),
                _buildOptionTile(
                  icon: Icons.privacy_tip_outlined,
                  iconBgColor: Colors.blue.shade400,
                  title: 'Privacy Policy',
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()));
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
          child: Text(
            title.toUpperCase(),
            style: TextStyle(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.bold,
              fontSize: 14,
              letterSpacing: 1.1,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required Color iconBgColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: CircleAvatar(
        radius: 22,
        backgroundColor: iconBgColor.withOpacity(0.1),
        child: Icon(icon, color: iconBgColor, size: 22),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400),
    );
  }

  // Custom divider
  Widget _buildDivider() => Padding(
    padding: const EdgeInsets.only(left: 70), // Aligns with title
    child: Divider(height: 1, color: Colors.grey.shade200),
  );
}