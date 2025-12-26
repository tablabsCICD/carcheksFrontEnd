import 'dart:async';
import 'dart:convert';
import 'package:carcheks/provider/address_provider.dart';
import 'package:carcheks/provider/auth_provider.dart';
import 'package:carcheks/provider/fuel_provider.dart';
import 'package:carcheks/provider/garage_provider.dart';
import 'package:carcheks/provider/img_provider.dart';
import 'package:carcheks/provider/vehicle_provider.dart';
import 'package:carcheks/route/app_routes.dart';
import 'package:carcheks/util/api_constants.dart';
import 'package:carcheks/util/app_constants.dart';
import 'package:carcheks/util/sharepreferences.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'locator.dart';
import 'model/user_table_model.dart';
import 'model/version.dart';

class EntryScreen extends StatefulWidget {
  @override
  EntryState createState() => EntryState();
}

class EntryState extends State<EntryScreen> with WidgetsBindingObserver {
  final authProvider = locator<AuthProvider>();
  final addressProvider = locator<AddressProvider>();
  final garageProvider = locator<GarageProvider>();

  FuelProvider fuelTypeProvider = locator<FuelProvider>();
  VehicleProvider vehicleProvider = locator<VehicleProvider>();
  ImgProvider imgProvider = locator<ImgProvider>();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initFlow();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkPermission(); // Re-check when returning from settings
    }
  }

  /// MAIN FLOW → Check Permission → Get Location → Navigate
  Future<void> _initFlow() async {
    await _checkPermission();
  }

  // ------------------------------------------------------------
  // ⿡ CHECK LOCATION PERMISSION
  // ------------------------------------------------------------
  Future<void> _checkPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return _showForcedPopup();
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return _showForcedPopup(); // user denied → show important dialog
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return _showForcedPopup();
    }

    // Permission Granted
    await _getLocation();
  }

  // ------------------------------------------------------------
  // ⿢ GET CURRENT LOCATION
  // ------------------------------------------------------------
  Future<void> _getLocation() async {
    try {
      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      AppConstants.CurrentLatitude = pos.latitude;
      AppConstants.CurrentLongtitude = pos.longitude;

      List<Placemark> placemarks = await placemarkFromCoordinates(
        pos.latitude,
        pos.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        AppConstants.AddressCon =
            '${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}';
      }
    } catch (e) {
      // If unable to fetch location even after permission
      debugPrint("Location error: $e");
    }

    fetchVersionAndNavigate();
  }

  // ------------------------------------------------------------
  // ⿣ NAVIGATION LOGIC
  // ------------------------------------------------------------
  Future<void> _goNext() async {
    LocalSharePreferences prefs = LocalSharePreferences();
    bool isLoggedIn = false;
    isLoggedIn = await prefs.getBool(AppConstants.isUserLoggedIn);

    if (!mounted) return;
    if (isLoggedIn) {
      User? user = await authProvider.getUserDetails();
      if (user == null) {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      } else if (user.garrageOwner == false) {
        Navigator.pushReplacementNamed(context, AppRoutes.customer_home);
      } else {
        await garageProvider.getGarageByUserId(user.id);
        Navigator.pushReplacementNamed(context, AppRoutes.garage_home);
      }
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  // ------------------------------------------------------------
  // POPUP WHEN LOCATION IS REQUIRED BUT USER DENIES
  // ------------------------------------------------------------
  void _showForcedPopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            "Location Permission Required",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
          ),
          content: const Text.rich(
            TextSpan(
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
              children: [
                TextSpan(
                  text: "This app needs your location to ",
                  style: TextStyle(fontWeight: FontWeight.normal),
                ),
                TextSpan(
                  text: "show nearby garages,",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: " Please enable location permission.",
                  style: TextStyle(fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                fetchVersionAndNavigate(); // continue without location → avoid infinite loader
              },
              child: Text("cancel", style: TextStyle(color: Colors.red[300])),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(ctx);
                await openAppSettings();
              },
              child: const Text(
                "Open Settings",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: CircularProgressIndicator()),
    );
  }

  Future<void> fetchVersionAndNavigate() async {
    String myUrl = "${ApiConstants.BASE_URL}/api/GetLatestVaersion";
    var req = await http.get(Uri.parse(myUrl));
    Version version = Version.fromJson(jsonDecode(req.body));
    debugPrint("Current Version is ${version.version}");
    if (version.version.toString() == AppConstants.APP_VERSION.toString()) {
      _goNext();
    } else {
      showUpdateDialog();
    }
  }

  void showUpdateDialog() {
    showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Carcheks Update'),
        content: const Text(
          'A new version of Carcheks is available. Please update the app from the Play Store to continue using all features.',
        ),
        actions: [
          TextButton(
            onPressed: redirectToPlayStore,
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void redirectToPlayStore() {
    final Uri url = Uri.parse(AppConstants.playStoreUrl);
    launchUrl(url, mode: LaunchMode.externalApplication);
  }
}
