import 'dart:convert';

import 'package:carcheks/locator.dart';
import 'package:carcheks/model/cart_model.dart';
import 'package:carcheks/model/garage_services_model.dart';
import 'package:carcheks/model/paypal_request.dart';
import 'package:carcheks/provider/auth_provider.dart';
import 'package:carcheks/util/api_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class CartProvider extends ChangeNotifier {
  List<Cart> cartItemList = [];
  List<Cart> checkoutCartItemList = [];
  bool isLoading = false;

  double totalAmount = 0.0;

  String getTotalAmount() {
    totalAmount = 0.0;
    cartItemList.forEach((element) {
      totalAmount =
          totalAmount +
          double.parse(element.garageServicesdtls!.cost.toString());
    });
    return totalAmount.toString();
  }

  List<Items> itemList = [];

  getFinalCartList() {
    if (cartItemList.isNotEmpty) {
      checkoutCartItemList.addAll(cartItemList);

      for (int i = 0; i <= checkoutCartItemList.length - 1; i++) {
        itemList.add(
          Items(
            name: checkoutCartItemList[i].garageServicesdtls!.subService!.name,
            quantity: 1,
            price: checkoutCartItemList[i].garageServicesdtls!.cost.toString(),
            currency: "USD",
          ),
        );
      }
      debugPrint("ItemList: " + itemList.length.toString());
      notifyListeners();
    } else {}
  }

  removeAmount(int amt) {
    totalAmount = totalAmount - amt;
  }

  getCartByUserId(int userId) async {
    isLoading = true;
    notifyListeners();

    cartItemList.clear();

    String myUrl = ApiConstants.cartGetByUserId(userId);
    debugPrint(myUrl);

    try {
      final req = await http.get(Uri.parse(myUrl));

      if (req.statusCode == 200) {
        final response = json.decode(req.body);
        final type = CartModel.fromJson(response);
        cartItemList.addAll(type.data as Iterable<Cart>);
      }
    } catch (e) {
      debugPrint("Cart fetch error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  final authProvider = locator<AuthProvider>();
  final now = DateTime.now();

  addToCart({
    int? currentOrderId,
    GarageService? garageService,
    int? totalAmt,
    int? usertableId,
  }) async {
    String formatter = DateFormat('yMd').format(now);
    isLoading = true;
    notifyListeners();

    String myUrl = ApiConstants.saveCart;
    debugPrint(myUrl);

    Uri uri = Uri.parse(myUrl);
    Map<String, dynamic> data = {
      "created": formatter,
      "createdBy": authProvider.user!.firstName,
      "currentOrderId": currentOrderId,
      "garageServiceId": [garageService!.id],
      "totalAmount": garageService.cost,
      "updated": formatter,
      "updatedBy": authProvider.user!.firstName,
      "usertableId": usertableId,
    };

    var body = json.encode(data);
    print(data);

    try {
      var createResponse = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      print(
        "${createResponse.statusCode}" +
            " --- " +
            createResponse.body.toString(),
      );

      if (createResponse.statusCode == 200) {
        var response = await json.decode(createResponse.body);
        if (response['data'] == []) {
          notifyListeners();
          return null;
        } else {
          var responseData = Cart.fromJson(response);
          cartItemList.add(responseData);
          notifyListeners();
          return response;
        }
      } else {
        notifyListeners();
        return null;
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  removeCartItem(Cart cart) async {
    isLoading = true;
    notifyListeners();

    String myUrl = ApiConstants.removeCart(cart.id);

    try {
      var req = await http.delete(Uri.parse(myUrl));
      var deleteResponse = json.decode(req.body);
      var responseData = Cart.fromJson(deleteResponse);

      if (deleteResponse["success"] == true) {
        cartItemList.remove(cart);
        notifyListeners();
      }

      return deleteResponse;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
