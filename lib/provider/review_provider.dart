import 'dart:convert';
import 'dart:developer';

import 'package:carcheks/locator.dart';
import 'package:carcheks/provider/auth_provider.dart';
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
        ApiConstants.BASE_URL +
        "/api/getall/getallcustomerReviewbygarrageId?id=${garageId}";
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

  addReview({int? garageId, String? comments, double? rating}) async {
    String formatter = DateFormat('yMd').format(DateTime.now());

    isLoading = true;
    notifyListeners();

    String myUrl = ApiConstants.BASE_URL + "/api/customerReview/save";
    Uri uri = Uri.parse(myUrl);

    Map<String, dynamic> data = {
      "active": true,
      "comments": comments,
      "created": formatter,
      "createdBy": authProvider.user!.firstName,
      "garrageId": garageId,
      "rating": rating,
      "updated": formatter,
      "updatedBy": authProvider.user!.firstName,
      "userId": authProvider.user!.id,
      "verified": true,
    };

    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: json.encode(data),
    );

    isLoading = false;

    final decoded = json.decode(response.body);

    /// 🔴 IMPORTANT FIX
    if (decoded["success"] == true &&
        decoded["data"] != null &&
        decoded["data"] != "") {
      final review = Review.fromJson(decoded["data"]);
      reviewListByGarageId.add(review);
      notifyListeners();
    }

    return decoded;
  }

  deleteReview(Review review) async {
    isLoading = true;
    String myUrl =
        ApiConstants.BASE_URL +
        '/api/customerReview/deleteById?id=${review.id}';
    var req = await http.delete(Uri.parse(myUrl));
    isLoading = false;
    var deleteResponse = json.decode(req.body);
    var responseData = Review.fromJson(deleteResponse);
    if (deleteResponse["success"] == true) {
      reviewListByGarageId.remove(review);
    }
    notifyListeners();
    return deleteResponse;
  }
}
