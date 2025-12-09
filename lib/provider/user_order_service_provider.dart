import 'dart:convert';

import 'package:carcheks/locator.dart';
import 'package:carcheks/model/service_list_model.dart';
import 'package:carcheks/model/services.dart';
import 'package:carcheks/model/subservices_model.dart';
import 'package:carcheks/model/user_order_services_model.dart';
import 'package:carcheks/model/vehicle_type_model.dart';
import 'package:carcheks/provider/auth_provider.dart';
import 'package:carcheks/util/app_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../util/api_constants.dart';

class UserOrderServicesProvider extends ChangeNotifier {
  List<UserOrderServices> userOrderServicesList = [];
  List<Data> servicesListByOrderId = [];
  bool isLoading = false;

  getUserOrderServicesByUserId(int userId) async {
    isLoading = true;
    var response;
    notifyListeners();
    userOrderServicesList.clear();
    String myUrl =
        ApiConstants.BASE_URL + "/api/CartCotroller/getByUserId?userId=${userId}";
    print(myUrl);
    var req = await http.get(Uri.parse(myUrl));
    isLoading = false;
    if (req.statusCode == 200) {
      response = json.decode(req.body);
      var type = UserOrderServicesModel.fromJson(response);
      userOrderServicesList.addAll(type.data as Iterable<UserOrderServices>);
    //  getUserOrderServicesByOrderId(userOrderServicesList[0].userOrderId!.id!);
      notifyListeners();
    }
    return response;
  }

  double totalAmount=0.0;
  getTotalAmount(double amt){
    totalAmount = totalAmount + amt;
  }

  removeAmount(double amt){
    totalAmount = totalAmount - amt;
  }

  getUserOrderServicesByOrderId(int orderId) async {
    isLoading = true;
    var response;
  //  notifyListeners();
    servicesListByOrderId.clear();
    String myUrl = ApiConstants.BASE_URL + "/UserOrderServices/UserOrderServices/getbyorderid?UserOrderId=${orderId}";
    print(myUrl);
    var req = await http.get(Uri.parse(myUrl));
    isLoading = false;
    if (req.statusCode == 200) {
      response = json.decode(req.body);
      var type = ServiceListModel.fromJson(response);
      servicesListByOrderId.addAll(type.data as Iterable<Data>);
      totalAmount = 0.0;
      servicesListByOrderId.forEach((element) {
        totalAmount = totalAmount + double.parse(element.garageServices!.cost.toString());
      });
    //  notifyListeners();
    }
    return response;
  }


  final authProvider = locator<AuthProvider>();
  final now = DateTime.now();


  saveUserOrderService({String? status,String? invoiceNumber,int? totalAmt,int? garageServicesId,int? vehicleId}) async {
    String formatter = DateFormat('yMd').format(now);
    isLoading = true;
    String myUrl = ApiConstants.BASE_URL + "/UserOrderServices/UserOrderServices/SaveWithOrderService";
    Uri uri = Uri.parse(myUrl);
    Map<String, dynamic> data =
    {
      "userOrder": {
        "active": true,
        "created": formatter,
        "createdBy": authProvider.user!.firstName,
        "invoiceNumber": invoiceNumber,
        "isBid": true,
        "status": status,
        "total_amout": totalAmt,
        "updated": formatter,
        "updatedBy": authProvider.user!.firstName,
        "usertableId": authProvider.user!.id,
        "vechicleId": vehicleId
      },
      "userOrderServices": {
        "active": true,
        "created": formatter,
        "createdBy": authProvider.user!.firstName,
        "garageServicesId": 0,
        "updated": formatter,
        "updatedBy": authProvider.user!.firstName,
        "userorderId1": 0
      }
    };
    var body = json.encode(data);
    print(data);
    var createResponse = await http.post(uri,
        headers: {"Content-Type": "application/json"}, body: body);
    isLoading = false;
    print("${createResponse.statusCode}" +
        " --- " +
        createResponse.body.toString());

    if (createResponse.statusCode == 200) {
      var response = json.decode(createResponse.body);
      var type = UserOrderServicesModel.fromJson(response);
      userOrderServicesList.addAll(type.data as Iterable<UserOrderServices>);
      await getUserOrderServicesByOrderId(userOrderServicesList[0].userOrderId!.id!);
      notifyListeners();
    }
    return createResponse;
  }
}
