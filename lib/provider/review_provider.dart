import 'dart:convert';

import 'package:carcheks/locator.dart';
import 'package:carcheks/model/address_model.dart';
import 'package:carcheks/model/bid_model.dart';
import 'package:carcheks/model/cart_model.dart';
import 'package:carcheks/model/fuel_model.dart';
import 'package:carcheks/model/fuel_type_model.dart';
import 'package:carcheks/model/garage_model.dart';
import 'package:carcheks/model/garage_services_model.dart';
import 'package:carcheks/model/services.dart';
import 'package:carcheks/model/subservices_model.dart';
import 'package:carcheks/model/vehicle_type_model.dart';
import 'package:carcheks/provider/auth_provider.dart';
import 'package:carcheks/util/app_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../model/review_model.dart';
import '../util/api_constants.dart';

class ReviewProvider extends ChangeNotifier {
  List<Review> reviewListByGarageId = [];
  bool isLoading = false;


  getReviewByGarageId(int garageId) async {
    isLoading = true;
    var response;
    notifyListeners();
    reviewListByGarageId.clear();
    String myUrl =
        ApiConstants.BASE_URL + "/api/getall/getallcustomerReviewbygarrageId?id=${garageId}";
    print(myUrl);
    var req = await http.get(Uri.parse(myUrl));
    isLoading = false;
    if (req.statusCode == 200) {
      response = json.decode(req.body);
      var type = ReviewModel.fromJson(response);
      reviewListByGarageId.addAll(type.data as Iterable<Review>);
      notifyListeners();
    }
    return response;
  }


  final authProvider = locator<AuthProvider>();
  final now = DateTime.now();


  addReview({int? garageId,String? comments,double? rating}) async {
    String formatter = DateFormat('yMd').format(now);
    isLoading = true;
    String myUrl = ApiConstants.BASE_URL + "/api/customerReview/save";
    Uri uri = Uri.parse(myUrl);
    Map<String, dynamic> data =
    {
      "active": true,
      "comments": comments,
      "created": formatter,
      "createdBy": authProvider.user!.firstName,
      "garrageId": garageId,
      "rating": rating,
      "updated": formatter,
      "updatedBy": authProvider.user!.firstName,
      "userId":  authProvider.user!.id,
      "verified": true
    };
    var body = json.encode(data);
    print(data);
    var createResponse = await http.post(uri,
        headers: {"Content-Type": "application/json"}, body: body);
    isLoading = false;
    print("${createResponse.statusCode}" +
        " --- " +
        createResponse.body.toString());
    var response = await json.decode(createResponse.body);
    var responseData = Review.fromJson(response);
    reviewListByGarageId.add(responseData);
    notifyListeners();
    return response;
  }


  deleteReview(Review review) async {
    isLoading = true;
    String myUrl = ApiConstants.BASE_URL +
        '/api/customerReview/deleteById?id=${review.id}';
    var req = await http.delete(Uri.parse(myUrl));
    isLoading = false;
    var deleteResponse = json.decode(req.body);
    var responseData = Review.fromJson(deleteResponse);
    if(deleteResponse["success"]==true){
      reviewListByGarageId.remove(review);}
    notifyListeners();
    return deleteResponse;
  }
}
