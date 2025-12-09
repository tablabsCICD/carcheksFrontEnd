import 'package:carcheks/model/garage_model.dart';

class BidingModel {
  BidingModel({
    required this.message,
    required this.data,
    required this.success,
  });
  late final String message;
  late final List<Bid> data;
  late final bool success;

  BidingModel.fromJson(Map<String, dynamic> json){
    message = json['message'];
    data = List.from(json['data']).map((e)=>Bid.fromJson(e)).toList();
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

class Bid {
  Bid({
    required this.id,
    required this.created,
    required this.createdBy,
    required this.updated,
    required this.updatedBy,
    required this.active,
    required this.status,
    required this.amount,
    required this.garrage,
  });
  late final int id;
  late final String created;
  late final String createdBy;
  late final String updated;
  late final String updatedBy;
  late final bool active;
  late final String status;
  late final int amount;
  late final Garage garrage;

  Bid.fromJson(Map<String, dynamic> json){
    id = json['id']??0;
    created = json['created']??'';
    createdBy = json['createdBy']??'';
    updated = json['updated']??'';
    updatedBy = json['updatedBy']??'';
    active = json['active']??true;
    status = json['status']??'';
    amount = json['amount']??0;
    garrage = Garage.fromJson(json['garrage']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['created'] = created;
    _data['createdBy'] = createdBy;
    _data['updated'] = updated;
    _data['updatedBy'] = updatedBy;
    _data['active'] = active;
    _data['status'] = status;
    _data['amount'] = amount;
    _data['garrage'] = garrage.toJson();
    return _data;
  }
}

