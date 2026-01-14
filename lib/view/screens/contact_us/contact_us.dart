import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../base_widgets/custom_appbar.dart';

class ContactUsScreen extends StatelessWidget {
  ContactUsScreen({super.key});

  final String supportPhone = '+18552439227';
  final String displayPhone = '+(855) 243-9227';
  final String supportEmail = 'support@carcheks.com';

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // ---------------- CALL SUPPORT ----------------
  Future<void> _callSupport(BuildContext context) async {
    final uri = Uri.parse('tel:$supportPhone');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      _showMessage(context, 'Calling is not supported on this device');
    }
  }

  // ---------------- EMAIL SUPPORT ----------------
  Future<void> _emailSupport(BuildContext context) async {
    final uri = Uri(
      scheme: 'mailto',
      path: supportEmail,
      queryParameters: {'subject': 'CarCheks Support'},
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      _showMessage(context, 'Email is not configured on this device');
    }
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBarWidget(context, _scaffoldKey, 'Contact Us'),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "We're here to help!",
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            /// CALL
            ContactTile(
              icon: Icons.phone,
              title: 'Call Us',
              subtitle: displayPhone,
              onTap: () => _callSupport(context),
            ),

            const SizedBox(height: 12),

            /// EMAIL
            ContactTile(
              icon: Icons.email,
              title: 'Email Us',
              subtitle: supportEmail,
              onTap: () => _emailSupport(context),
            ),
          ],
        ),
      ),
    );
  }
}

// --------------------------------------------------
// REUSABLE TILE
// --------------------------------------------------
class ContactTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const ContactTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.cardColor,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, color: Colors.green, size: 28),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(subtitle, style: TextStyle(color: Colors.blue)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
