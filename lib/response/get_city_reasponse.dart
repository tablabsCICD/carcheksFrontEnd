import 'package:carcheks/model/city_model.dart';

class GetCityReasponse {
  GetCityReasponse({
    required this.message,
    required this.data,
    required this.success,
  });
  late final String message;
  late final City data;
  late final bool success;

  GetCityReasponse.fromJson(Map<String, dynamic> json){
    message = json['message'];
    data = City.fromJson(json['data']);
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['message'] = message;
    _data['data'] = data.toJson();
    _data['success'] = success;
    return _data;
  }
}
