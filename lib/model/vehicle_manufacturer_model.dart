class VehicleManufacturerModel {
  VehicleManufacturerModel({
    required this.message,
    required this.data,
    required this.success,
  });
  late final String message;
  late final List<VehicleManufacturer> data;
  late final bool success;

  VehicleManufacturerModel.fromJson(Map<String, dynamic> json){
    message = json['message'];
    data = List.from(json['data']).map((e)=>VehicleManufacturer.fromJson(e)).toList();
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

class VehicleManufacturer {
  int? id;
  String? created;
  String? createdBy;
  String? updated;
  String? updatedBy;
  bool? active;
  String? name;

  VehicleManufacturer(
      {this.id,
        this.created,
        this.createdBy,
        this.updated,
        this.updatedBy,
        this.active,
        this.name});

  VehicleManufacturer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    created = json['created'];
    createdBy = json['createdBy'];
    updated = json['updated'];
    updatedBy = json['updatedBy'];
    active = json['active'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created'] = this.created;
    data['createdBy'] = this.createdBy;
    data['updated'] = this.updated;
    data['updatedBy'] = this.updatedBy;
    data['active'] = this.active;
    data['name'] = this.name;
    return data;
  }
}