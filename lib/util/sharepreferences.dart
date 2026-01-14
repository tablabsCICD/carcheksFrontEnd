import 'dart:convert';

import 'package:carcheks/util/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/garage_model.dart';
import '../model/user_table_model.dart';

class LocalSharePreferences {
  static final LocalSharePreferences localSharePreferences =
      LocalSharePreferences._internal();
  factory LocalSharePreferences() {
    return localSharePreferences;
  }
  LocalSharePreferences._internal();
  setString(String key, String val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, val);
  }

  setBool(String key, bool val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, val);
  }

  setInt(String key, int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, id);
  }

  Future<String> getString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString(key) == null) {
      return "";
    }
    return prefs.getString(key)!;
  }

  Future<bool> getBool(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool val = false;
    if (prefs.getBool(key) != null) {
      val = prefs.getBool(key)!;
    }
    return val;
  }

  Future<int> getInt(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int val = 0;
    if (key != 0) {
      val = prefs.getInt(key)!;
    }
    return val;
  }

  Future<User?> getLoginData() async {
    String data = await getString(AppConstants.currentUser);
    print("LoggedInUser : ");
    print(data);
    if (data.isEmpty || data == "" || data == null) {
      return null;
    } else {
      User user = User.fromJson(jsonDecode(data));
      return user;
    }
  }

  Future<Garage> getGarageData() async {
    String data = await getString(AppConstants.currentGarage);
    Garage garage = Garage.fromJson(jsonDecode(data));
    return garage;
  }

  Future<bool> logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    setBool(AppConstants.isUserLoggedIn, false);
    return true;
  }
}
