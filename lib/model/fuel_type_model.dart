
class FuelTypeModel {
  FuelTypeModel({
    required this.message,
    required this.data,
    required this.success,
  });
  late final String message;
  late final List<FuelType> data;
  late final bool success;

  FuelTypeModel.fromJson(Map<String, dynamic> json){
    message = json['message'];
    data = List.from(json['data']).map((e)=>FuelType.fromJson(e)).toList();
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

class FuelType {
  FuelType({
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

  FuelType.fromJson(Map<String, dynamic> json){
    id = json['id']??0;
    created = json['created']??'';
    createdBy = json['createdBy']??'';
    active = json['active']??true;
    name = json['name']??'';
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