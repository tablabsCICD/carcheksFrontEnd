import 'package:carcheks/entry_screen.dart';
import 'package:carcheks/locator.dart';
import 'package:carcheks/provider/auth_provider.dart';
import 'package:carcheks/route/app_routes.dart';
import 'package:carcheks/util/app_constants.dart';
import 'package:carcheks/util/color-resource.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../screens/rate_raview/rate_review_screen.dart';

class DrawerWidget extends StatelessWidget {
  DrawerWidget({super.key});

  final AuthProvider authProvider = locator<AuthProvider>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Consumer<AuthProvider>(
          builder: (context, model, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                /// ------------------- TOP SECTION ---------------------
                Column(
                  children: [
                    const SizedBox(height: 20),

                    /// PROFILE IMAGE
                    Center(
                      child: Container(
                        width: 85,
                        height: 85,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[200],
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: (model.user?.imageUrl == null ||
                                model.user!.imageUrl!.isEmpty)
                                ? const AssetImage("assets/images/my_profile.png")
                            as ImageProvider
                                : NetworkImage(model.user!.imageUrl!),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    /// USER NAME
                    Text(
                      model.user?.firstName ?? "Guest User",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 25),

                    /// ---------------- MENU ITEMS ----------------
                    _buildTile(context, Icons.home, "Dashboard", 0),
                    _buildTile(context, Icons.account_circle, "My Profile", 1),
                    _buildTile(context, Icons.car_rental, "My Vehicles", 2),
                    _buildTile(context, Icons.search, "Search", 3),
                    _buildTile(context, Icons.calendar_today, "Appointments", 4),
                    _buildTile(context, Icons.shopping_cart, "My Cart", 5),
                    _buildTile(context, Icons.privacy_tip_outlined, "Privacy Policy", 7),
                    _buildTile(context, Icons.support_agent, "Support / Helpdesk", 21),
                    _buildTile(context, Icons.contact_phone, "Contact Us", 22),
                    _buildTile(context, Icons.star_rate, "Rate Us", 23),
                    _buildTile(context, Icons.info_outline, "About CarCheks", 24),
                  ],
                ),

                /// ------------------- LOGOUT (always visible) ---------------------
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    children: [
                      Divider(color: Colors.grey.shade300),
                      _buildTile(context, Icons.logout, "Logout", 6),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// LOGOUT FUNCTION
  void calllogOut(context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();

    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => EntryScreen()),
            (route) => false,
      );
    }
  }

  /// PRIVACY POLICY
  void callPrivacyPolicy(context) async {
    final Uri url = Uri.parse(
        AppConstants.privacyPolicyUrl);

    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Unable to open Privacy Policy"),
        ),
      );
    }
  }
  /// SINGLE TILE WIDGET
  Widget _buildTile(BuildContext context, IconData icon, String title, int index) {
    return ListTile(
      dense: true,
      leading: Icon(icon, color: Colors.green, size: 22),
      title: Text(title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
      onTap: () {
        switch (index) {
          case 0:
            Navigator.pushNamed(context, AppRoutes.customer_home);
            break;
          case 1:
            Navigator.pushNamed(context, AppRoutes.customer_profile,
                arguments: false);
            break;
          case 2:
            Navigator.pushNamed(context, AppRoutes.vehicle_details);
            break;
          case 3:
            Navigator.pushNamed(context, AppRoutes.search);
            break;
          case 4:
            Navigator.pushNamed(context, AppRoutes.my_appointment);
            break;
          case 5:
            Navigator.pushNamed(context, AppRoutes.cart);
            break;
          case 6:
            calllogOut(context);
            break;
          case 7:
            callPrivacyPolicy(context);
            break;
          case 21:
            Navigator.pushNamed(context, AppRoutes.support_center);
            break;
          case 22:
            Navigator.pushNamed(context, AppRoutes.contact_us);
            break;
          case 23:
            showRateUsSheet(context);
            break;
          case 24:
            Navigator.pushNamed(context, AppRoutes.about_us);
            break;
        }
      },
    );
  }
}
