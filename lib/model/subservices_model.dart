

class SubServiceModel {
  SubServiceModel({
    required this.message,
    required this.data,
    required this.success,
  });
  late final String message;
  late final List<SubService> data;
  late final bool success;

  SubServiceModel.fromJson(Map<String, dynamic> json){
    message = json['message'];
    data = List.from(json['data']).map((e)=>SubService.fromJson(e)).toList();
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

class SubService {
  SubService({
    required this.id,
    required this.created,
    required this.createdBy,
    required this.updated,
    required this.updatedBy,
    required this.active,
    required this.name,
    required this.serviceId,
    required this.description,
    required this.shortDiscribtion,
    required this.photosUrl,
    required this.costing,
  });
  late final int id;
  late final String created;
  late final String createdBy;
  late final String updated;
  late final String updatedBy;
  late final bool active;
  late final String name;
  late final int serviceId;
  late final String description;
  late final String shortDiscribtion;
  late final String photosUrl;
  late final String costing;

  SubService.fromJson(Map<String, dynamic> json){
    id = json['id']??0;
    created = json['created']??'';
    createdBy = json['createdBy']??'';
    updated = json['updated']??'';
    updatedBy = json['updatedBy']??"";
    active = json['active']??true;
    name = json['name']??'';
    serviceId = json['serviceId']??0;
    description = json['description']??'';
    shortDiscribtion = json['short_discribtion']??'';
    photosUrl = json['photos_url']??'';
    costing = json['costing']??'';
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
    _data['services'] = serviceId;
    _data['description'] = description;
    _data['short_discribtion'] = shortDiscribtion;
    _data['photos_url'] = photosUrl;
    _data['costing'] = costing;
    return _data;
  }
}

