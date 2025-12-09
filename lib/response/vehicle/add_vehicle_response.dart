import 'package:carcheks/model/fuel_type_model.dart';
import 'package:carcheks/model/vehicle_manufacturer_model.dart';
import 'package:carcheks/model/vehicle_type_model.dart';
import 'package:carcheks/model/vehicle_model.dart';

class AddVehicleResponse {
  AddVehicleResponse({
    required this.message,
    required this.data,
    required this.success,
  });
  late final String message;
  late final Vehicle data;
  late final bool success;

  AddVehicleResponse.fromJson(Map<String, dynamic> json){
    message = json['message'];
    data = Vehicle.fromJson(json['data']);
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


