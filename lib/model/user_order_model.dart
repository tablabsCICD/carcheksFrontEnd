import 'package:carcheks/model/user_table_model.dart';
import 'package:carcheks/model/vehicle_model.dart';

class UserOrderModel {
  String? message;
  UserOrder? data;
  bool? success;

  UserOrderModel({this.message, this.data, this.success});

  UserOrderModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new UserOrder.fromJson(json['data']) : null;
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['success'] = this.success;
    return data;
  }
}

class UserOrder {
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
    id = json['id'];
    created = json['created']??'';
    createdBy = json['createdBy']??'';
    updated = json['updated']??'';
    updatedBy = json['updatedBy']??'';
    active = json['active'];
    userTable = json['userTable'] != null
        ? new User.fromJson(json['userTable'])
        : null;
    vehicle =
    json['vehicle'] != null ? new Vehicle.fromJson(json['vehicle']) : null;
    totalAmout = json['total_amout']??0;
    status = json['status']??'';
    invoiceNumber = json['invoiceNumber']??'';
    isBid = json['isBid'];
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
    if (this.vehicle != null) {
      data['vehicle'] = this.vehicle!.toJson();
    }
    data['total_amout'] = this.totalAmout;
    data['status'] = this.status;
    data['invoiceNumber'] = this.invoiceNumber;
    data['isBid'] = this.isBid;
    return data;
  }
}





/*class UserOrderModel {
  UserOrderModel({
    required this.message,
    required this.data,
    required this.success,
  });
  late final String message;
  late final List<UserOrder> data;
  late final bool success;

  UserOrderModel.fromJson(Map<String, dynamic> json){
    message = json['message'];
    data = List.from(json['data']).map((e)=>UserOrder.fromJson(e)).toList();
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['message'] = message;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    _data['success'] = success;
    return _data;
  }
}

class UserOrder {
  UserOrder({
    required this.id,
    required this.created,
    required this.createdBy,
    required this.updated,
    required this.updatedBy,
    required this.active,
    required this.userTable,
    required this.vehicle,
    required this.totalAmout,
    required this.status,
    required this.invoiceNumber,
    required this.isBid,
  });
  late final int? id;
  late final String? created;
  late final String? createdBy;
  late final String? updated;
  late final String? updatedBy;
  late final bool? active;
  late final User? userTable;
  late final Vehicle? vehicle;
  late final int? totalAmout;
  late final String? status;
  late final String? invoiceNumber;
  late final bool? isBid;

  UserOrder.fromJson(Map<String, dynamic> json){
    id = json['id']??0;
    created = json['created']??'';
    createdBy = json['createdBy']??'';
    updated = json['updated']??'';
    updatedBy = json['updatedBy']??'';
    active = json['active']??true;
    userTable = json['userTable'] != null
        ? new User.fromJson(json['userTable'])
        : null;
    vehicle = json['vehicle'] != null
        ? new Vehicle.fromJson(json['vehicle'])
        : null;
    totalAmout = json['total_amout']??0;
    status = json['status']??'';
    invoiceNumber = json['invoiceNumber']??'';
    isBid = json['isBid']??false;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['created'] = created;
    _data['createdBy'] = createdBy;
    _data['updated'] = updated;
    _data['updatedBy'] = updatedBy;
    _data['active'] = active;
    if (this.userTable != null) {
      _data['userTable'] = this.userTable!.toJson();
    }
    if (this.vehicle != null) {
      _data['vehicle'] = this.vehicle!.toJson();
    }
    _data['total_amout'] = totalAmout;
    _data['status'] = status;
    _data['invoiceNumber'] = invoiceNumber;
    _data['isBid'] = isBid;
    return _data;
  }
}*/

