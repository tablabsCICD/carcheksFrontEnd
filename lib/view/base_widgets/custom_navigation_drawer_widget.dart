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

import '../../util/sharepreferences.dart';
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
                // --------------------- TOP PURPLE HEADER ---------------------
                Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 25),
                      decoration: const BoxDecoration(
                        color: ColorResources
                            .PRIMARY_COLOR, // 🔥 Purple Header background
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(18),
                          bottomRight: Radius.circular(18),
                        ),
                      ),
                      child: Column(
                        children: [
                          /// PROFILE IMAGE
                          Container(
                            width: 85,
                            height: 85,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white24,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image:
                                    (model.user?.imageUrl == null ||
                                        model.user!.imageUrl!.isEmpty)
                                    ? const AssetImage(
                                            "assets/images/my_profile.png",
                                          )
                                          as ImageProvider
                                    : NetworkImage(model.user!.imageUrl!),
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          /// USER NAME
                          Text(
                            model.user?.firstName ?? "Guest User",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white, // White text on purple
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // --------------------- MENU ITEMS ---------------------
                    _buildTile(context, Icons.home, "Dashboard", 0),
                    _buildTile(context, Icons.account_circle, "My Profile", 1),
                    _buildTile(context, Icons.car_rental, "My Vehicles", 2),
                    _buildTile(context, Icons.search, "Search", 3),
                    _buildTile(
                      context,
                      Icons.calendar_today,
                      "Appointments",
                      4,
                    ),
                    _buildTile(context, Icons.shopping_cart, "My Cart", 5),
                    _buildTile(context, Icons.privacy_tip, "Privacy Policy", 7),
                    _buildTile(
                      context,
                      Icons.support_agent,
                      "Support / Helpdesk",
                      21,
                    ),
                    _buildTile(context, Icons.contact_phone, "Contact Us", 22),
                    _buildTile(context, Icons.star_rate, "Rate Us", 23),
                    _buildTile(
                      context,
                      Icons.info_outline,
                      "About CarCheks",
                      24,
                    ),
                  ],
                ),

                // --------------------- LOGOUT SECTION ---------------------
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

  // -----------------------------------------------------------
  // LOGOUT FUNCTION
  // -----------------------------------------------------------
  Future<void> _confirmLogout(BuildContext context) async {
    final bool? shouldLogout = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            "Confirm Logout",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorResources.PRIMARY_COLOR,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );

    if (shouldLogout == true) {
      calllogOut(context);
    }
  }

  void calllogOut(context) async {
    authProvider.setVisitingFlag(false);
    authProvider.setUserId(0);
    LocalSharePreferences preferences = LocalSharePreferences();
    preferences.logOut();

    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => EntryScreen()),
        (route) => false,
      );
    }
  }

  // -----------------------------------------------------------
  // PRIVACY POLICY
  // -----------------------------------------------------------
  void callPrivacyPolicy(context) async {
    final Uri url = Uri.parse(AppConstants.privacyPolicyUrl);

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Unable to open Privacy Policy")),
      );
    }
  }

  // -----------------------------------------------------------
  // SINGLE TILE BUILDER (Clean + Compact)
  // -----------------------------------------------------------
  Widget _buildTile(
    BuildContext context,
    IconData icon,
    String title,
    int index,
  ) {
    return ListTile(
      dense: true,
      leading: Icon(
        icon,
        color: Colors.green, // 🔥 Green icons
        size: 22,
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
      onTap: () {
        switch (index) {
          case 0:
            Navigator.pushNamed(context, AppRoutes.customer_home);
            break;
          case 1:
            Navigator.pushNamed(
              context,
              AppRoutes.customer_profile,
              arguments: false,
            );
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
            _confirmLogout(context);
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
