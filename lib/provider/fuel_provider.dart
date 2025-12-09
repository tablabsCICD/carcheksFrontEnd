import 'dart:convert';

import 'package:carcheks/model/fuel_model.dart';
import 'package:carcheks/model/fuel_type_model.dart';
import 'package:carcheks/model/services.dart';
import 'package:carcheks/util/api_constants.dart';
import 'package:carcheks/util/app_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class FuelProvider extends ChangeNotifier{
  List<FuelType> allFuelTypeList = [];
  List<String> allFuelTypeNameList = [];
  bool isLoading = false;

  getAllFuelType({int currentPage = 0}) async {
    isLoading = true;
    notifyListeners();
    if(currentPage == 0){
      allFuelTypeList.clear();
    }
    String myUrl = ApiConstants.allFuelType;
    print(myUrl);
    var req = await http.get(Uri.parse(myUrl));
    isLoading = false;
    if(req.statusCode == 200) {
      var response = json.decode(req.body);
      var type = FuelTypeModel.fromJson(response);
      allFuelTypeList.clear();
      allFuelTypeNameList.clear();
      allFuelTypeList.addAll(type.data);
      allFuelTypeList.forEach((element) {
        allFuelTypeNameList.add(element.name);
      });
      notifyListeners();
    }
  }

  int? selectedFuelTypeId;
  FuelType? fuelType;
  getSelectedFuelTypeId(String fuelTypeName){
    allFuelTypeList.forEach((element) {
      if(element.name == fuelTypeName){
        selectedFuelTypeId = element.id;
        fuelType = element;
      }
    });
    return fuelType;
  }
}