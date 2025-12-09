import 'package:carcheks/model/address_model.dart';
import 'package:carcheks/model/garage_model.dart';

class UserResponse {
  String? message;
  UserDetails? data;
  bool? success;

  UserResponse({this.message, this.data, this.success});

  UserResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new UserDetails.fromJson(json['data']) : null;
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

class UserDetails {
  User? userData;
  AddressClass? addressData;
  Garage? garrageData;

  UserDetails({required this.userData, this.addressData, this.garrageData});

  UserDetails.fromJson(Map<String, dynamic> json) {
    userData = json['userData'] != null
        ? new User.fromJson(json['userData'])
        : null;
    addressData = json['addressData'] != null
        ? new AddressClass.fromJson(json['addressData'])
        : null;
    garrageData = json['garrageData'] != null
        ? new Garage.fromJson(json['garrageData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.userData != null) {
      data['userData'] = this.userData!.toJson();
    }
    if (this.addressData != null) {
      data['addressData'] = this.addressData!.toJson();
    }
    if (this.garrageData != null) {
      data['garrageData'] = this.garrageData!.toJson();
    }
    return data;
  }
}

class User {
  User({
    required this.id,
    required this.userorderDtls,
    required this.firstName,
    required this.lastName,
    required this.emailid,
    required this.mobilenumber,
    required this.verified,
    required this.paymentMode,
    required this.garrageOwner,
    required this.created,
    required this.createdBy,
    required this.updated,
    required this.updatedBy,
    required this.active,
    required this.operatingSystem,
    required this.deviceId,
    required this.imageUrl,
    required this.password,
    required this.otp,
  });
  late final int id;
  late final List<dynamic> userorderDtls;
  late final String firstName;
  late final String lastName;
  late final String emailid;
  late final String mobilenumber;
  late final bool verified;
  late final bool paymentMode;
  late final bool garrageOwner;
  late final String created;
  late final String createdBy;
  late final String updated;
  late final String updatedBy;
  late final bool active;
  late final String operatingSystem;
  late final String deviceId;
  late final String imageUrl;
  late final String password;
  late final String otp;

  User.fromJson(Map<String, dynamic> json){
    id = json['id']??0;
   // userorderDtls = List.castFrom<dynamic, dynamic>(json['userorder_dtls'])??[];
    firstName = json['firstName']??'';
    lastName = json['lastName']??'';
    emailid = json['emailid']??'';
    mobilenumber = json['mobilenumber']??'';
    verified = json['verified']??true;
    paymentMode = json['payment_mode']??true;
    garrageOwner = json['garrage_Owner']??true;
    created = json['created']??'';
    createdBy = json['createdBy']??'';
    updated = json['updated']??'';
    updatedBy = json['updatedBy']??'';
    active = json['active']??true;
    operatingSystem = json['operating_system']??'';
    deviceId = json['device_id']??'';
    imageUrl = json['image_url']??'';
    password = json['password']??'';
    otp = json['otp']??'';
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['userorder_dtls'] = userorderDtls;
    _data['firstName'] = firstName;
    _data['lastName'] = lastName;
    _data['emailid'] = emailid;
    _data['mobilenumber'] = mobilenumber;
    _data['verified'] = verified;
    _data['payment_mode'] = paymentMode;
    _data['garrage_Owner'] = garrageOwner;
    _data['created'] = created;
    _data['createdBy'] = createdBy;
    _data['updated'] = updated;
    _data['updatedBy'] = updatedBy;
    _data['active'] = active;
    _data['operating_system'] = operatingSystem;
    _data['device_id'] = deviceId;
    _data['image_url'] = imageUrl;
    _data['password'] = password;
    _data['otp'] = otp;
    return _data;
  }
}

