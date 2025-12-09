import 'package:carcheks/model/garage_model.dart';
import 'package:carcheks/model/services.dart';

class EmergencyGarageServicesModel {
  EmergencyGarageServicesModel({
    required this.message,
    required this.data,
    required this.success,
  });
  late final String message;
  late final List<EmergencyGarageServices> data;
  late final bool success;

  EmergencyGarageServicesModel.fromJson(Map<String, dynamic> json){
    message = json['message'];
    data = List.from(json['data']).map((e)=>EmergencyGarageServices.fromJson(e)).toList();
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

class EmergencyGarageServices {
  EmergencyGarageServices({
    required this.id,
    required this.created,
    required this.createdBy,
    required this.updated,
    required this.updatedBy,
    required this.active,
    required this.garrageid,
    required this.serviceId,
    required this.cost,
    required this.description,
    required this.shortDescription,
    required this.photosUrl,
  });
  late final int id;
  late final String created;
  late final String createdBy;
  late final String updated;
  late final String updatedBy;
  late final bool active;
  late final Garage garrageid;
  late final MainService serviceId;
  late final int cost;
  late final String description;
  late final String shortDescription;
  late final String photosUrl;

  EmergencyGarageServices.fromJson(Map<String, dynamic> json){
    id = json['id']??0;
    created = json['created']??'';
    createdBy = json['createdBy']??'';
    updated = json['updated']??'';
    updatedBy = json['updatedBy']??'';
    active = json['active']??true;
    garrageid = Garage.fromJson(json['garrageid']);
    serviceId = MainService.fromJson(json['service_id']);
    cost = json['cost']??0;
    description = json['description']??'';
    shortDescription = json['shortDescription']??'';
    photosUrl = json['photosUrl']??"";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['created'] = created;
    _data['createdBy'] = createdBy;
    _data['updated'] = updated;
    _data['updatedBy'] = updatedBy;
    _data['active'] = active;
    _data['garrageid'] = garrageid.toJson();
    _data['service_id'] = serviceId.toJson();
    _data['cost'] = cost;
    _data['description'] = description;
    _data['shortDescription'] = shortDescription;
    _data['photosUrl'] = photosUrl;
    return _data;
  }
}

