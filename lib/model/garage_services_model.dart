import 'package:carcheks/model/fuel_type_model.dart';
import 'package:carcheks/model/garage_model.dart';
import 'package:carcheks/model/services.dart';
import 'package:carcheks/model/subservices_model.dart';
import 'package:carcheks/model/vehicle_type_model.dart';

import 'address_model.dart';
import 'user_table_model.dart';


class GarageServiceModel {
  GarageServiceModel({
    required this.message,
    required this.data,
    required this.success,
  });
  late final String message;
  late final List<GarageService> data;
  late final bool success;

  GarageServiceModel.fromJson(Map<String, dynamic> json){
    message = json['message'];
    if (json['data'] != null) {
      data = <GarageService>[];
      json['data'].forEach((v) {
        data.add(new GarageService.fromJson(v));
      });
    }
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = new Map<String, dynamic>();
    _data['message'] = message;
    if (this.data != null) {
      _data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    _data['success'] = success;
    return _data;
  }
}

class GarageService {
  GarageService({
    required this.id,
    required this.created,
    required this.createdBy,
    required this.updated,
    required this.updatedBy,
    required this.active,
    required this.garageId,
    required this.subServiceId,
    required this.fuelTypeGs,
    required this.vechicletypeid,
    required this.cost,
    required this.discribtion,
    required this.shortDiscribtion,
    required this.photosUrl,
  });
  late final int id;
  late final String created;
  late final String createdBy;
  late final String updated;
  late final String updatedBy;
  late final bool active;
  late final int garageId;
  late final int userId;
  late final int serviceId;
  late final int subServiceId;
  late final int addressId;
  late final FuelType? fuelTypeGs;
  late final Vehicletype? vechicletypeid;
  late final MainService? mainService;
  late final SubService? subService;
  late final User? user;
  late final Garage? garage;
  late final AddressClass? address;
  late final int cost;
  late final String discribtion;
  late final String shortDiscribtion;
  late final String photosUrl;
  bool isServiceSelected=false;


  GarageService.fromJson(Map<String, dynamic> json){
    id = json['id']??0;
    created = json['created']??'';
    createdBy = json['createdBy']??'';
    updated = json['updated']??'';
    updatedBy = json['updatedBy']??'';
    active = json['active']??true;
    garageId = json['garageId']??0;
    //userId = json['usertableId'];
   // serviceId = json['serviceId'];
   // subServiceId = json['subServiceId'];
    //addressId = json['addressId'];
   // fuelTypeGs = FuelType.fromJson(json['fuelTypeGs']);
    vechicletypeid = (json['vechicletypeid'] != null
        ? new Vehicletype.fromJson(json['vechicletypeid'])
        : null);
    cost = json['cost']??0;
    discribtion = json['description']??'';
    shortDiscribtion = json['short_discribtion']??'';
    photosUrl = json['photos_url']??'';
    subService = (json['subservice'] != null
        ? new SubService.fromJson(json['subservice'])
        : null);
    address =
    (json['address'] != null ? new AddressClass.fromJson(json['address']) : null);
    mainService = (json['services'] != null
        ? new MainService.fromJson(json['services'])
        : null);
    user = (json['userTable'] != null
        ? new User.fromJson(json['userTable'])
        : null);
    garage = (json['garage'] != null
        ? new Garage.fromJson(json['garage'])
        : null);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['created'] = created;
    _data['createdBy'] = createdBy;
    _data['updated'] = updated;
    _data['updatedBy'] = updatedBy;
    _data['active'] = active;
    _data['garageId'] = garageId;
    //_data['usertableId'] = this.userId;
    //_data['addressId'] = this.addressId;
    //_data['serviceId'] = this.serviceId;
    //_data['subServiceId'] = subServiceId;
  //  _data['fuelTypeGs'] = fuelTypeGs.toJson();
   // _data['vechicletypeid'] = vechicletypeid.toJson();
    _data['cost'] = cost;
    _data['discribtion'] = discribtion;
    _data['short_discribtion'] = shortDiscribtion;
    _data['photos_url'] = photosUrl;
    if (this.subService != null) {
      _data['subservice'] = this.subService!.toJson();
    }
    if (this.address != null) {
      _data['address'] = this.address!.toJson();
    }
    if (this.mainService != null) {
      _data['services'] = this.mainService!.toJson();
    }
    if (this.user != null) {
      _data['userTable'] = this.user!.toJson();
    }
    if (this.garage != null) {
      _data['garage'] = this.garage!.toJson();
    }
    return _data;
  }
}

