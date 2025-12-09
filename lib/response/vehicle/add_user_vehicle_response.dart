import 'package:carcheks/model/user_vehicle_model.dart';

class AddUserVehicleResponse {
  AddUserVehicleResponse({
    required this.message,
    required this.data,
    required this.success,
  });
  late final String message;
  late final UserVehicle data;
  late final bool success;

  AddUserVehicleResponse.fromJson(Map<String, dynamic> json){
    message = json['message'];
    data = UserVehicle.fromJson(json['data']);
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['message'] = message;
    _data['data'] = data.toJson();
    _data['success'] = success;
    return _data;
  }
}

class Data {
  Data({
    required this.id,
    required this.created,
    required this.createdBy,
    required this.updated,
    required this.updatedBy,
    required this.active,
    required this.userTableId,
    required this.vehicleid,
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
  late final UserTableId userTableId;
  late final Vehicleid vehicleid;
  late final String vehicleNumber;
  late final String vehiclePhotos;
  late final String yearOfManufacturing;
  late final int kmRun;
  late final int average;
  late final int numberServicings;

  Data.fromJson(Map<String, dynamic> json){
    id = json['id'];
    created = json['created'];
    createdBy = json['createdBy'];
    updated = json['updated'];
    updatedBy = json['updatedBy'];
    active = json['active'];
    userTableId = UserTableId.fromJson(json['userTableId']);
    vehicleid = Vehicleid.fromJson(json['vehicleid']);
    vehicleNumber = json['vehicle_number'];
    vehiclePhotos = json['vehicle_photos'];
    yearOfManufacturing = json['yearOfManufacturing'];
    kmRun = json['kmRun'];
    average = json['average'];
    numberServicings = json['number_servicings'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['created'] = created;
    _data['createdBy'] = createdBy;
    _data['updated'] = updated;
    _data['updatedBy'] = updatedBy;
    _data['active'] = active;
    _data['userTableId'] = userTableId.toJson();
    _data['vehicleid'] = vehicleid.toJson();
    _data['vehicle_number'] = vehicleNumber;
    _data['vehicle_photos'] = vehiclePhotos;
    _data['yearOfManufacturing'] = yearOfManufacturing;
    _data['kmRun'] = kmRun;
    _data['average'] = average;
    _data['number_servicings'] = numberServicings;
    return _data;
  }
}

class UserTableId {
  UserTableId({
    required this.id,
    required this.vehicleDtls,
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
    required this.address,
    required this.operatingSystem,
    required this.deviceId,
    required this.imageUrl,
    required this.password,
    required this.otp,
  });
  late final int id;
  late final List<dynamic> vehicleDtls;
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
  late final Address address;
  late final String operatingSystem;
  late final String deviceId;
  late final String imageUrl;
  late final String password;
  late final String otp;

  UserTableId.fromJson(Map<String, dynamic> json){
    id = json['id'];
    vehicleDtls = List.castFrom<dynamic, dynamic>(json['vehicle_dtls']);
    firstName = json['firstName'];
    lastName = json['lastName'];
    emailid = json['emailid'];
    mobilenumber = json['mobilenumber'];
    verified = json['verified'];
    paymentMode = json['payment_mode'];
    garrageOwner = json['garrage_Owner'];
    created = json['created'];
    createdBy = json['createdBy'];
    updated = json['updated'];
    updatedBy = json['updatedBy'];
    active = json['active'];
    address = Address.fromJson(json['address']);
    operatingSystem = json['operating_system'];
    deviceId = json['device_id'];
    imageUrl = json['image_url'];
    password = json['password'];
    otp = json['otp'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['vehicle_dtls'] = vehicleDtls;
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
    _data['address'] = address.toJson();
    _data['operating_system'] = operatingSystem;
    _data['device_id'] = deviceId;
    _data['image_url'] = imageUrl;
    _data['password'] = password;
    _data['otp'] = otp;
    return _data;
  }
}

class Address {
  Address({
    required this.id,
    required this.created,
    required this.createdBy,
    required this.updated,
    required this.updatedBy,
    required this.active,
    required this.name,
    required this.street,
    required this.city,
    required this.zipCode,
    required this.landmark,
  });
  late final int id;
  late final String created;
  late final String createdBy;
  late final String updated;
  late final String updatedBy;
  late final bool active;
  late final String name;
  late final String street;
  late final City city;
  late final String zipCode;
  late final String landmark;

  Address.fromJson(Map<String, dynamic> json){
    id = json['id'];
    created = json['created'];
    createdBy = json['createdBy'];
    updated = json['updated'];
    updatedBy = json['updatedBy'];
    active = json['active'];
    name = json['name'];
    street = json['street'];
    city = City.fromJson(json['city']);
    zipCode = json['zipCode'];
    landmark = json['landmark'];
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
    _data['street'] = street;
    _data['city'] = city.toJson();
    _data['zipCode'] = zipCode;
    _data['landmark'] = landmark;
    return _data;
  }
}

class City {
  City({
    required this.id,
    required this.created,
    required this.createdBy,
    required this.active,
    required this.city,
    required this.state,
    required this.country,
  });
  late final int id;
  late final String created;
  late final String createdBy;
  late final bool active;
  late final String city;
  late final String state;
  late final String country;

  City.fromJson(Map<String, dynamic> json){
    id = json['id'];
    created = json['created'];
    createdBy = json['createdBy'];
    active = json['active'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['created'] = created;
    _data['createdBy'] = createdBy;
    _data['active'] = active;
    _data['city'] = city;
    _data['state'] = state;
    _data['country'] = country;
    return _data;
  }
}

class Vehicleid {
  Vehicleid({
    required this.id,
    this.userTable,
    required this.created,
    required this.createdBy,
    required this.updated,
    required this.updatedBy,
    required this.active,
    required this.vehicleManufacturer,
    required this.vehicleModel,
    required this.fueltype,
    required this.photosUrl,
    required this.vehicletype,
    required this.yearOfManufacturing,
    required this.registrationNo,
    required this.lastServiceDate,
    required this.name,
  });
  late final int id;
  late final Null userTable;
  late final String created;
  late final String createdBy;
  late final String updated;
  late final String updatedBy;
  late final bool active;
  late final VehicleManufacturer vehicleManufacturer;
  late final String vehicleModel;
  late final Fueltype fueltype;
  late final String photosUrl;
  late final Vehicletype vehicletype;
  late final String yearOfManufacturing;
  late final String registrationNo;
  late final String lastServiceDate;
  late final String name;

  Vehicleid.fromJson(Map<String, dynamic> json){
    id = json['id'];
    userTable = null;
    created = json['created'];
    createdBy = json['createdBy'];
    updated = json['updated'];
    updatedBy = json['updatedBy'];
    active = json['active'];
    vehicleManufacturer = VehicleManufacturer.fromJson(json['vehicleManufacturer']);
    vehicleModel = json['vehicle_model'];
    fueltype = Fueltype.fromJson(json['fueltype']);
    photosUrl = json['photos_url'];
    vehicletype = Vehicletype.fromJson(json['vehicletype']);
    yearOfManufacturing = json['year_of_manufacturing'];
    registrationNo = json['registrationNo'];
    lastServiceDate = json['lastServiceDate'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['userTable'] = userTable;
    _data['created'] = created;
    _data['createdBy'] = createdBy;
    _data['updated'] = updated;
    _data['updatedBy'] = updatedBy;
    _data['active'] = active;
    _data['vehicleManufacturer'] = vehicleManufacturer.toJson();
    _data['vehicle_model'] = vehicleModel;
    _data['fueltype'] = fueltype.toJson();
    _data['photos_url'] = photosUrl;
    _data['vehicletype'] = vehicletype.toJson();
    _data['year_of_manufacturing'] = yearOfManufacturing;
    _data['registrationNo'] = registrationNo;
    _data['lastServiceDate'] = lastServiceDate;
    _data['name'] = name;
    return _data;
  }
}

class VehicleManufacturer {
  VehicleManufacturer({
    required this.id,
    required this.created,
    required this.createdBy,
    required this.updated,
    required this.updatedBy,
    required this.active,
    required this.name,
  });
  late final int id;
  late final String created;
  late final String createdBy;
  late final String updated;
  late final String updatedBy;
  late final bool active;
  late final String name;

  VehicleManufacturer.fromJson(Map<String, dynamic> json){
    id = json['id'];
    created = json['created'];
    createdBy = json['createdBy'];
    updated = json['updated'];
    updatedBy = json['updatedBy'];
    active = json['active'];
    name = json['name'];
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
    return _data;
  }
}

class Fueltype {
  Fueltype({
    required this.id,
    required this.created,
    required this.createdBy,
    required this.active,
    required this.name,
  });
  late final int id;
  late final String created;
  late final String createdBy;
  late final bool active;
  late final String name;

  Fueltype.fromJson(Map<String, dynamic> json){
    id = json['id'];
    created = json['created'];
    createdBy = json['createdBy'];
    active = json['active'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['created'] = created;
    _data['createdBy'] = createdBy;
    _data['active'] = active;
    _data['name'] = name;
    return _data;
  }
}

class Vehicletype {
  Vehicletype({
    required this.id,
    required this.created,
    required this.createdBy,
    required this.active,
    required this.name,
  });
  late final int id;
  late final String created;
  late final String createdBy;
  late final bool active;
  late final String name;

  Vehicletype.fromJson(Map<String, dynamic> json){
    id = json['id'];
    created = json['created'];
    createdBy = json['createdBy'];
    active = json['active'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['created'] = created;
    _data['createdBy'] = createdBy;
    _data['active'] = active;
    _data['name'] = name;
    return _data;
  }
}