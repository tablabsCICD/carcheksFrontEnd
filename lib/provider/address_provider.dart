import 'dart:convert';

import 'package:carcheks/model/address_model.dart';
import 'package:carcheks/model/city_model.dart';
import 'package:carcheks/util/app_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../util/api_constants.dart';


class AddressProvider extends ChangeNotifier{
  AddressClass? addressObj;
  bool isLoading = false;
  List<City> cityList = [];
  List<String> cityNameList=[];
  List<String> countryNameList=[];
  List<String> stateNameList=[];

  getAllCity() async {
    isLoading = true;
    notifyListeners();
    String myUrl = ApiConstants.GET_ALL_CITY;
    print(myUrl);
    var req = await http.get(Uri.parse(myUrl));
    isLoading = false;
    if(req.statusCode == 200) {
      var response = json.decode(req.body);
      if(response['data']){
        var type = CityModel.fromJson(response);
        cityList.addAll(type.data);
        cityList.forEach((element) {
          cityNameList.add(element.city);
          countryNameList.add(element.country);
          stateNameList.add(element.state);
        });
        return cityList;
      }else{
      return [];
      }
    }
  }

  int? selectedCityId;
  getSelectedCityId(String cityName){
    cityList.forEach((element) {
      if(element.city == cityName){
        selectedCityId = element.id;
      }
    });
    return selectedCityId;
  }

  getAddressForUser(int id) async {
    isLoading = true;
    notifyListeners();
    String myUrl = ApiConstants.BASE_URL + "/api/getAddressForUser?userId=${id}";
    print(myUrl);
    var req = await http.get(Uri.parse(myUrl));
    isLoading = false;
    if(req.statusCode == 200) {
      addressObj = null;
      var response = json.decode(req.body);
      if(response['data'] != null){
        final List<dynamic> dataList = response['data'];
        List<AddressClass> type = List<AddressClass>.from(dataList.map((json) => AddressClass.fromJson(json)));
        addressObj = type[0];
       // getCityByCityId(addressObj!.cityId);
        notifyListeners();
        return addressObj;
      }else{
        return null;
      }

    }
  }

  AddressClass? garageAddress;
  getAddressForGarrage(int id) async {
    isLoading = true;
    notifyListeners();
    String myUrl = ApiConstants.BASE_URL + "/api/address/getById?id=${id}";
    print(myUrl);
    var req = await http.get(Uri.parse(myUrl));
    isLoading = false;
    if(req.statusCode == 200) {
      garageAddress = null;
      var response = json.decode(req.body);
      if(response['data'] != null){
        var data = AddressClass.fromJson(response['data']);
        garageAddress = data;
       // getCityByCityId(garageAddress!.cityId);
        notifyListeners();
        return garageAddress;
      }else{
        return null;
      }

    }
  }

  getAddressByUserId(int id) async {
    isLoading = true;
    notifyListeners();
    String myUrl = ApiConstants.BASE_URL + "/api/address/getByUserId?id=${id}";
    print(myUrl);
    var req = await http.get(Uri.parse(myUrl));
    isLoading = false;
    if(req.statusCode == 200) {
      addressObj = null;
      var response = json.decode(req.body);
      if(response['data'] != null){
        final List<dynamic> dataList = response['data'];
        List<AddressClass> type = List<AddressClass>.from(dataList.map((json) => AddressClass.fromJson(json)));
        addressObj = type[0];
       // getCityByCityId(addressObj!.cityId);
        notifyListeners();
        return addressObj;
      }else{
        return null;
      }
    }
  }

  City? city;
  getCityByCityId(int cityId) async {
    isLoading = true;
    notifyListeners();
    String myUrl = ApiConstants.BASE_URL + "/api/city/getById?id=${cityId}";
    print(myUrl);
    var req = await http.get(Uri.parse(myUrl));
    isLoading = false;
    if(req.statusCode == 200) {
      city = null;
      var response = json.decode(req.body);
      if(response['data'] != null){
        var type = City.fromJson(response['data']);
        city = type;
        notifyListeners();
        return city;
      }else{
        return null;
      }
    }
  }

  saveAddress({bool? active, String? created, String? created_by, String? landmark, String? name, String? street,
    String? zipcode, bool? garrageAddress, int? user_id, String? state,String? country, String? updated, String? updated_by
    }) async {
    String myUrl = ApiConstants.BASE_URL + "/api/address/save";
    print(myUrl);
    Uri uri = Uri.parse(myUrl);

    Map<String, dynamic> data = {
        "active": active,
        "state": state,
      "country":country,
        "created": created,
        "createdBy": created_by,
        "garrageAddress": garrageAddress,
        "landmark": landmark,
        "name": name,
        "street": street,
        "updated": updated,
        "updatedBy": updated_by,
        "userId": user_id,
        "zipCode": zipcode
    };
    var body = json.encode(data);
    print(data);
    var createResponse = await http.post(uri,
        headers: {"Content-Type": "application/json"}, body: body);
    print("${createResponse.statusCode}" + " --- " +
        createResponse.body.toString());
    if(createResponse.statusCode == 200) {
      addressObj = null;
      var response = json.decode(createResponse.body);
      var type = AddressClass.fromJson(response);
      addressObj = type;

      notifyListeners();
    }
  }


  updateAddress({bool? active, String? created, String? created_by, String? landmark, String? houseName, String? street, String? latitude,String? longitude,
    String? zipCode, bool? garrageAddress, int? userId, String? cityname,String? state,String? country, String? updated, String? updated_by, required int id
  }) async {
    String myUrl = ApiConstants.BASE_URL + "/api/address/update";
    print(myUrl);
    Uri uri = Uri.parse(myUrl);

    Map<String, dynamic> data = {
    "active": active,
    "cityname": cityname,
    "country": country,
    "created": created,
    "createdBy": created_by,
    "garrageAddress": garrageAddress,
    "houseName": houseName,
    "id": id,
    "landmark": landmark,
    "latitude": latitude,
    "longitude": longitude,
    "state": state,
    "street": street,
    "updated": updated,
    "updatedBy": updated_by,
    "userId": userId,
    "zipCode": zipCode



    };
    var body = json.encode(data);
    print(data);
    var createResponse = await http.put(uri,
        headers: {"Content-Type": "application/json"}, body: body);
    print("${createResponse.statusCode}" + " --- " +
        createResponse.body.toString());
    if(createResponse.statusCode == 200) {
      addressObj = null;
      var response = json.decode(createResponse.body);
      var type = AddressClass.fromJson(response);
      addressObj = type;
      notifyListeners();
    }
  }



}