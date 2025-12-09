class VehicleTypeModel {
  VehicleTypeModel({
    required this.message,
    required this.data,
    required this.success,
  });
  late final String message;
  late final List<Vehicletype> data;
  late final bool success;

  VehicleTypeModel.fromJson(Map<String, dynamic> json){
    message = json['message'];
    data = List.from(json['data']).map((e)=>Vehicletype.fromJson(e)).toList();
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
class Vehicletype {
  int? id;
  String? created;
  String? createdBy;
  bool? active;
  String? name;

  Vehicletype({this.id, this.created, this.createdBy, this.active, this.name});

  Vehicletype.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    created = json['created'];
    createdBy = json['createdBy'];
    active = json['active'];
    name = json['name']??'';
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