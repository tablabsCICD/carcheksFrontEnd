import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../base_widgets/custom_appbar.dart';

class ContactUsScreen extends StatelessWidget {
  ContactUsScreen({super.key});

  final String supportPhone = "+18552439227";
  final String supportEmail = "support@carcheks.com";
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _callSupport() async {
    final Uri uri = Uri(scheme: 'tel', path: supportPhone);
    if (!await launchUrl(uri)) {
      throw 'Could not launch phone dialer';
    }
  }

  Future<void> _emailSupport() async {
    final Uri uri = Uri(
      scheme: 'mailto',
      path: supportEmail,
      query: Uri.encodeFull(
        'subject=CarCheks Support&body=Hello Support Team,',
      ),
    );
    if (!await launchUrl(uri)) {
      throw 'Could not open email app';
    }
  }

  Widget _clickableTile({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
    required Color color,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: color,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
         /*   Icon(Icons.arrow_forward_ios,
                size: 16, color: color.withOpacity(0.7)),*/
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBarWidget(context, _scaffoldKey, "Contact Us"),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "We're here to help!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            /// 📞 CALL
            _clickableTile(
              icon: Icons.phone,
              title: "Call Us",
              value: supportPhone,
              color: Colors.green,
              onTap: _callSupport,
            ),

            /// 📧 EMAIL
            _clickableTile(
              icon: Icons.email,
              title: "Email Us",
              value: supportEmail,
              color: Colors.green,
              onTap: _emailSupport,
            ),
          ],
        ),
      ),
    );
  }
}
