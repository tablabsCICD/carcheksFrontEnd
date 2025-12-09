import 'package:carcheks/model/address_model.dart';

class SaveAddressResponse {
  SaveAddressResponse({
    required this.message,
    required this.data,
    required this.success,
  });
  late final String message;
  late final AddressClass data;
  late final bool success;

  SaveAddressResponse.fromJson(Map<String, dynamic> json){
    message = json['message'];
    data = AddressClass.fromJson(json['data']);
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

