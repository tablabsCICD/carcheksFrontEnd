import 'package:carcheks/model/garage_model.dart';
import 'package:carcheks/model/services.dart';

class OfferModel {
  OfferModel({
    required this.message,
    required this.data,
    required this.success,
  });
  late final String message;
  late final List<Offer> data;
  late final bool success;

  OfferModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <Offer>[];
      json['data'].forEach((v) {
        data.add(new Offer.fromJson(v));
      });
    }
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['success'] = this.success;
    return data;
  }
}

class Offer {
  Offer({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.startDate,
    required this.endDate,
    required this.couponCode,
    required this.discription,
    required this.services,
    required this.active,
  });
  late final int id;
  late final String name;
  late final String imageUrl;
  late final String startDate;
  late final String endDate;
  late final String couponCode;
  late final String discription;
  late final MainService? services;
  late final bool active;
  late final Garage? garrage;
  late final String pincode;

  Offer.fromJson(Map<String, dynamic> json){
    id = json['id']??0;
    name = json['name']??'';
    imageUrl = json['imageUrl']??'';
    startDate = json['startDate']??'';
    endDate = json['endDate']??'';
    couponCode = json['couponCode']??'';
    discription = json['discription']??'';
    garrage =
    json['garrage'] != null ? new Garage.fromJson(json['garrage']) : null;
    services =
    json['services'] != null ? new MainService.fromJson(json['services']) : null;

    pincode = json['pincode']??'';
    active = json['active']??true;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['imageUrl'] = imageUrl;
    _data['startDate'] = startDate;
    _data['endDate'] = endDate;
    _data['couponCode'] = couponCode;
    _data['discription'] = discription;
    _data['pincode'] = pincode;
    if (this.garrage != null) {
      _data['garrage'] = this.garrage!.toJson();
    };
    if (this.services != null) {
      _data['services'] = this.services!.toJson();
    }
    _data['active'] = active;
    return _data;
  }
}

