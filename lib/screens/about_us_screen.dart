import 'package:flutter/material.dart';
import '../constants/colors.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('About Us', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Icon(
                Icons.business,
                size: 80,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('About Dbafna Group'),
            const SizedBox(height: 10),
            _buildContentText(
                'Dbafna Group stands as a paragon of excellence and innovation in the real estate sector. With an unwavering commitment to quality, integrity, and architectural brilliance, the group has consistently delivered landmark projects that redefine modern living and workspaces.'
            ),
            const SizedBox(height: 30),
            _buildSectionTitle('Visionary Leadership'),
            const SizedBox(height: 10),
            // --- MODIFIED SECTION ---
            _buildContentText(
                'Under the visionary and dynamic leadership of Mr. Daeshan Bafna, the group has achieved remarkable milestones. His forward-thinking approach and relentless pursuit of perfection inspire the entire team to strive for greatness and set new benchmarks in the industry.'
            ),
            const SizedBox(height: 15),
            _buildContentText(
                'It was with this inspiring vision that Payal Mehta was granted the esteemed opportunity to develop the BafnaVault application. This platform stands as a testament to the group\'s trust in dedicated talent and has been crafted with immense gratitude.'
            ),
            const SizedBox(height: 30),
            _buildSectionTitle('About BafnaVault'),
            const SizedBox(height: 10),
            _buildContentText(
                'This application has been exclusively developed to support the esteemed team at Dbafna Group. It serves as a centralized and secure platform to streamline project documentation, enhance collaboration, and empower the team with instant access to critical information.'
            ),
            const SizedBox(height: 30),
            const Divider(thickness: 1),
            const SizedBox(height: 20),
            _buildSectionTitle('Licenses'),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.description_outlined, color: AppColors.primary),
              title: const Text('Open Source Licenses'),
              subtitle: const Text('View the licenses of software used in this app.'),
              onTap: () {
                showLicensePage(
                  context: context,
                  applicationName: 'BafnaVault',
                  applicationVersion: '1.0.0',
                );
              },
            ),
            const SizedBox(height: 40),
            Center(
              child: Text(
                'Building the Future, Together.',
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: AppColors.grayText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: AppColors.darkText,
      ),
    );
  }

  Widget _buildContentText(String text) {
    return Text(
      text,
      textAlign: TextAlign.justify,
      style: const TextStyle(
        fontSize: 16,
        height: 1.5, // Line spacing
        color: AppColors.grayText,
      ),
    );
  }
}