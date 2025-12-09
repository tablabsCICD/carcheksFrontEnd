import 'package:carcheks/model/services.dart';
import 'package:carcheks/model/vehicle_model.dart';

import 'garage_model.dart';



class Dashboard {
  String? message;
  Data? data;
  bool? success;

  Dashboard({this.message, this.data, this.success});

  Dashboard.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['success'] = this.success;
    return data;
  }
}

class Data {
  Services? services;
  List<Vehicle>? vehicles;
  List<Garage>? garages;

  Data({this.services, this.vehicles, this.garages});

  Data.fromJson(Map<String, dynamic> json) {
    services = json['services'] != null
        ? new Services.fromJson(json['services'])
        : null;
    if (json['vehicles'] != null) {
      vehicles = <Vehicle>[];
      json['vehicles'].forEach((v) {
        vehicles!.add(new Vehicle.fromJson(v));
      });
    }
    if (json['garages'] != null) {
      garages = <Garage>[];
      json['garages'].forEach((v) {
        garages!.add(new Garage.fromJson(v));
      });
    }
  }

    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = new Map<String, dynamic>();
      if (this.services != null) {
        data['services'] = this.services!.toJson();
      }
      if (this.vehicles != null) {
        data['vehicles'] = this.vehicles!.map((v) => v.toJson()).toList();
      }
      if (this.garages != null) {
        data['garages'] = this.garages!.map((v) => v.toJson()).toList();
      }
      return data;
    }



}


class Services {
  List<MainService>? content;
  int? totalElements;
  int? totalPages;
  bool? last;
  int? size;
  int? number;
  Null? sort;
  int? numberOfElements;
  bool? first;

  Services(
      {this.content,
        this.totalElements,
        this.totalPages,
        this.last,
        this.size,
        this.number,
        this.sort,
        this.numberOfElements,
        this.first});

  Services.fromJson(Map<String, dynamic> json) {
    if (json['content'] != null) {
      content = <MainService>[];
      json['content'].forEach((v) {
        content!.add(new MainService.fromJson(v));
      });
    }
    totalElements = json['totalElements'];
    totalPages = json['totalPages'];
    last = json['last'];
    size = json['size'];
    number = json['number'];
    sort = json['sort'];
    numberOfElements = json['numberOfElements'];
    first = json['first'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.content != null) {
      data['content'] = this.content!.map((v) => v.toJson()).toList();
    }
    data['totalElements'] = this.totalElements;
    data['totalPages'] = this.totalPages;
    data['last'] = this.last;
    data['size'] = this.size;
    data['number'] = this.number;
    data['sort'] = this.sort;
    data['numberOfElements'] = this.numberOfElements;
    data['first'] = this.first;
    return data;
  }
}