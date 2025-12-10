import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF1E88E5);
  static const accent = Color(0xFF3949AB);
  static const bg = Color(0xFFF7F9FC);
  static const card = Colors.white;
  static const darkText = Color(0xFF1C1C1C);
  static const grayText = Color(0xFF757575);
  static const danger = Color(0xFFE53935);
  static const success = Color(0xFF43A047);
}

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Privacy Policy',
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
                child: Center(
                  child: Icon(
                    Icons.security,
                    color: AppColors.card.withOpacity(0.54),
                    size: 80.0,
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
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Your Privacy Matters to BafnaVault',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        'This Privacy Policy describes how your personal information, including sensitive documents, is collected, used, and shared when you use BafnaVault (the "App") for uploading, viewing, and managing documents. We are committed to protecting your privacy and ensuring a secure experience, especially with the use of passkeys for enhanced security.',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.darkText,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 30),

                      _buildPrivacySection(
                        context,
                        title: '1. Information We Collect',
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'When you use the BafnaVault App, we may automatically collect certain information about your device and how you interact with our services. This "Device Information" helps us provide and improve our app.',
                              style: TextStyle(fontSize: 16, color: AppColors.darkText),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'This includes:',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkText),
                            ),
                            const SizedBox(height: 5),
                            _buildBulletPoint('IP address, time zone, and browser type.'),
                            _buildBulletPoint('Information about the pages or features you view and how you interact with the App, such as document viewing patterns.'),
                            _buildBulletPoint('Data collected via technologies like cookies, log files, web beacons, tags, and pixels for analytical purposes.'),
                            const SizedBox(height: 15),
                            Text(
                              'Any information you explicitly provide, such as account details, preferences, uploaded documents and their metadata (e.g., document names, file types), and passkey-related identifiers (which enable secure authentication without storing your actual biometric data or private key on our servers), is also collected to deliver our services.',
                              style: TextStyle(fontSize: 16, color: AppColors.darkText),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),

                      _buildPrivacySection(
                        context,
                        title: '2. How We Use Your Information',
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'We use the collected information for various purposes to enhance your BafnaVault experience:',
                              style: TextStyle(fontSize: 16, color: AppColors.darkText),
                            ),
                            const SizedBox(height: 10),
                            _buildBulletPoint('To provide, operate, and maintain our App and its features, including secure storage and retrieval of your documents.'),
                            _buildBulletPoint('To improve, personalize, and expand our App (e.g., understanding usage patterns for document management features).'),
                            _buildBulletPoint('To understand and analyze how you use our App.'),
                            _buildBulletPoint('To develop new products, services, features, and functionality related to document management and security.'),
                            _buildBulletPoint('To facilitate secure passkey authentication and access control for your sensitive documents.'),
                            _buildBulletPoint('To communicate with you, either directly or through one of our partners, including for customer service, to provide you with updates and other information relating to the App, and for marketing and promotional purposes.'),
                            _buildBulletPoint('To find and prevent fraud and ensure the security and integrity of your documents and account.'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),

                      _buildPrivacySection(
                        context,
                        title: '3. Sharing Your Information',
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'We value your privacy and only share your Personal Information when necessary and with trusted third parties, as described below. Importantly, your uploaded documents are not shared with third parties unless explicitly directed by you through the App\'s features (e.g., sharing a document with another user).',
                              style: TextStyle(fontSize: 16, color: AppColors.darkText),
                            ),
                            const SizedBox(height: 10),
                            _buildBulletPoint('Service Providers: We may share your information with third-party vendors, service providers, contractors, or agents who perform services for us or on our behalf, such as secure cloud storage providers (emphasizing encryption), data analysis, email delivery, customer service, and technical support.'),
                            _buildBulletPoint('Legal Requirements: We may disclose your information, including document-related data, where legally required to do so in order to comply with applicable law, governmental requests, a judicial proceeding, court order, or legal process, such as in response to a court order or a subpoena (including in response to public authorities to meet national security or law enforcement requirements).'),
                            _buildBulletPoint('Business Transfers: We may share or transfer your information in connection with, or during negotiations of, any merger, sale of company assets, financing, or acquisition of all or a portion of our business to another company.'),
                            const SizedBox(height: 10),
                            Text(
                              'For analytics, we use services like Google Analytics. You can learn more about Google\'s privacy practices here: https://www.google.com/intl/en/policies/privacy/. You can also opt-out of Google Analytics here: https://tools.google.com/dlpage/gaoptout.',
                              style: TextStyle(fontSize: 16, color: AppColors.darkText),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),

                      _buildPrivacySection(
                        context,
                        title: '4. Your Data Rights',
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Depending on your location, you may have specific rights regarding your personal data:',
                              style: TextStyle(fontSize: 16, color: AppColors.darkText),
                            ),
                            const SizedBox(height: 10),
                            _buildBulletPoint('Access: The right to request copies of your personal data, including information related to your uploaded documents and account.'),
                            _buildBulletPoint('Rectification: The right to request that we correct any information you believe is inaccurate or complete information you believe is incomplete.'),
                            _buildBulletPoint('Erasure: The right to request that we erase your personal data, including your uploaded documents, under certain conditions.'),
                            _buildBulletPoint('Restrict Processing: The right to request that we restrict the processing of your personal data, under certain conditions.'),
                            _buildBulletPoint('Object to Processing: The right to object to our processing of your personal data, under certain conditions.'),
                            _buildBulletPoint('Data Portability: The right to request that we transfer the data that we have collected to another organization, or directly to you, under certain conditions.'),
                            const SizedBox(height: 10),
                            Text(
                              'To exercise any of these rights, please contact us using the details provided in the "Contact Us" section.',
                              style: TextStyle(fontSize: 16, color: AppColors.darkText),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),

                      _buildPrivacySection(
                        context,
                        title: '5. Data Retention',
                        content: Text(
                          'We retain your Personal Information and uploaded documents for as long as necessary to fulfill the purposes outlined in this Privacy Policy, unless a longer retention period is required or permitted by law. When we have no ongoing legitimate business need to process your Personal Information or documents, we will either delete or anonymize it, or, if this is not possible (for example, because your Personal Information has been stored in backup archives), then we will securely store your Personal Information and isolate it from any further processing until deletion is possible.',
                          style: TextStyle(fontSize: 16, color: AppColors.darkText),
                        ),
                      ),
                      const SizedBox(height: 15),

                      _buildPrivacySection(
                        context,
                        title: '6. Changes to this Policy',
                        content: Text(
                          'We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page. You are advised to review this Privacy Policy periodically for any changes. Changes to this Privacy Policy are effective when they are posted on this page.',
                          style: TextStyle(fontSize: 16, color: AppColors.darkText),
                        ),
                      ),
                      const SizedBox(height: 30),

                      Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                        color: AppColors.card,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.email, color: AppColors.primary, size: 30),
                                  SizedBox(width: 10),
                                  Text(
                                    'Contact Us',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                              Text(
                                'If you have any questions about this Privacy Policy, our practices, or if you would like to make a complaint, please do not hesitate to contact us:',
                                style: TextStyle(fontSize: 16, color: AppColors.darkText),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacySection(BuildContext context, {required String title, required Widget content}) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: AppColors.card,
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        leading: Icon(Icons.info_outline, color: AppColors.accent),
        childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        children: <Widget>[
          content,
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: TextStyle(fontSize: 16, color: AppColors.darkText)),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 16, color: AppColors.darkText),
            ),
          ),
        ],
      ),
    );
  }
}
