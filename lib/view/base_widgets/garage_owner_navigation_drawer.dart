import 'package:carcheks/entry_screen.dart';
import 'package:carcheks/locator.dart';
import 'package:carcheks/provider/auth_provider.dart';
import 'package:carcheks/provider/garage_provider.dart';
import 'package:carcheks/route/app_routes.dart';
import 'package:carcheks/util/color-resource.dart';
import 'package:carcheks/view/screens/customer/garage/garage_report.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/garage_owner/appointment/all_appointment.dart';
import '../screens/garage_owner/garage_services/all_garage_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class GarageOwnerDrawerWidget extends StatefulWidget {
  const GarageOwnerDrawerWidget({super.key});

  @override
  State<GarageOwnerDrawerWidget> createState() =>
      _GarageOwnerDrawerWidgetState();
}

class _GarageOwnerDrawerWidgetState extends State<GarageOwnerDrawerWidget>
    with TickerProviderStateMixin {
  final AuthProvider authProvider = locator<AuthProvider>();
  final GarageProvider garageProvider = locator<GarageProvider>();

  int activeIndex = 0;

  late final AnimationController _drawerAnimController;
  late final AnimationController _blinkController;
  late final Animation<Offset> _slideAnim;
  Animation<double>? _blinkAnim;


  bool isDarkMode = false;
  String selectedRole = "Garage Owner"; // ROLE SWITCHING

  @override
  void initState() {
    super.initState();

    /// DRAWER SLIDE ANIMATION
    _drawerAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );

    _slideAnim =
        Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _drawerAnimController,
            curve: Curves.easeOutCubic,
          ),
        );

    _drawerAnimController.forward();

    /// BLINKING BADGE ANIMATION
    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(minutes: 1),
    )..repeat(reverse: true);

    _blinkAnim = CurvedAnimation(
      parent: _blinkController,
      curve: Curves.easeInOut,
    );

  }

  @override
  void dispose() {
    _drawerAnimController.dispose();
    _blinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeBg = isDarkMode ? const Color(0xff121212) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;

    return SlideTransition(
      position: _slideAnim,
      child: Drawer(
        backgroundColor: themeBg,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(right: Radius.circular(24)),
        ),
        child: Consumer2<AuthProvider, GarageProvider>(
          builder: (context, authModel, garageModel, child) {
            final int appointmentCount =
            0; // garageModel.unreadAppointmentCount ?? 0;

            return Column(
              children: [
                /// HEADER
                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: ColorResources.PRIMARY_COLOR,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(28),
                      bottomRight: Radius.circular(28),
                    ),
                  ),
                  child: SafeArea(
                    child: Column(
                      children: [
                        /// CLOSE + DARK MODE
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const SizedBox(width: 42),
                            IconButton(
                              icon: const Icon(Icons.close,
                                  color: Colors.white),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          /*  Switch(
                              value: isDarkMode,
                              activeColor: Colors.white,
                              onChanged: (val) =>
                                  setState(() => isDarkMode = val),
                            ),*/
                          ],
                        ),

                        /// PROFILE IMAGE
                        (authModel.user?.imageUrl == null ||
                            authModel.user!.imageUrl!.isEmpty)
                            ? const CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person,
                            size: 44,
                            color: ColorResources.PRIMARY_COLOR,
                          ),
                        )
                            : CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(
                            authModel.user!.imageUrl.toString(),
                          ),
                        ),

                        const SizedBox(height: 12),
                        Text(
                          authProvider.user!.firstName??"",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),

                      /*  /// ROLE SWITCH
                        DropdownButton<String>(
                          value: selectedRole,
                          dropdownColor: Colors.white,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                          underline: const SizedBox.shrink(),
                          iconEnabledColor: Colors.white,
                          items: const [
                            DropdownMenuItem(
                              value: "Garage Owner",
                              child: Text("Garage Owner"),
                            ),
                            DropdownMenuItem(
                              value: "Customer",
                              child: Text("Customer"),
                            ),
                          ],
                          onChanged: (value) {
                            if (value == null) return;
                            setState(() => selectedRole = value);
                            // Close drawer first, then navigate
                            Navigator.of(context).pop();
                            Navigator.pushNamed(
                                context, AppRoutes.garage_home);
                          },
                        ),*/
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                /// MENU
                Expanded(
                  child: ListView(
                    children: [
                      _getTile(0, context, "assets/svg/home.svg", "Home",
                          textColor),
                      _getTile(1, context, "assets/svg/garage.svg", "Garage Info",
                          textColor),
                      _getTile(2, context, "assets/svg/addservice.svg",
                          "Add Services", textColor),
                      _getTile(3, context, "assets/svg/viewservice.svg",
                          "View Services", textColor),
                      _getTile(
                        4,
                        context,
                        "assets/svg/appointmentgarage.svg",
                        "Appointments",
                        textColor,
                        badge: appointmentCount,
                      ),
                      _getTile(5, context, "assets/svg/doller.svg", "My Earning",
                          textColor),
                      const Divider(),
                      _getTile(6, context, "assets/svg/logoutgarage.svg",
                          "Logout", textColor),
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

  /// MENU TILE
  Widget _getTile(
      int index,
      BuildContext context,
      String icon,
      String title,
      Color textColor, {
        int badge = 0,
      }) {
    final isActive = index == activeIndex;

    return InkWell(
        onTap: () {
          setState(() => activeIndex = index);

          if (index == 6) {
            // ✅ For Logout: just show dialog, don't close drawer manually
            _showLogoutDialog(context);
            return;
          }

          // ✅ For other items: close drawer then navigate
          Navigator.of(context).pop();

          Future.microtask(() {
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
                  MaterialPageRoute(
                    builder: (context) => AllAppointment(type: "All"),
                  ),
                );
                break;
              case 5:
                getReport(context);
                break;
            }
          });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isActive
              ? ColorResources.PRIMARY_COLOR.withOpacity(0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              height: 22,
              color:
              isActive ? ColorResources.PRIMARY_COLOR : Colors.grey[700],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isActive
                      ? ColorResources.PRIMARY_COLOR
                      : textColor,
                ),
              ),
            ),

            /// BLINKING BADGE
            if (badge > 0)
              FadeTransition(
                opacity: _blinkAnim ?? const AlwaysStoppedAnimation(1.0),
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    badge.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext parentContext) {
    showDialog(
      context: parentContext,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop(); // just close dialog
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();        // 1️⃣ close dialog
              await Future.delayed(const Duration(
                  milliseconds: 50));                   // 2️⃣ let UI settle
              await callLogout(parentContext);          // 3️⃣ do logout + navigate
            },
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }

  Future<void> callLogout(BuildContext context) async {
    authProvider.setGarageOwnerVisitingFlag(false);
    authProvider.setUserId(0);

    // No mounted check here – we use the context passed from a live widget
    Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
      AppRoutes.login,
          (route) => false,
    );
  }


  /// REPORT
  Future<void> getReport(BuildContext context) async {
    // Guard against empty garage list
    if (garageProvider.ownGarageList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No garage found. Please add a garage first."),
        ),
      );
      return;
    }

    final DateTime currentDate = DateTime.now();
    final DateTime prevMonth =
    DateTime(currentDate.year, currentDate.month - 1, currentDate.day);

    garageProvider.selectedFromDate =
        DateFormat("yyyy-MM-dd").format(prevMonth);
    garageProvider.selectedToDate =
        DateFormat("yyyy-MM-dd").format(currentDate);

    await garageProvider.getGarageReport(
      garageProvider.ownGarageList[0].id,
      garageProvider.selectedFromDate,
      garageProvider.selectedToDate,
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const GarageReport()),
    );
  }
}
