class EmergencyServicesModel {
  EmergencyServicesModel({
    required this.message,
    required this.data,
    required this.success,
  });
  late final String message;
  late final List<EmergencyServices> data;
  late final bool success;

  EmergencyServicesModel.fromJson(Map<String, dynamic> json){
    message = json['message'];
    data = List.from(json['data']).map((e)=>EmergencyServices.fromJson(e)).toList();
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

class EmergencyServices {
  EmergencyServices({
    required this.id,
    required this.created,
    required this.createdBy,
    required this.updated,
    required this.updatedBy,
    required this.active,
    required this.name,
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
  late final String name;
  late final String description;
  late final String shortDescription;
  late final String photosUrl;

  EmergencyServices.fromJson(Map<String, dynamic> json){
    id = json['id']??0;
    created = json['created']??'';
    createdBy = json['createdBy']??'';
    updated = json['updated']??'';
    updatedBy = json['updatedBy']??"";
    active = json['active']??true;
    name = json['name']??'';
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
    _data['name'] = name;
    _data['description'] = description;
    _data['shortDescription'] = shortDescription;
    _data['photosUrl'] = photosUrl;
    return _data;
  }
}