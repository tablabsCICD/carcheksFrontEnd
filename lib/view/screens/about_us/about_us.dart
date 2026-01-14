import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../base_widgets/custom_appbar.dart';

class AboutUsScreen extends StatelessWidget {
  AboutUsScreen({super.key});
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBarWidget(context, _scaffoldKey, "About Us"),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "CarCheks",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            const Text(
              "CarCheks is your trusted car care and servicing platform ensuring "
              "quality, transparency, and convenience. Our mission is to make vehicle "
              "maintenance easy, affordable, and stress-free.",
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 20),
            Row(
              children: const [
                Icon(Icons.location_on, color: Colors.green),
                SizedBox(width: 10),
                Text("Attleboro, MA 02703-3236"),
              ],
            ),

            InkWell(
              onTap: () => _emailSupport,
              child: Row(
                children: const [
                  Icon(Icons.email, color: Colors.green),
                  SizedBox(width: 10),
                  Text(
                    "support@carcheks.com",

                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _emailSupport(BuildContext context) async {
    final uri = Uri(
      scheme: 'mailto',
      path: "support@carcheks.com",
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
}
