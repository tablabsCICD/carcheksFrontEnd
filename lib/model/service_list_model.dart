import 'garage_services_model.dart';
import 'user_order_model.dart';

class ServiceListModel {
  String? message;
  List<Data>? data;
  bool? success;

  ServiceListModel({this.message, this.data, this.success});

  ServiceListModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
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

class Data {
  int? id;
  String? created;
  String? createdBy;
  String? updated;
  String? updatedBy;
  bool? active;
  UserOrder? userOrderId;
  GarageService? garageServices;

  Data(
      {this.id,
        this.created,
        this.createdBy,
        this.updated,
        this.updatedBy,
        this.active,
        this.userOrderId,
        this.garageServices,
      });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    created = json['created'];
    createdBy = json['createdBy'];
    updated = json['updated'];
    updatedBy = json['updatedBy'];
    active = json['active'];
    userOrderId = json['userOrderId'] != null
        ? new UserOrder.fromJson(json['userOrderId'])
        : null;
    garageServices = json['garageServices'] != null
        ? new GarageService.fromJson(json['garageServices'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created'] = this.created;
    data['createdBy'] = this.createdBy;
    data['updated'] = this.updated;
    data['updatedBy'] = this.updatedBy;
    data['active'] = this.active;
    if (this.userOrderId != null) {
      data['userOrderId'] = this.userOrderId!.toJson();
    }
    if (this.garageServices != null) {
      data['garageServices'] = this.garageServices!.toJson();
    }
    return data;
  }
}



