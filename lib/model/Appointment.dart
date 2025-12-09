import 'package:carcheks/model/garage_model.dart';
import 'package:carcheks/model/user_table_model.dart';

class AppointmentModel {
  String? message;
  List<Appointment>? data;
  bool? success;

  AppointmentModel({this.message, this.data, this.success});

  AppointmentModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <Appointment>[];
      json['data'].forEach((v) {
        data!.add(Appointment.fromJson(v));
      });
    }
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['success'] = this.success;
    return data;
  }
}

class Appointment {
  int? id;
  String? date;
  String? time;
  String? status;
  String? availableTime;
  bool? active;
  bool? accept;
  User? userTable;
  Garage? garrage;
  int? subServiceId;
  int? vehicleId;

  Appointment(
      {this.id,
        this.date,
        this.time,
        this.status,
        this.availableTime,
        this.active,
        this.accept,
        this.userTable,
        this.garrage,
        this.subServiceId,
        this.vehicleId});

  Appointment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    time = json['time'];
    status = json['status'];
    availableTime = json['availableTime'];
    active = json['active'];
    accept = json['accept'];
    userTable = json['userTable'] != null
        ? new User.fromJson(json['userTable'])
        : null;
    garrage =
    json['garrage'] != null ? new Garage.fromJson(json['garrage']) : null;
    subServiceId = json['subServiceId'];
    vehicleId = json['vehicleId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date'] = this.date;
    data['time'] = this.time;
    data['status'] = this.status;
    data['availableTime'] = this.availableTime;
    data['active'] = this.active;
    data['accept'] = this.accept;
    if (this.userTable != null) {
      data['userTable'] = this.userTable!.toJson();
    }
    if (this.garrage != null) {
      data['garrage'] = this.garrage!.toJson();
    }
    data['subServiceId'] = this.subServiceId;
    data['vehicleId'] = this.vehicleId;
    return data;
  }
}




