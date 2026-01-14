import 'package:carcheks/locator.dart';
import 'package:carcheks/provider/auth_provider.dart';
import 'package:carcheks/provider/garage_provider.dart';
import 'package:carcheks/route/app_routes.dart';
import 'package:carcheks/util/app_constants.dart';
import 'package:carcheks/util/color-resource.dart';
import 'package:carcheks/view/screens/customer/garage/garage_report.dart';
import 'package:carcheks/view/screens/rate_raview/rate_review_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../util/sharepreferences.dart';
import '../screens/garage_owner/appointment/all_appointment.dart';
import '../screens/garage_owner/garage_services/all_garage_services.dart';

class GarageOwnerDrawerWidget extends StatelessWidget {
  GarageOwnerDrawerWidget({super.key});

  final AuthProvider authProvider = locator<AuthProvider>();
  final GarageProvider garageProvider = locator<GarageProvider>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Consumer2<AuthProvider, GarageProvider>(
          builder: (context, auth, garage, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // ---------------------- HEADER ---------------------
                Column(
                  children: [
                    // PURPLE HEADER
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 25),
                      decoration: const BoxDecoration(
                        color: ColorResources
                            .PRIMARY_COLOR, // 🔥 Purple background kept
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
                                    (auth.user?.imageUrl == null ||
                                        auth.user!.imageUrl!.isEmpty)
                                    ? const AssetImage(
                                            "assets/images/my_profile.png",
                                          )
                                          as ImageProvider
                                    : NetworkImage(auth.user!.imageUrl!),
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          /// USER NAME
                          Text(
                            auth.user?.firstName ?? "",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white, // Text white on purple
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ---------------------- MENU ----------------------
                    _tile(context, Icons.home, "Home", 0),
                    _tile(context, Icons.info_outline, "Business Info", 1),
                    _tile(context, Icons.add_circle_outline, "Add Services", 2),
                    _tile(context, Icons.design_services, "View Services", 3),
                    _tile(context, Icons.calendar_month, "Appointments", 4),
                    _tile(context, Icons.monetization_on, "My Earnings", 5),
                    _tile(context, Icons.privacy_tip, "Privacy Policy", 7),
                    _tile(
                      context,
                      Icons.support_agent,
                      "Support / Helpdesk",
                      21,
                    ),
                    _tile(context, Icons.call, "Contact Us", 22),
                    _tile(context, Icons.star_rate, "Rate Us", 23),
                    _tile(context, Icons.info, "About Carcheks", 24),
                  ],
                ),

                // ---------------------- LOGOUT ----------------------
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    children: [
                      Divider(color: Colors.grey.shade300),
                      _tile(context, Icons.logout, "Logout", 6),
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
  //                TILE BUILDER
  // -----------------------------------------------------------
  Widget _tile(BuildContext context, IconData icon, String title, int index) {
    return ListTile(
      dense: true,

      /// ICON COLOR SET TO GREEN
      leading: Icon(
        icon,
        color: Colors.green, // 🔥 Changed icon color to green
        size: 22,
      ),

      title: Text(
        title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
      onTap: () => _handleNavigation(context, index),
    );
  }

  // -----------------------------------------------------------
  //                     NAVIGATION HANDLER
  // -----------------------------------------------------------
  void _handleNavigation(BuildContext context, int index) {
    Navigator.pop(context);

    switch (index) {
      case 0:
        Navigator.pushNamed(context, AppRoutes.garage_home);
        break;
      case 1:
        Navigator.pushNamed(context, AppRoutes.garage_info);
        break;
      case 2:
        Navigator.pushNamed(context, AppRoutes.choose_service);
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GetAllGarageSer()),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AllAppointment(type: "All")),
        );
        break;
      case 5:
        _openGarageReport(context);
        break;
      case 6:
        _logout(context);
        break;
      case 7:
        _openPrivacyPolicy(context);
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
  }

  // -----------------------------------------------------------
  // LOGOUT FUNCTION
  // -----------------------------------------------------------
  Future<void> _logout(BuildContext context) async {
    authProvider.setGarageOwnerVisitingFlag(false);
    authProvider.setUserId(0);
    LocalSharePreferences preferences = LocalSharePreferences();
    preferences.logOut();

    Navigator.of(
      context,
      rootNavigator: true,
    ).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
  }

  // -----------------------------------------------------------
  // PRIVACY POLICY
  // -----------------------------------------------------------
  void _openPrivacyPolicy(context) async {
    final Uri url = Uri.parse(AppConstants.privacyPolicyUrl);

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Unable to open Privacy Policy")),
      );
    }
  }

  // -----------------------------------------------------------
  // REPORT
  // -----------------------------------------------------------
  Future<void> _openGarageReport(BuildContext context) async {
    if (garageProvider.ownGarageList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No garage found. Please add a garage first."),
        ),
      );
      return;
    }

    final now = DateTime.now();
    final prevMonth = DateTime(now.year, now.month - 1, now.day);

    garageProvider.selectedFromDate = DateFormat(
      "yyyy-MM-dd",
    ).format(prevMonth);
    garageProvider.selectedToDate = DateFormat("yyyy-MM-dd").format(now);

    await garageProvider.getGarageReport(
      garageProvider.ownGarageList[0].id,
      garageProvider.selectedFromDate,
      garageProvider.selectedToDate,
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GarageReport()),
    );
  }
}
