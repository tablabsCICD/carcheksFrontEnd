import 'package:carcheks/model/subservices_model.dart';
import 'package:carcheks/model/user_order_model.dart';

class BiddingUserOrderService {
  BiddingUserOrderService({
    required this.id,
    required this.created,
    required this.createdBy,
    required this.updated,
    required this.updatedBy,
    required this.active,
    required this.userOrder,
    required this.subservice,
  });
  late final int id;
  late final String created;
  late final String createdBy;
  late final String updated;
  late final String updatedBy;
  late final bool active;
  late final UserOrder userOrder;
  late final SubService subservice;

  BiddingUserOrderService.fromJson(Map<String, dynamic> json){
    id = json['id']??0;
    created = json['created']??'';
    createdBy = json['createdBy']??'';
    updated = json['updated']??'';
    updatedBy = json['updatedBy']??"";
    active = json['active']??true;
    userOrder = UserOrder.fromJson(json['userOrder']);
    subservice = SubService.fromJson(json['subservice']);
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
    _data['subservice'] = subservice.toJson();
    return _data;
  }
}

