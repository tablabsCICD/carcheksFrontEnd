import 'package:carcheks/model/fuel_type_model.dart';
import 'package:carcheks/model/vehicle_manufacturer_model.dart';
import 'package:carcheks/model/vehicle_type_model.dart';

class VehicleModel {
  String? message;
  List<Vehicle>? data;
  bool? success;

  VehicleModel({this.message, this.data, this.success});

  VehicleModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <Vehicle>[];
      json['data'].forEach((v) {
        data!.add(new Vehicle.fromJson(v));
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

class Vehicle {
  int? id;
  String? created;
  String? createdBy;
  String? updated;
  String? updatedBy;
  bool? active;
  int? userId;
  VehicleManufacturer? vehicleManufacturer;
  int? vehicleManufacturerId;
  String? vehicleModel;
  FuelType? fueltype;
  int? fueltypeId;
  String? photosUrl;
  Vehicletype? vehicletype;
  int? vehicletypeId;
  String? yearOfManufacturing;
  String? registrationNo;
  String? lastServiceDate;
  String? name;

  Vehicle(
      {this.id,
        this.created,
        this.createdBy,
        this.updated,
        this.updatedBy,
        this.active,
        this.userId,
        this.vehicleManufacturer,
        this.vehicleManufacturerId,
        this.vehicleModel,
        this.fueltype,
        this.fueltypeId,
        this.photosUrl,
        this.vehicletype,
        this.vehicletypeId,
        this.yearOfManufacturing,
        this.registrationNo,
        this.lastServiceDate,
        this.name});

  Vehicle.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    created = json['created']??'';
    createdBy = json['createdBy']??'';
    updated = json['updated']??'';
    updatedBy = json['updatedBy']??"";
    active = json['active'];
    userId = json['userId'];
    vehicleManufacturer = json['vehicleManufacturer'] != null
        ? new VehicleManufacturer.fromJson(json['vehicleManufacturer'])
        : null;
    vehicleManufacturerId = json['vehicleManufacturerId'];
    vehicleModel = json['vehicle_model']??'';
    fueltype = json['fueltype'] != null
        ? new FuelType.fromJson(json['fueltype'])
        : null;
    fueltypeId = json['fueltypeId'];
    photosUrl = json['photos_url']??'';
    vehicletype = json['vehicletype'] != null
        ? new Vehicletype.fromJson(json['vehicletype'])
        : null;
    vehicletypeId = json['vehicletypeId'];
    yearOfManufacturing = json['year_of_manufacturing']??'';
    registrationNo = json['registrationNo']??'';
    lastServiceDate = json['lastServiceDate']??'';
    name = json['name']??"";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created'] = this.created;
    data['createdBy'] = this.createdBy;
    data['updated'] = this.updated;
    data['updatedBy'] = this.updatedBy;
    data['active'] = this.active;
    data['userId'] = this.userId;
    if (this.vehicleManufacturer != null) {
      data['vehicleManufacturer'] = this.vehicleManufacturer!.toJson();
    }
    data['vehicleManufacturerId'] = this.vehicleManufacturerId;
    data['vehicle_model'] = this.vehicleModel;
    data['fueltype'] = this.fueltype;
    data['fueltypeId'] = this.fueltypeId;
    data['photos_url'] = this.photosUrl;
    if (this.vehicletype != null) {
      data['vehicletype'] = this.vehicletype!.toJson();
    }
    data['vehicletypeId'] = this.vehicletypeId;
    data['year_of_manufacturing'] = this.yearOfManufacturing;
    data['registrationNo'] = this.registrationNo;
    data['lastServiceDate'] = this.lastServiceDate;
    data['name'] = this.name;
    return data;
  }
}




