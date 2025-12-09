import 'package:carcheks/model/emergency_garage_services_model.dart';
import 'package:carcheks/model/user_order_model.dart';

class EmergencyUserOrderServicesModel {
  EmergencyUserOrderServicesModel({
    required this.message,
    required this.data,
    required this.success,
  });
  late final String message;
  late final List<EmergencyUserOrderServices> data;
  late final bool success;

  EmergencyUserOrderServicesModel.fromJson(Map<String, dynamic> json){
    message = json['message'];
    data = List.from(json['data']).map((e)=>EmergencyUserOrderServices.fromJson(e)).toList();
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

class EmergencyUserOrderServices {
  EmergencyUserOrderServices({
    required this.id,
    required this.created,
    required this.createdBy,
    required this.updated,
    required this.updatedBy,
    required this.active,
    required this.userOrder,
    required this.emergencyGarrageServices,
  });
  late final int id;
  late final String created;
  late final String createdBy;
  late final String updated;
  late final String updatedBy;
  late final bool active;
  late final UserOrder userOrder;
  late final EmergencyGarageServicesModel emergencyGarrageServices;

  EmergencyUserOrderServices.fromJson(Map<String, dynamic> json){
    id = json['id']??0;
    created = json['created']??'';
    createdBy = json['createdBy']??'';
    updated = json['updated']??'';
    updatedBy = json['updatedBy']??'';
    active = json['active']??true;
    userOrder = UserOrder.fromJson(json['userOrder']);
    emergencyGarrageServices = EmergencyGarageServicesModel.fromJson(json['emergencyGarrageServices']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['created'] = created;
    _data['createdBy'] = createdBy;
    _data['updated'] = updated;
    _data['updatedBy'] = updatedBy;
    _data['active'] = active;
    _data['userOrder'] = userOrder.toJson();
    _data['emergencyGarrageServices'] = emergencyGarrageServices.toJson();
    return _data;
  }
}

