import 'address_model.dart';
import 'user_table_model.dart';

class GarageResponse {
  String? message;
  List<Garage>? data;
  bool? success;

  GarageResponse({required this.message, required this.data, required this.success});

  GarageResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <Garage>[];
      json['data'].forEach((v) {
        data!.add(new Garage.fromJson(v));
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

class GarageModel {
  GarageModel({
    required this.message,
    required this.data,
    required this.success,
  });
  late final String message;
  late final List<Garage>? data;
  late final bool success;

  GarageModel.fromJson(Map<String, dynamic> json){
    message = json['message'];
    if (json['data'] != null) {
      data = <Garage>[];
      json['data'].forEach((v) {
        data!.add(Garage.fromJson(v));
      });
    }
   // data = List.from(json['data']).map((e)=>Garage.fromJson(e)).toList();
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['message'] = message;
    if (this.data != null) {
      _data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
  //  _data['data'] = data!.map((e)=>e.toJson()).toList();
    _data['success'] = success;
    return _data;
  }
}

class Garage {
  Garage({
    required this.id,
    required this.created,
    required this.createdBy,
    required this.updated,
    required this.updatedBy,
    required this.active,
    required this.name,
    required this.emailId,
    required this.contactNumber,
    required this.location,
    required this.imageUrl,

    required this.userId,
    required this.addressId,
    required this.verified,
    required this.verificatiionId,
    required this.websiteUrl,
    required this.password,
    required this.openingTime,
    required this.closingTime,
    required this.latitude,
    required this.longitude,
    required this.rating,
    required this.noOfRating,
    required this.discription,
    required this.populer,
    required this.userTable,
    required this.addressDtls,

  });
  late final int id;
  late final String created;
  late final String createdBy;
  late final String updated;
  late final String updatedBy;
  late final bool active;
  late final String name;
  late final String emailId;
  late final String contactNumber;
  late final int location;
  late final String imageUrl;
  late final String photos1;
  late final String photos2;
  late final String photos3;
  late final int userId;
  late final int addressId;
  late final bool verified;
  late final String verificatiionId;
  late final String websiteUrl;
  late final String password;
  late final String openingTime;
  late final String closingTime;
  late final String latitude;
  late final String longitude;
  late final double rating;
  late final int noOfRating;
  late final String discription;
  late final bool populer;
  User? userTable;
  AddressClass? addressDtls;

  Garage.fromJson(Map<String, dynamic> json){
    id = json['id']??0;
    created = json['created']??'';
    createdBy = json['createdBy']??'';
    updated = json['updated']??'';
    updatedBy = json['updatedBy']??'';
    active = json['active']??true;
    name = json['name']??'';
    emailId = json['emailId']??'';
    contactNumber = json['contactNumber']??'';
    location = json['location']??0;
    imageUrl = json['imageUrl']??'';
    photos1 = json['photos1']??'';
    photos2 = json['photos2']??'';
    photos3 = json['photos3']??'';
    userId = json['usertableId']??0;
    addressId = json['addressId']??0;
    verified = json['verified']??true;
    verificatiionId = json['verificatiionId']??'';
    websiteUrl = json['websiteUrl']??'';
    password = json['password']??'';
    openingTime = json['openingTime']??'';
    closingTime = json['closingTime']??'';
    latitude = json['latitude']??'';
    longitude = json['longitude']??'';
    rating = json['rating']??5.0;
    noOfRating = json['noOfRating']??0;
    discription = json['discription']??'';
    populer = json['populer']??true;
    userTable = (json['userTable'] != null ? new User.fromJson(json['userTable']) : null);

    addressDtls = (json['addressDtls'] != null
        ? new AddressClass.fromJson(json['addressDtls'])
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
    _data['name'] = name;
    _data['emailId'] = emailId;
    _data['contactNumber'] = contactNumber;
    _data['location'] = location;
    _data['imageUrl'] = imageUrl;
    _data['photos1'] = photos1;
    _data['photos2'] = photos2;
    _data['photos3'] = photos3;
    _data['usertableId'] = userId;
    _data['addressId'] = addressId;
    _data['verified'] = verified;
    _data['verificatiionId'] = verificatiionId;
    _data['websiteUrl'] = websiteUrl;
    _data['password'] = password;
    _data['openingTime'] = openingTime;
    _data['closingTime'] = closingTime;
    _data['latitude'] = latitude;
    _data['longitude'] = longitude;
    _data['rating'] = rating;
    _data['noOfRating'] = noOfRating;
    _data['discription'] = discription;
    _data['populer'] = populer;
    if (this.userTable != null) {
      _data['userTable'] = this.userTable!.toJson();
    }
    if (this.addressDtls != null) {
      _data['addressDtls'] = this.addressDtls!.toJson();
    }
    return _data;
  }
}