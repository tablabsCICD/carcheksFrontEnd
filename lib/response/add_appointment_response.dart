import 'package:carcheks/model/Appointment.dart';

class AddAppointmentResponse {
  AddAppointmentResponse({
    required this.message,
    required this.data,
    required this.success,
  });
  late final String message;
  late final Appointment data;
  late final bool success;

  AddAppointmentResponse.fromJson(Map<String, dynamic> json){
    message = json['message'];
    data = Appointment.fromJson(json['data']);
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

