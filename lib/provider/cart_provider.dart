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
  bool isCheckoutLoading = false; // ✅ added for checkout loader

  double totalAmount = 0.0;

  /// ================= TOTAL AMOUNT =================
  String getTotalAmount() {
    totalAmount = 0.0;
    for (var element in cartItemList) {
      totalAmount += double.tryParse(
          element.garageServicesdtls!.cost.toString()) ??
          0.0;
    }
    return totalAmount.toString();
  }

  /// ================= FINAL CART ITEMS =================
  List<Items> itemList = [];

  getFinalCartList() {
    if (cartItemList.isNotEmpty) {
      checkoutCartItemList.clear(); // ✅ prevent duplicates
      itemList.clear(); // ✅ prevent duplicates

      checkoutCartItemList.addAll(cartItemList);

      for (int i = 0; i <= checkoutCartItemList.length - 1; i++) {
        itemList.add(
          Items(
            name: checkoutCartItemList[i]
                .garageServicesdtls!
                .subService!
                .name ??
                "",
            quantity: 1,
            price: checkoutCartItemList[i]
                .garageServicesdtls!
                .cost
                .toString(),
            currency: "USD",
          ),
        );
      }

      debugPrint("ItemList: ${itemList.length}");
      notifyListeners();
    } else {}
  }

  removeAmount(int amt) {
    totalAmount = totalAmount - amt;
  }

  /// ================= GET CART =================
  getCartByUserId(int userId) async {
    isLoading = true;
    notifyListeners();

    cartItemList.clear();
    String myUrl = ApiConstants.cartGetByUserId(userId);
    print(myUrl);

    try {
      var req = await http.get(Uri.parse(myUrl));
      if (req.statusCode == 200) {
        var response = json.decode(req.body);
        var type = CartModel.fromJson(response);
        cartItemList.addAll(type.data as Iterable<Cart>);
      }
    } catch (e) {
      debugPrint("getCartByUserId error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  final authProvider = locator<AuthProvider>();
  final now = DateTime.now();

  /// ================= ADD TO CART =================
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
    Uri uri = Uri.parse(myUrl);

    Map<String, dynamic> data = {
      "created": formatter,
      "createdBy": authProvider.user!.firstName,
      "currentOrderId": currentOrderId,
      "garageServiceId": [garageService!.id],
      "totalAmount": garageService.cost,
      "updated": formatter,
      "updatedBy": authProvider.user!.firstName,
      "usertableId": usertableId
    };

    try {
      var body = json.encode(data);
      var createResponse = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (createResponse.statusCode == 200) {
        var response = json.decode(createResponse.body);
        if (response['data'] == []) {
          return null;
        } else {
          var responseData = Cart.fromJson(response);
          cartItemList.add(responseData);
          notifyListeners();
          return response;
        }
      }
    } catch (e) {
      debugPrint("addToCart error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return null;
  }

  /// ================= REMOVE CART ITEM =================
  removeCartItem(Cart cart) async {
    isLoading = true;
    notifyListeners();

    try {
      String myUrl = ApiConstants.removeCart(cart.id);
      var req = await http.delete(Uri.parse(myUrl));
      var deleteResponse = json.decode(req.body);

      if (deleteResponse["success"] == true) {
        cartItemList.remove(cart);
      }
      return deleteResponse;
    } catch (e) {
      debugPrint("removeCartItem error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// ================= CHECKOUT LOADER =================
  void setCheckoutLoading(bool value) {
    isCheckoutLoading = value;
    notifyListeners();
  }
}
