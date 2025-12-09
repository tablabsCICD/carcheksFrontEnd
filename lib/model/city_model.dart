class CityModel {
  CityModel({
    required this.message,
    required this.data,
    required this.success,
  });
  late final String message;
  late final List<City> data;
  late final bool success;

  CityModel.fromJson(Map<String, dynamic> json){
    message = json['message'];
    data = List.from(json['data']).map((e)=>City.fromJson(e)).toList();
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

class City {
  City({
    required this.id,
    required this.created,
    required this.createdBy,
    required this.active,
    required this.city,
    required this.state,
    required this.country,
  });
  late final int id;
  late final String created;
  late final String createdBy;
  late final bool active;
  late final String city;
  late final String state;
  late final String country;

  City.fromJson(Map<String, dynamic> json){
    id = json['id']??0;
    created = json['created']??'';
    createdBy = json['createdBy']??'';
    active = json['active']??true;
    city = json['city']??'';
    state = json['state']??'';
    country = json['country']??"";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['created'] = created;
    _data['createdBy'] = createdBy;
    _data['active'] = active;
    _data['city'] = city;
    _data['state'] = state;
    _data['country'] = country;
    return _data;
  }
}