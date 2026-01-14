import 'dart:convert';

import 'package:carcheks/locator.dart';
import 'package:carcheks/model/order_model.dart';
import 'package:carcheks/provider/auth_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../util/api_constants.dart';

class PaymentProvider extends ChangeNotifier {
  final authProvider = locator<AuthProvider>();
  final now = DateTime.now();
  bool isLoading = false;
  String? orderId;
  String? transactionId;
  int? id;

  createOrder({double? totalAmt, int? garageId, String? invoiceNumber}) async {
    isLoading = true;
    String myUrl = ApiConstants.BASE_URL + "/api/paypal/createOrder";
    debugPrint(myUrl);
    Uri uri = Uri.parse(myUrl);
    Map<String, dynamic> data = {
      "createdTimestamp": 0,
      "currency": "USD",
      "date": "",
      "description": "Sample order description",
      "garageId": garageId,
      "intent": "Capture",
      "invoiceNumber": invoiceNumber,
      "method": "Paypal",
      "orderId": "",
      "price": totalAmt,
      "response": "",
      "status": "PAID",
      "transactionId": "",

      /* "currency": "USD",
      "description": "Sample order description",
      "intent": "CAPTURE",
      "method": "paypal",
      "orderId": "",
      "price": totalAmt,
      "status": "CREATED"*/
    };
    var body = json.encode(data);
    print(data);
    var createResponse = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    isLoading = false;
    print("${createResponse.statusCode}\n" + createResponse.body.toString());
    if (createResponse.statusCode == 200) {
      var response = await json.decode(createResponse.body);
      print(response['data']);
      if (response['data'] == '') {
        notifyListeners();
        return "Error";
      } else {
        OrderModel orderModel = OrderModel.fromJson(response);
        orderId = orderModel.data!.orderId;
        id = orderModel.data!.orderTableObject!.id!;
        notifyListeners();
        return orderId;
      }
    } else {
      notifyListeners();
      return createResponse.statusCode.toString();
    }
  }

  checkOrderStatus({String? orderId}) async {
    isLoading = true;
    String myUrl =
        ApiConstants.BASE_URL + "api/paypal/process-payment/status/5min";
    debugPrint(myUrl);
    Uri uri = Uri.parse(myUrl);
    Map<String, dynamic> data = {"id": id, "orderId": orderId};
    var body = json.encode(data);
    print(data);
    var createResponse = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    isLoading = false;
    print("${createResponse.statusCode}\n" + createResponse.body.toString());
    if (createResponse.statusCode == 202) {
      var response = await json.decode(createResponse.body);
      return response;
    } else {
      notifyListeners();
      return null;
    }
  }

  updateTransaction(String transactionId, String paypalResponse) async {
    isLoading = true;

    String myUrl =
        "${ApiConstants.BASE_URL}/api/paypal/update?id=$id&transactionId=$transactionId&response=$paypalResponse";
    debugPrint(myUrl);
    Uri uri = Uri.parse(myUrl);
    var createResponse = await http.put(
      uri,
      headers: {"Content-Type": "application/json"},
    );
    isLoading = false;
    print(
      "Update Transaction response : ${createResponse.statusCode}\n" +
          createResponse.body.toString(),
    );
    if (createResponse.statusCode == 200) {
      var response = await json.decode(createResponse.body);
      OrderTableObject orderModel = OrderTableObject.fromJson(response);
      return orderModel.transactionId;
    } else {
      notifyListeners();
      return null;
    }
  }
}
