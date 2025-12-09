import 'package:carcheks/model/garage_services_model.dart';

import 'user_table_model.dart';
import 'vehicle_model.dart';

class UserOrderServicesModel {
  String? message;
  List<UserOrderServices>? data;
  bool? success;

  UserOrderServicesModel({this.message, this.data, this.success});

  UserOrderServicesModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <UserOrderServices>[];
      json['data'].forEach((v) {
        data!.add(new UserOrderServices.fromJson(v));
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

class UserOrderServices {
  int? id;
  String? created;
  String? createdBy;
  String? updated;
  String? updatedBy;
  bool? active;
  UserOrder? userOrderId;
  int? userorderId1;
  GarageService? garageServices;
  int? garageServicesId;

  UserOrderServices(
      {this.id,
        this.created,
        this.createdBy,
        this.updated,
        this.updatedBy,
        this.active,
        this.userOrderId,
        this.userorderId1,
        this.garageServices,
        this.garageServicesId});

  UserOrderServices.fromJson(Map<String, dynamic> json) {
    id = json['id']??0;
    created = json['created']??'';
    createdBy = json['createdBy']??'';
    updated = json['updated']??'';
    updatedBy = json['updatedBy']??'';
    active = json['active']??true;
    userOrderId = json['userOrderId'] != null
        ? new UserOrder.fromJson(json['userOrderId'])
        : null;
    userorderId1 = json['userorderId1']??0;
    garageServices = json['garageServices'] != null
        ? new GarageService.fromJson(json['garageServices'])
        : null;
    garageServicesId = json['garageServicesId']??0;
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
    data['userorderId1'] = this.userorderId1;
    if (this.garageServices != null) {
      data['garageServices'] = this.garageServices!.toJson();
    }
    data['garageServicesId'] = this.garageServicesId;
    return data;
  }
}

class UserOrder{
  int? id;
  String? created;
  String? createdBy;
  String? updated;
  String? updatedBy;
  bool? active;
  User? userTable;
  Vehicle? vehicle;
  int? totalAmout;
  String? status;
  String? invoiceNumber;
  bool? isBid;

  UserOrder(
      {this.id,
        this.created,
        this.createdBy,
        this.updated,
        this.updatedBy,
        this.active,
        this.userTable,
        this.vehicle,
        this.totalAmout,
        this.status,
        this.invoiceNumber,
        this.isBid});

  UserOrder.fromJson(Map<String, dynamic> json) {
    id = json['id']??0;
    created = json['created']??'';
    createdBy = json['createdBy']??'';
    updated = json['updated']??'';
    updatedBy = json['updatedBy']??"";
    active = json['active']??true;
    userTable = json['userTable'] != null
        ? new User.fromJson(json['userTable'])
        : null;
    vehicle = json['vehicle']!=null ? Vehicle.fromJson(json['vehicle']):null;
    totalAmout = json['total_amout']??0;
    status = json['status']??'';
    invoiceNumber = json['invoiceNumber']??'';
    isBid = json['isBid']??true;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created'] = this.created;
    data['createdBy'] = this.createdBy;
    data['updated'] = this.updated;
    data['updatedBy'] = this.updatedBy;
    data['active'] = this.active;
    if (this.userTable != null) {
      data['userTable'] = this.userTable!.toJson();
    }
    data['vehicle'] = this.vehicle;
    data['total_amout'] = this.totalAmout;
    data['status'] = this.status;
    data['invoiceNumber'] = this.invoiceNumber;
    data['isBid'] = this.isBid;
    return data;
  }
}
