import 'package:carcheks/model/garage_services_model.dart';
import 'package:carcheks/model/user_order_model.dart';

class AppointmentModel {
  String? message;
  List<AppointmentData>? data;
  bool? success;

  AppointmentModel({this.message, this.data, this.success});

  AppointmentModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <AppointmentData>[];
      json['data'].forEach((v) {
        data!.add(new AppointmentData.fromJson(v));
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

class AppointmentData {
  int? id;
  String? date;
  String? time;
  String? status;
  String? availableTime;
  bool? active;
  bool? accept;
  UserOrder? userOrderId;
  GarageService? garageServices;
  int? garageServicesId;
  String? userAddress;
  PaypalOrderId? paypalOrderId;
  UserOrder? userOrder;

  AppointmentData(
      {this.id,
        this.date,
        this.time,
        this.status,
        this.availableTime,
        this.active,
        this.accept,
        this.userOrderId,
        this.garageServices,
        this.garageServicesId,
        this.userAddress,
        this.paypalOrderId,
        this.userOrder});

  AppointmentData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date']??'';
    time = json['time']??'';
    status = json['status']??'';
    availableTime = json['availableTime']??'';
    active = json['active'];
    accept = json['accept'];
    userOrderId = json['userOrderId'] != null
        ? new UserOrder.fromJson(json['userOrderId'])
        : null;
    garageServices = json['garageServices'] != null
        ? new GarageService.fromJson(json['garageServices'])
        : null;
    garageServicesId = json['garageServicesId']??0;
    userAddress = json['userAddress']??'';
    paypalOrderId = json['paypalOrderId'] != null
        ? new PaypalOrderId.fromJson(json['paypalOrderId'])
        : null;
    userOrder = json['userOrder'] != null
        ? new UserOrder.fromJson(json['userOrder'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date'] = this.date;
    data['time'] = this.time;
    data['status'] = this.status;
    data['availableTime'] = this.availableTime;
    data['active'] = this.active;
    data['accept'] = this.accept;
    if (this.userOrderId != null) {
      data['userOrderId'] = this.userOrderId!.toJson();
    }
    if (this.garageServices != null) {
      data['garageServices'] = this.garageServices!.toJson();
    }
    data['garageServicesId'] = this.garageServicesId;
    data['userAddress'] = this.userAddress;
    if (this.paypalOrderId != null) {
      data['paypalOrderId'] = this.paypalOrderId!.toJson();
    }
    if (this.userOrder != null) {
      data['userOrder'] = this.userOrder!.toJson();
    }
    return data;
  }
}


class PaypalOrderId {
  int? id;
  String? orderId;
  String? status;
  double? price;
  String? description;
  String? currency;
  String? method;
  String? intent;
  int? createdTimestamp;
  String? response;
  String? transactionId;
  int? garageId;
  int? date;
  Null? invoiceNumber;

  PaypalOrderId(
      {this.id,
        this.orderId,
        this.status,
        this.price,
        this.description,
        this.currency,
        this.method,
        this.intent,
        this.createdTimestamp,
        this.response,
        this.transactionId,
        this.garageId,
        this.date,
        this.invoiceNumber});

  PaypalOrderId.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['orderId'];
    status = json['status'];
    price = json['price'];
    description = json['description'];
    currency = json['currency'];
    method = json['method'];
    intent = json['intent'];
    createdTimestamp = json['createdTimestamp'];
    response = json['response'];
    transactionId = json['transactionId'];
    garageId = json['garageId'];
    date = json['date'];
    invoiceNumber = json['invoiceNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['orderId'] = this.orderId;
    data['status'] = this.status;
    data['price'] = this.price;
    data['description'] = this.description;
    data['currency'] = this.currency;
    data['method'] = this.method;
    data['intent'] = this.intent;
    data['createdTimestamp'] = this.createdTimestamp;
    data['response'] = this.response;
    data['transactionId'] = this.transactionId;
    data['garageId'] = this.garageId;
    data['date'] = this.date;
    data['invoiceNumber'] = this.invoiceNumber;
    return data;
  }
}




/*
class AppointmentModel {
  String? message;
  List<AppointmentData>? data;
  bool? success;

  AppointmentModel({this.message, this.data, this.success});

  AppointmentModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <AppointmentData>[];
      json['data'].forEach((v) {
        data!.add(new AppointmentData.fromJson(v));
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

class AppointmentData {
  int? id;
  String? date;
  String? time;
  String? status;
  String? availableTime;
  bool? active;
  bool? accept;
  UserOrderId? userOrderId;
  //int? orderId;
  GarageServices? garageServices;
  int? garageServicesId;
  UserOrderId? userOrder;

  AppointmentData(
      {this.id,
        this.date,
        this.time,
        this.status,
        this.availableTime,
        this.active,
        this.accept,
        this.userOrderId,
       // this.orderId,
        this.garageServices,
        this.garageServicesId,
        this.userOrder});

  AppointmentData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    time = json['time'];
    status = json['status'];
    availableTime = json['availableTime'];
    active = json['active'];
    accept = json['accept'];
    userOrderId = json['userOrderId'] != null
        ? new UserOrderId.fromJson(json['userOrderId'])
        : null;
   // orderId = json['orderId'];
    garageServices = json['garageServices'] != null
        ? new GarageServices.fromJson(json['garageServices'])
        : null;
    garageServicesId = json['garageServicesId'];
    userOrder = json['userOrder'] != null
        ? new UserOrderId.fromJson(json['userOrder'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date'] = this.date;
    data['time'] = this.time;
    data['status'] = this.status;
    data['availableTime'] = this.availableTime;
    data['active'] = this.active;
    data['accept'] = this.accept;
    if (this.userOrderId != null) {
      data['userOrderId'] = this.userOrderId!.toJson();
    }
    //data['orderId'] = this.orderId;
    if (this.garageServices != null) {
      data['garageServices'] = this.garageServices!.toJson();
    }
    data['garageServicesId'] = this.garageServicesId;
    if (this.userOrder != null) {
      data['userOrder'] = this.userOrder!.toJson();
    }
    return data;
  }
}

class UserOrderId {
  int? id;
  String? created;
  String? createdBy;
  //String? updated;
  String? updatedBy;
  bool? active;
  UserTable? userTable;
  User? usertableId;
  Vehicle? vehicle;
  String? vechicleId;
  int? totalAmout;
  String? status;
  String? invoiceNumber;
  bool? isBid;

  UserOrderId(
      {this.id,
        this.created,
        this.createdBy,
      //  this.updated,
        this.updatedBy,
        this.active,
        this.userTable,
        this.usertableId,
        this.vehicle,
        this.vechicleId,
        this.totalAmout,
        this.status,
        this.invoiceNumber,
        this.isBid});

  UserOrderId.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    created = json['created'];
    createdBy = json['createdBy'];
 //   updated = json['updated'];
    updatedBy = json['updatedBy'];
    active = json['active'];
    userTable = json['userTable'] != null
        ? new UserTable.fromJson(json['userTable'])
        : null;
    usertableId = json['usertableId'];
    //vehicle = json['vehicle']!=null ? Vehicle.fromJson(json['vehicle']):null;
    vechicleId = json['vechicleId'];
    totalAmout = json['total_amout'];
    status = json['status'];
    invoiceNumber = json['invoiceNumber'];
    isBid = json['isBid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created'] = this.created;
    data['createdBy'] = this.createdBy;
   // data['updated'] = this.updated;
    data['updatedBy'] = this.updatedBy;
    data['active'] = this.active;
    if (this.userTable != null) {
      data['userTable'] = this.userTable!.toJson();
    }
    data['usertableId'] = this.usertableId;
    data['vehicle'] = this.vehicle;
    data['vechicleId'] = this.vechicleId;
    data['total_amout'] = this.totalAmout;
    data['status'] = this.status;
    data['invoiceNumber'] = this.invoiceNumber;
    data['isBid'] = this.isBid;
    return data;
  }
}

class UserTable {
  int? id;
  String? firstName;
  String? lastName;
  String? emailid;
  String? mobilenumber;
  bool? verified;
  bool? paymentMode;
  bool? garrageOwner;
  String? operatingSystem;
  String? deviceId;
  String? imageUrl;
  String? password;
  String? created;
  String? createdBy;
//  String? updated;
  String? updatedBy;
  bool? active;
  String? otp;

  UserTable(
      {this.id,
        this.firstName,
        this.lastName,
        this.emailid,
        this.mobilenumber,
        this.verified,
        this.paymentMode,
        this.garrageOwner,
        this.operatingSystem,
        this.deviceId,
        this.imageUrl,
        this.password,
        this.created,
        this.createdBy,
      //  this.updated,
        this.updatedBy,
        this.active,
        this.otp});

  UserTable.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    emailid = json['emailid'];
    mobilenumber = json['mobilenumber'];
    verified = json['verified'];
    paymentMode = json['payment_mode'];
    garrageOwner = json['garrage_Owner'];
    operatingSystem = json['operating_system'];
    deviceId = json['device_id'];
    imageUrl = json['image_url'];
    password = json['password'];
    created = json['created'];
    createdBy = json['createdBy'];
    //updated = json['updated'];
    updatedBy = json['updatedBy'];
    active = json['active'];
    otp = json['otp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['emailid'] = this.emailid;
    data['mobilenumber'] = this.mobilenumber;
    data['verified'] = this.verified;
    data['payment_mode'] = this.paymentMode;
    data['garrage_Owner'] = this.garrageOwner;
    data['operating_system'] = this.operatingSystem;
    data['device_id'] = this.deviceId;
    data['image_url'] = this.imageUrl;
    data['password'] = this.password;
    data['created'] = this.created;
    data['createdBy'] = this.createdBy;
   // data['updated'] = this.updated;
    data['updatedBy'] = this.updatedBy;
    data['active'] = this.active;
    data['otp'] = this.otp;
    return data;
  }
}

class GarageServices {
  int? id;
  String? created;
  String? createdBy;
//  String? updated;
  String? updatedBy;
  bool? active;
  int? cost;
  String? description;
  String? photosUrl;
  String? shortDiscribtion;
  FuelTypeGs? fuelTypeGs;
  Services? services;
  int? serviceId;
  Subservice? subservice;
  int? subServiceId;
  FuelTypeGs? vechicletypeid;
  int? vehicleTypeId;
  UserTable? userTable;
  int? usertableId;
  Garage? garage;
  int? garageId;
  int? fuelTypeId;

  GarageServices(
      {this.id,
        this.created,
        this.createdBy,
      //  this.updated,
        this.updatedBy,
        this.active,
        this.cost,
        this.description,
        this.photosUrl,
        this.shortDiscribtion,
        this.fuelTypeGs,
        this.services,
        this.serviceId,
        this.subservice,
        this.subServiceId,
        this.vechicletypeid,
        this.vehicleTypeId,
        this.userTable,
        this.usertableId,
        this.garage,
        this.garageId,
        this.fuelTypeId});

  GarageServices.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    created = json['created'];
    createdBy = json['createdBy'];
   // updated = json['updated'];
    updatedBy = json['updatedBy'];
    active = json['active'];
    cost = json['cost'];
    description = json['description'];
    photosUrl = json['photos_url'];
    shortDiscribtion = json['short_discribtion'];
    fuelTypeGs = json['fuelTypeGs'] != null
        ? new FuelTypeGs.fromJson(json['fuelTypeGs'])
        : null;
    services = json['services'] != null
        ? new Services.fromJson(json['services'])
        : null;
    serviceId = json['serviceId'];
    subservice = json['subservice'] != null
        ? new Subservice.fromJson(json['subservice'])
        : null;
    subServiceId = json['subServiceId'];
    vechicletypeid = json['vechicletypeid'] != null
        ? new FuelTypeGs.fromJson(json['vechicletypeid'])
        : null;
    vehicleTypeId = json['vehicleTypeId'];
    userTable = json['userTable'] != null
        ? new UserTable.fromJson(json['userTable'])
        : null;
    usertableId = json['usertableId'];
    garage =
    json['garage'] != null ? new Garage.fromJson(json['garage']) : null;
    garageId = json['garageId'];
    fuelTypeId = json['fuelTypeId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created'] = this.created;
    data['createdBy'] = this.createdBy;
   // data['updated'] = this.updated;
    data['updatedBy'] = this.updatedBy;
    data['active'] = this.active;
    data['cost'] = this.cost;
    data['description'] = this.description;
    data['photos_url'] = this.photosUrl;
    data['short_discribtion'] = this.shortDiscribtion;
    if (this.fuelTypeGs != null) {
      data['fuelTypeGs'] = this.fuelTypeGs!.toJson();
    }
    if (this.services != null) {
      data['services'] = this.services!.toJson();
    }
    data['serviceId'] = this.serviceId;
    if (this.subservice != null) {
      data['subservice'] = this.subservice!.toJson();
    }
    data['subServiceId'] = this.subServiceId;
    if (this.vechicletypeid != null) {
      data['vechicletypeid'] = this.vechicletypeid!.toJson();
    }
    data['vehicleTypeId'] = this.vehicleTypeId;
    if (this.userTable != null) {
      data['userTable'] = this.userTable!.toJson();
    }
    data['usertableId'] = this.usertableId;
    if (this.garage != null) {
      data['garage'] = this.garage!.toJson();
    }
    data['garageId'] = this.garageId;
    data['fuelTypeId'] = this.fuelTypeId;
    return data;
  }
}

class FuelTypeGs {
  int? id;
  String? created;
  String? createdBy;
  bool? active;
  String? name;

  FuelTypeGs({this.id, this.created, this.createdBy, this.active, this.name});

  FuelTypeGs.fromJson(Map<String, dynamic> json) {
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

class Services {
  int? id;
  String? created;
  String? createdBy;
 // String? updated;
  String? updatedBy;
  bool? active;
  String? name;
  String? description;
  String? shortDiscribtion;
  String? photosUrl;
  String? timeRequiredToComplete;
  String? serviceWarranty;
  String? defaultCosting;

  Services(
      {this.id,
        this.created,
        this.createdBy,
       // this.updated,
        this.updatedBy,
        this.active,
        this.name,
        this.description,
        this.shortDiscribtion,
        this.photosUrl,
        this.timeRequiredToComplete,
        this.serviceWarranty,
        this.defaultCosting});

  Services.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    created = json['created'];
    createdBy = json['createdBy'];
    //updated = json['updated'];
    updatedBy = json['updatedBy'];
    active = json['active'];
    name = json['name'];
    description = json['description'];
    shortDiscribtion = json['short_discribtion'];
    photosUrl = json['photos_url'];
    timeRequiredToComplete = json['timeRequiredToComplete'];
    serviceWarranty = json['serviceWarranty'];
    defaultCosting = json['defaultCosting'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created'] = this.created;
    data['createdBy'] = this.createdBy;
   // data['updated'] = this.updated;
    data['updatedBy'] = this.updatedBy;
    data['active'] = this.active;
    data['name'] = this.name;
    data['description'] = this.description;
    data['short_discribtion'] = this.shortDiscribtion;
    data['photos_url'] = this.photosUrl;
    data['timeRequiredToComplete'] = this.timeRequiredToComplete;
    data['serviceWarranty'] = this.serviceWarranty;
    data['defaultCosting'] = this.defaultCosting;
    return data;
  }
}

class Subservice {
  int? id;
  String? created;
  String? createdBy;
  //String? updated;
  String? updatedBy;
  bool? active;
  String? name;
  Services? services;
  int? serviceId;
  String? description;
  String? shortDiscribtion;
  String? photosUrl;
  String? costing;

  Subservice(
      {this.id,
        this.created,
        this.createdBy,
      //  this.updated,
        this.updatedBy,
        this.active,
        this.name,
        this.services,
        this.serviceId,
        this.description,
        this.shortDiscribtion,
        this.photosUrl,
        this.costing});

  Subservice.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    created = json['created'];
    createdBy = json['createdBy'];
   // updated = json['updated'];
    updatedBy = json['updatedBy'];
    active = json['active'];
    name = json['name'];
    services = json['services'] != null
        ? new Services.fromJson(json['services'])
        : null;
    serviceId = json['serviceId'];
    description = json['description'];
    shortDiscribtion = json['short_discribtion'];
    photosUrl = json['photos_url'];
    costing = json['costing'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created'] = this.created;
    data['createdBy'] = this.createdBy;
   // data['updated'] = this.updated;
    data['updatedBy'] = this.updatedBy;
    data['active'] = this.active;
    data['name'] = this.name;
    if (this.services != null) {
      data['services'] = this.services!.toJson();
    }
    data['serviceId'] = this.serviceId;
    data['description'] = this.description;
    data['short_discribtion'] = this.shortDiscribtion;
    data['photos_url'] = this.photosUrl;
    data['costing'] = this.costing;
    return data;
  }
}

class Garage {
  int? id;
  String? created;
  String? createdBy;
//  String? updated;
  String? updatedBy;
  bool? active;
  String? name;
  String? emailId;
  String? contactNumber;
  String? imageUrl;
  String? photos1;
  String? photos2;
  String? photos3;
  UserTable? userTable;
  int? usertableId;
  AddressDtls? addressDtls;
  int? addressId;
  bool? verified;
  String? verificatiionId;
  String? websiteUrl;
  String? password;
  String? openingTime;
  String? closingTime;
  String? latitude;
  String? longitude;
  double? rating;
  int? noOfRating;
  String? discription;
  bool? populer;

  Garage(
      {this.id,
        this.created,
        this.createdBy,
       // this.updated,
        this.updatedBy,
        this.active,
        this.name,
        this.emailId,
        this.contactNumber,
        this.imageUrl,
        this.photos1,
        this.photos2,
        this.photos3,
        this.userTable,
        this.usertableId,
        this.addressDtls,
        this.addressId,
        this.verified,
        this.verificatiionId,
        this.websiteUrl,
        this.password,
        this.openingTime,
        this.closingTime,
        this.latitude,
        this.longitude,
        this.rating,
        this.noOfRating,
        this.discription,
        this.populer});

  Garage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    created = json['created'];
    createdBy = json['createdBy'];
   // updated = json['updated'];
    updatedBy = json['updatedBy'];
    active = json['active'];
    name = json['name'];
    emailId = json['emailId'];
    contactNumber = json['contactNumber'];
    imageUrl = json['imageUrl'];
    photos1 = json['photos1'];
    photos2 = json['photos2'];
    photos3 = json['photos3'];
    userTable = json['userTable'] != null
        ? new UserTable.fromJson(json['userTable'])
        : null;
    usertableId = json['usertableId'];
    addressDtls = json['addressDtls'] != null
        ? new AddressDtls.fromJson(json['addressDtls'])
        : null;
    addressId = json['addressId'];
    verified = json['verified'];
    verificatiionId = json['verificatiionId'];
    websiteUrl = json['websiteUrl'];
    password = json['password'];
    openingTime = json['openingTime'];
    closingTime = json['closingTime'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    rating = json['rating'];
    noOfRating = json['noOfRating'];
    discription = json['discription'];
    populer = json['populer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created'] = this.created;
    data['createdBy'] = this.createdBy;
  //  data['updated'] = this.updated;
    data['updatedBy'] = this.updatedBy;
    data['active'] = this.active;
    data['name'] = this.name;
    data['emailId'] = this.emailId;
    data['contactNumber'] = this.contactNumber;
    data['imageUrl'] = this.imageUrl;
    data['photos1'] = this.photos1;
    data['photos2'] = this.photos2;
    data['photos3'] = this.photos3;
    if (this.userTable != null) {
      data['userTable'] = this.userTable!.toJson();
    }
    data['usertableId'] = this.usertableId;
    if (this.addressDtls != null) {
      data['addressDtls'] = this.addressDtls!.toJson();
    }
    data['addressId'] = this.addressId;
    data['verified'] = this.verified;
    data['verificatiionId'] = this.verificatiionId;
    data['websiteUrl'] = this.websiteUrl;
    data['password'] = this.password;
    data['openingTime'] = this.openingTime;
    data['closingTime'] = this.closingTime;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['rating'] = this.rating;
    data['noOfRating'] = this.noOfRating;
    data['discription'] = this.discription;
    data['populer'] = this.populer;
    return data;
  }
}

class AddressDtls {
  int? id;
  String? created;
  String? createdBy;
 // String? updated;
  String? updatedBy;
  bool? active;
  String? houseName;
  String? street;
  int? userId;
  String? cityname;
  String? state;
  String? country;
  String? zipCode;
  String? landmark;
  double? latitude;
  double? longitude;
  bool? garrageAddress;

  AddressDtls(
      {this.id,
        this.created,
        this.createdBy,
       // this.updated,
        this.updatedBy,
        this.active,
        this.houseName,
        this.street,
        this.userId,
        this.cityname,
        this.state,
        this.country,
        this.zipCode,
        this.landmark,
        this.latitude,
        this.longitude,
        this.garrageAddress});

  AddressDtls.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    created = json['created'];
    createdBy = json['createdBy'];
  //  updated = json['updated'];
    updatedBy = json['updatedBy'];
    active = json['active'];
    houseName = json['houseName'];
    street = json['street'];
    userId = json['userId'];
    cityname = json['cityname'];
    state = json['state'];
    country = json['country'];
    zipCode = json['zipCode'];
    landmark = json['landmark'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    garrageAddress = json['garrageAddress'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created'] = this.created;
    data['createdBy'] = this.createdBy;
   // data['updated'] = this.updated;
    data['updatedBy'] = this.updatedBy;
    data['active'] = this.active;
    data['houseName'] = this.houseName;
    data['street'] = this.street;
    data['userId'] = this.userId;
    data['cityname'] = this.cityname;
    data['state'] = this.state;
    data['country'] = this.country;
    data['zipCode'] = this.zipCode;
    data['landmark'] = this.landmark;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['garrageAddress'] = this.garrageAddress;
    return data;
  }
}
*/
