import 'dart:convert';
import 'package:carcheks/model/garage_model.dart';
import 'package:carcheks/model/garage_services_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:carcheks/locator.dart';
import 'package:carcheks/provider/auth_provider.dart';
import '../model/services.dart';
import '../util/api_constants.dart';

class SearchProvider extends ChangeNotifier {
  /// FINAL LIST USED BY UI (garage + service merged)
  List<GarageService> garageServiceList = [];

  /// Main services (optional)
  List<MainService> mainServiceList = [];

  /// Garages (optional)
  List<Garage> dashboardGarageList = [];

  bool isLoading = false;

  final authProvider = locator<AuthProvider>();

  // ------------------------------------------------------------
  //                  GET ALL MERGED DATA
  // ------------------------------------------------------------
  Future<void> getAllData(String vehicleTypeName) async {
    isLoading = true;
    notifyListeners();

    garageServiceList.clear();
    mainServiceList.clear();
    dashboardGarageList.clear();

    final url =
        "${ApiConstants.BASE_URL}/garrage_services/garage-services/search2?vehicleTypeName=$vehicleTypeName";

    print("🔎 Fetching Merged Data: $url");

    try {
      final response = await http.get(Uri.parse(url));

      isLoading = false;

      if (response.statusCode == 200) {
        /// FIX: Convert response to List<dynamic>
        final List<dynamic> jsonList = jsonDecode(response.body);

        /// FIX: Convert each json item to GarageService
        garageServiceList =
            jsonList.map((e) => GarageService.fromJson(e)).toList();

        // Extract optional data
        for (var item in garageServiceList) {
          if (item.mainService != null) mainServiceList.add(item.mainService!);
          if (item.garage != null) dashboardGarageList.add(item.garage!);
        }

        // Remove duplicates
        mainServiceList = mainServiceList.toSet().toList();
        dashboardGarageList = dashboardGarageList.toSet().toList();

        print("✅ Loaded: ${garageServiceList.length} results");
      } else {
        print("❌ Error: ${response.statusCode}");
      }

      notifyListeners();
    } catch (e) {
      isLoading = false;
      print("⚠ Exception in getAllData: $e");
      notifyListeners();
    }
  }

  Future<void> getGarageServiceMerged() async {
    notifyListeners();
  }
}
