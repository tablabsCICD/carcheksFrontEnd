import 'package:carcheks/model/garage_services_model.dart';

import 'user_table_model.dart';

class CartModel {
  String? message;
  List<Cart>? data;
  bool? success;

  CartModel({this.message, this.data, this.success});

  CartModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <Cart>[];
      json['data'].forEach((v) {
        data!.add(new Cart.fromJson(v));
      });
    }
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['success'] = this.success;
    return data;
  }
}

class Cart {
  int? id;
  int? totalAmount;
  int? currentOrderId;
  User? userTable;
  GarageService? garageServicesdtls;

  Cart(
      {this.id,
        this.totalAmount,
        this.currentOrderId,
        this.userTable,
        this.garageServicesdtls});

  Cart.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    totalAmount = json['totalAmount'];
    currentOrderId = json['currentOrderId'];
    userTable = json['userTable'] != null
        ? new User.fromJson(json['userTable'])
        : null;
    garageServicesdtls = json['garageServicesdtls'] != null
        ? new GarageService.fromJson(json['garageServicesdtls'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['totalAmount'] = this.totalAmount;
    data['currentOrderId'] = this.currentOrderId;
    if (this.userTable != null) {
      data['userTable'] = this.userTable!.toJson();
    }
    if (this.garageServicesdtls != null) {
      data['garageServicesdtls'] = this.garageServicesdtls!.toJson();
    }
    return data;
  }
}

