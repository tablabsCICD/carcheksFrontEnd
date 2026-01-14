import 'dart:convert';
import 'package:carcheks/model/address_model.dart';
import 'package:carcheks/model/city_model.dart';
import 'package:carcheks/util/api_constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddressProvider extends ChangeNotifier {
  /// ---------------- CORE STATE ----------------
  bool isLoading = false;

  /// Selected / Single address (legacy usage)
  AddressClass? addressObj;
  AddressClass? selectedAddress;

  /// Address list (NEW + REQUIRED)
  List<AddressClass> addressList = [];

  /// City master
  List<City> cityList = [];
  List<String> cityNameList = [];
  List<String> stateNameList = [];
  List<String> countryNameList = [];

  /// Current location cache
  double? currentLat;
  double? currentLng;

  /// ------------------------------------------------------------
  /// 🔹 GET ALL ADDRESSES (PRIMARY METHOD – USE THIS EVERYWHERE)
  /// ------------------------------------------------------------
  Future<void> getAllAddresses(int userId) async {
    isLoading = true;
    notifyListeners();

    try {
      final url = Uri.parse(
        "${ApiConstants.BASE_URL}/api/getAddressForUser?userId=$userId",
      );

      final res = await http.get(url);

      if (res.statusCode == 200) {
        final decoded = json.decode(res.body);
        final model = AddressModel.fromJson(decoded);

        addressList.clear();
        addressList.addAll(model.data);

        /// auto-select first address
        selectedAddress ??= addressList.isNotEmpty ? addressList.first : null;
      }
    } catch (e) {
      debugPrint("getAllAddresses error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// ------------------------------------------------------------
  /// 🔹 SELECT ADDRESS (UI SELECTION)
  /// ------------------------------------------------------------
  void selectAddress(AddressClass address) {
    selectedAddress = address;
    notifyListeners();
  }

  /// ------------------------------------------------------------
  /// 🔹 SET CURRENT LOCATION (FROM GPS)
  /// ------------------------------------------------------------
  void setCurrentLocation(double lat, double lng) {
    currentLat = lat;
    currentLng = lng;
    notifyListeners();
  }

  /// ------------------------------------------------------------
  /// 🔹 ADD ADDRESS (SAVE API)
  /// ------------------------------------------------------------
  Future<void> addAddress(AddressClass address) async {
    final url = Uri.parse("${ApiConstants.BASE_URL}/api/address/save");

    final res = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(address.toJson()),
    );

    if (res.statusCode == 200) {
      await getAllAddresses(address.userId);
    }
  }

  /// ------------------------------------------------------------
  /// 🔹 UPDATE ADDRESS (KEEPING YOUR OLD METHOD SIGNATURE)
  /// ------------------------------------------------------------
  Future<void> updateAddress({
    bool? active,
    String? created,
    String? created_by,
    String? landmark,
    String? houseName,
    String? street,
    String? latitude,
    String? longitude,
    String? zipCode,
    bool? garrageAddress,
    int? userId,
    String? cityname,
    String? state,
    String? country,
    String? updated,
    String? updated_by,
    required int id,
  }) async {
    String myUrl = "${ApiConstants.BASE_URL}/api/address/update";
    Uri uri = Uri.parse(myUrl);

    Map<String, dynamic> data = {
      "id": id,
      "active": active,
      "houseName": houseName,
      "street": street,
      "cityname": cityname,
      "state": state,
      "country": country,
      "zipCode": zipCode,
      "landmark": landmark,
      "latitude": latitude,
      "longitude": longitude,
      "garrageAddress": garrageAddress,
      "userId": userId,
      "created": created,
      "createdBy": created_by,
      "updated": updated,
      "updatedBy": updated_by,
    };

    final res = await http.put(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    if (res.statusCode == 200 && userId != null) {
      await getAllAddresses(userId);
    }
  }

  /// ------------------------------------------------------------
  /// 🔹 LEGACY SINGLE ADDRESS (DO NOT REMOVE – USED IN OLD SCREENS)
  /// ------------------------------------------------------------
  Future<AddressClass?> getAddressForUser(int id) async {
    isLoading = true;
    notifyListeners();

    final url = Uri.parse(
      "${ApiConstants.BASE_URL}/api/getAddressForUser?userId=$id",
    );

    final res = await http.get(url);
    isLoading = false;

    if (res.statusCode == 200) {
      final decoded = json.decode(res.body);
      if (decoded['data'] != null && decoded['data'].isNotEmpty) {
        addressObj = AddressClass.fromJson(decoded['data'][0]);
        notifyListeners();
        return addressObj;
      }
    }
    return null;
  }

  /// ------------------------------------------------------------
  /// 🔹 GET ALL CITY MASTER
  /// ------------------------------------------------------------
  Future<void> getAllCity() async {
    isLoading = true;
    notifyListeners();

    final res = await http.get(Uri.parse(ApiConstants.GET_ALL_CITY));
    isLoading = false;

    if (res.statusCode == 200) {
      final decoded = json.decode(res.body);
      if (decoded['data'] != null) {
        final model = CityModel.fromJson(decoded);

        cityList.clear();
        cityNameList.clear();
        stateNameList.clear();
        countryNameList.clear();

        cityList.addAll(model.data);
        for (var city in cityList) {
          cityNameList.add(city.city);
          stateNameList.add(city.state);
          countryNameList.add(city.country);
        }
      }
    }
    notifyListeners();
  }

  /// ------------------------------------------------------------
  /// 🔹 FIND CITY ID
  /// ------------------------------------------------------------
  int? selectedCityId;
  getSelectedCityId(String cityName) {
    cityList.forEach((element) {
      if (element.city == cityName) {
        selectedCityId = element.id;
      }
    });
    return selectedCityId;
  }
}
