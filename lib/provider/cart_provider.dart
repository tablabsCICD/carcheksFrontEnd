import 'dart:convert';

import 'package:carcheks/locator.dart';
import 'package:carcheks/model/FinalServices.dart';
import 'package:carcheks/model/address_model.dart';
import 'package:carcheks/model/bid_model.dart';
import 'package:carcheks/model/cart_model.dart';
import 'package:carcheks/model/fuel_model.dart';
import 'package:carcheks/model/fuel_type_model.dart';
import 'package:carcheks/model/garage_model.dart';
import 'package:carcheks/model/garage_services_model.dart';
import 'package:carcheks/model/paypal_request.dart';
import 'package:carcheks/model/services.dart';
import 'package:carcheks/model/subservices_model.dart';
import 'package:carcheks/model/vehicle_type_model.dart';
import 'package:carcheks/provider/auth_provider.dart';
import 'package:carcheks/util/api_constants.dart';
import 'package:carcheks/util/app_constants.dart';
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
        totalAmount = totalAmount +
            double.parse(element.garageServicesdtls!.cost.toString());
      });
      return totalAmount.toString();
  }

 // List<Map<String,dynamic>> itemList = [];
  List<Items> itemList = [];
  getFinalCartList(){
    if(cartItemList.isNotEmpty){
    checkoutCartItemList.addAll(cartItemList);

    for(int i=0;i<=checkoutCartItemList.length-1;i++){
      itemList.add(Items(name: checkoutCartItemList[i].garageServicesdtls!.subService!.name??"",quantity:1,price:checkoutCartItemList[i].garageServicesdtls!.cost.toString(),currency: "USD"));
     // itemList.add({"name": checkoutCartItemList[i].garageServicesdtls!.subService!.name??"", "quantity":1, "price": checkoutCartItemList[i].garageServicesdtls!.cost.toString(), "currency": "USD"});
    }
    debugPrint("ItemList: "+itemList.length.toString());
    notifyListeners();
    }else{

    }
  }


  removeAmount(int amt) {
    totalAmount = totalAmount - amt;
  }

  getCartByUserId(int userId) async {
    // isLoading = true;
    var response;
    //notifyListeners();
    cartItemList.clear();
    String myUrl = ApiConstants.cartGetByUserId(userId);
    print(myUrl);
    var req = await http.get(Uri.parse(myUrl));

    if (req.statusCode == 200) {
      response = json.decode(req.body);
      var type = CartModel.fromJson(response);
      cartItemList.addAll(type.data as Iterable<Cart>);
      /*totalAmount = 0.0;
      cartItemList.forEach((element) {
        totalAmount = totalAmount +
            double.parse(element.garageServicesdtls!.cost.toString());
      });*/
      isLoading=false;
      notifyListeners();

    }
    return response;
  }

  final authProvider = locator<AuthProvider>();
  final now = DateTime.now();

  addToCart(
      {int? currentOrderId,
      GarageService? garageService,
      int? totalAmt,
      int? usertableId}) async {
    String formatter = DateFormat('yMd').format(now);
    isLoading = true;
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
      "usertableId": usertableId
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
      var response = await json.decode(createResponse.body);
      if (response['data'] == []) {
        notifyListeners();
        return null;
      } else {
        var responseData = Cart.fromJson(response);
        cartItemList.add(responseData);
       // await getCartByUserId(usertableId!);
        notifyListeners();
        return response;
      }
    } else {
      notifyListeners();
      return null;
    }
  }

  removeCartItem(Cart cart) async {
    isLoading = true;
    String myUrl =
        ApiConstants.removeCart(cart.id);
    var req = await http.delete(Uri.parse(myUrl));
    isLoading = false;
    var deleteResponse = json.decode(req.body);
    var responseData = Cart.fromJson(deleteResponse);
    if (deleteResponse["success"] == true) {
      cartItemList.remove(cart);
     // await removeAmount(responseData.garageServicesdtls!.cost);
      notifyListeners();
    }
    return deleteResponse;
  }
}
