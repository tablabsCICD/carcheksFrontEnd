import 'package:carcheks/model/user_table_model.dart';
import 'package:carcheks/model/vehicle_model.dart';

class UserVehicleModel {
  UserVehicleModel({
    required this.message,
    required this.data,
    required this.success,
  });
  late final String message;
  late final List<UserVehicle> data;
  late final bool success;

  UserVehicleModel.fromJson(Map<String, dynamic> json){
    message = json['message'];
    data = List.from(json['data']).map((e)=>UserVehicle.fromJson(e)).toList();
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

class UserVehicle {
  UserVehicle({
    required this.id,
    required this.created,
    required this.createdBy,
    required this.updated,
    required this.updatedBy,
    required this.active,
    this.userTableId,
    this.vehicleid,
    required this.vehicleNumber,
    required this.vehiclePhotos,
    required this.yearOfManufacturing,
    required this.kmRun,
    required this.average,
    required this.numberServicings,
  });
  late final int id;
  late final String created;
  late final String createdBy;
  late final String updated;
  late final String updatedBy;
  late final bool active;
  late final User? userTableId;
  late final Vehicle? vehicleid;
  late final String vehicleNumber;
  late final String vehiclePhotos;
  late final String yearOfManufacturing;
  late final int kmRun;
  late final int average;
  late final int numberServicings;

  UserVehicle.fromJson(Map<String, dynamic> json){
    id = json['id']??0;
    created = json['created']??'';
    createdBy = json['createdBy']??'';
    updated = json['updated']??'';
    updatedBy = json['updatedBy']??'';
    active = json['active']??true;
    userTableId =User.fromJson(json['userTableId'])??null;
    vehicleid = Vehicle.fromJson(json['vehicleid'])??null;
    vehicleNumber = json['vehicle_number']??'';
    vehiclePhotos = json['vehicle_photos']??'';
    yearOfManufacturing = json['yearOfManufacturing']??'';
    kmRun = json['kmRun']??0;
    average = json['average']??0;
    numberServicings = json['number_servicings']??0;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['created'] = created;
    _data['createdBy'] = createdBy;
    _data['updated'] = updated;
    _data['updatedBy'] = updatedBy;
    _data['active'] = active;
    _data['userTableId'] = userTableId;
    _data['vehicleid'] = vehicleid;
    _data['vehicle_number'] = vehicleNumber;
    _data['vehicle_photos'] = vehiclePhotos;
    _data['yearOfManufacturing'] = yearOfManufacturing;
    _data['kmRun'] = kmRun;
    _data['average'] = average;
    _data['number_servicings'] = numberServicings;
    return _data;
  }
}

