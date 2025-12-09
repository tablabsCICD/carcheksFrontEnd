class ServicesGarage {
  String? message;
  List<SubServicesGarageData>? data;
  bool? success;

  ServicesGarage({this.message, this.data, this.success});

  ServicesGarage.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <SubServicesGarageData>[];
      json['data'].forEach((v) {
        data!.add(new SubServicesGarageData.fromJson(v));
      });
    }
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['success'] = this.success;
    return data;
  }
}

class SubServicesGarageData {
  String? subServiceName;
  int? subServiceId;
  String? description;
  bool? active;
  String? shortDiscribtion;
  String? defaultCost;
  int? garrageCost;
  int? garrageId;
  int? serviceId;
  String? serviceWarranty;
  int? garrageSubServiceId;
  String? photoService;
  String? photoSubservice;
  String? photoGarageService;

  SubServicesGarageData(
      {this.subServiceName,
        this.subServiceId,
        this.description,
        this.active,
        this.shortDiscribtion,
        this.defaultCost,
        this.garrageCost,
        this.garrageId,
        this.serviceId,
        this.serviceWarranty,
        this.garrageSubServiceId,
        this.photoService,
        this.photoSubservice,
        this.photoGarageService});

  SubServicesGarageData.fromJson(Map<String, dynamic> json) {
    subServiceName = json['subServiceName'];
    subServiceId = json['subServiceId'];
    description = json['description'];
    active = json['active'];
    shortDiscribtion = json['short_discribtion'];
    defaultCost = json['defaultCost'];
    garrageCost = json['garrageCost'];
    garrageId = json['garrageId'];
    serviceId = json['serviceId'];
    serviceWarranty = json['serviceWarranty'];
    garrageSubServiceId = json['garrageSubServiceId'];
    photoService = json['photoService'];
    photoSubservice = json['photoSubservice'];
    photoGarageService = json['photoGarageService'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subServiceName'] = this.subServiceName;
    data['subServiceId'] = this.subServiceId;
    data['description'] = this.description;
    data['active'] = this.active;
    data['short_discribtion'] = this.shortDiscribtion;
    data['defaultCost'] = this.defaultCost;
    data['garrageCost'] = this.garrageCost;
    data['garrageId'] = this.garrageId;
    data['serviceId'] = this.serviceId;
    data['serviceWarranty'] = this.serviceWarranty;
    data['garrageSubServiceId'] = this.garrageSubServiceId;
    data['photoService'] = this.photoService;
    data['photoSubservice'] = this.photoSubservice;
    data['photoGarageService'] = this.photoGarageService;
    return data;
  }
}