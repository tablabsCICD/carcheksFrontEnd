import 'package:carcheks/model/vehicle_model.dart';

class VehicaleModelNew {
  String? message;
  List<Vehicle>? data;
  bool? success;

  VehicaleModelNew({this.message, this.data, this.success});

  VehicaleModelNew.fromJson(Map<String, dynamic> json) {
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

/*class Vehicle {
  int? id;
  String? created;
  String? createdBy;
  String? updated;
  String? updatedBy;
  bool? active;
  int? userId;
  VehicleManufacturerNew? vehicleManufacturer;
  int? vehicleManufacturerId;
  String? vehicleModel;
  FueltypeNew? fueltype;
  int? fueltypeId;
  String? photosUrl;
  FueltypeNew? vehicletype;
  int? vehicletypeId;
  String? yearOfManufacturing;
  String? registrationNo;
  String? lastServiceDate;
  String? name;

  DataNew(
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

  DataNew.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    created = json['created'];
    createdBy = json['createdBy'];
    updated = json['updated'];
    updatedBy = json['updatedBy'];
    active = json['active'];
    userId = json['userId'];
    vehicleManufacturer = json['vehicleManufacturer'] != null
        ? new VehicleManufacturerNew.fromJson(json['vehicleManufacturer'])
        : null;
    vehicleManufacturerId = json['vehicleManufacturerId'];
    vehicleModel = json['vehicle_model'];
    fueltype = json['fueltype'] != null
        ? new FueltypeNew.fromJson(json['fueltype'])
        : null;
    fueltypeId = json['fueltypeId'];
    photosUrl = json['photos_url']??'';
    vehicletype = json['vehicletype'] != null
        ? new FueltypeNew.fromJson(json['vehicletype'])
        : null;
    vehicletypeId = json['vehicletypeId'];
    yearOfManufacturing = json['year_of_manufacturing'];
    registrationNo = json['registrationNo'];
    lastServiceDate = json['lastServiceDate'];
    name = json['name']??'';
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
    if (this.fueltype != null) {
      data['fueltype'] = this.fueltype!.toJson();
    }
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
}*/

class VehicleManufacturerNew {
  int? id;
  String? created;
  String? createdBy;
  String? updated;
  String? updatedBy;
  bool? active;
  String? name;

  VehicleManufacturerNew(
      {this.id,
        this.created,
        this.createdBy,
        this.updated,
        this.updatedBy,
        this.active,
        this.name});

  VehicleManufacturerNew.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    created = json['created'];
    createdBy = json['createdBy'];
    updated = json['updated'];
    updatedBy = json['updatedBy'];
    active = json['active'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created'] = this.created;
    data['createdBy'] = this.createdBy;
    data['updated'] = this.updated;
    data['updatedBy'] = this.updatedBy;
    data['active'] = this.active;
    data['name'] = this.name;
    return data;
  }
}

class FueltypeNew {
  int? id;
  String? created;
  String? createdBy;
  bool? active;
  String? name;

  FueltypeNew({this.id, this.created, this.createdBy, this.active, this.name});

  FueltypeNew.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    created = json['created'];
    createdBy = json['createdBy'];
    active = json['active'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created'] = this.created;
    data['createdBy'] = this.createdBy;
    data['active'] = this.active;
    data['name'] = this.name;
    return data;
  }
}
