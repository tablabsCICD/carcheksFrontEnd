import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../base_widgets/custom_appbar.dart';

class ContactUsScreen extends StatelessWidget {
  ContactUsScreen({super.key});

  final String supportPhone = "+(855) 243-9227";
  final String supportEmail = "support@carcheks.com";
  final _scaffoldKey = GlobalKey<ScaffoldState>();
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
            const Text("We're here to help!",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

            const SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.phone, color: Colors.green),
              title: Text("Call Us"),
              subtitle: Text(supportPhone),
              onTap: () async => await launchUrl(Uri.parse("tel:$supportPhone")),
            ),

            ListTile(
              leading: Icon(Icons.email, color: Colors.green),
              title: Text("Email Us"),
              subtitle: Text(supportEmail),
              onTap: () async => await launchUrl(Uri.parse("mailto:$supportEmail")),
            ),

           /* ListTile(
              leading: Icon(Icons.chat, color: Colors.green),
              title: Text("WhatsApp Support"),
              subtitle: Text("Chat instantly"),
              onTap: () async => await launchUrl(
                  Uri.parse("https://wa.me/$supportPhone")),
            ),*/
          ],
        ),
      ),
    );
  }
}
