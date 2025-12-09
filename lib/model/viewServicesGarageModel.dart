class viewServicesGarageModel {
  String? message;
  List<ViewGarageServices>? data;
  bool? success;

  viewServicesGarageModel({this.message, this.data, this.success});

  viewServicesGarageModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <ViewGarageServices>[];
      json['data'].forEach((v) {
        data!.add(new ViewGarageServices.fromJson(v));
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

class ViewGarageServices {
  int? id;
  String? created;
  String? createdBy;
  String? updated;
  String? updatedBy;
  bool? active;
  String? name;
  Services? services;
  Null? serviceId;
  String? description;
  String? shortDiscribtion;
  String? photosUrl;
  String? costing;

  ViewGarageServices(
      {this.id,
        this.created,
        this.createdBy,
        this.updated,
        this.updatedBy,
        this.active,
        this.name,
        this.services,
        this.serviceId,
        this.description,
        this.shortDiscribtion,
        this.photosUrl,
        this.costing});

  ViewGarageServices.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    created = json['created'];
    createdBy = json['createdBy'];
    updated = json['updated'];
    updatedBy = json['updatedBy'];
    active = json['active'];
    name = json['name'];
    services = json['services'] != null
        ? new Services.fromJson(json['services'])
        : null;
    serviceId = json['serviceId'];
    description = json['description'];
    shortDiscribtion = json['short_discribtion'];
    photosUrl = json['photos_url'];
    costing = json['costing'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created'] = this.created;
    data['createdBy'] = this.createdBy;
    data['updated'] = this.updated;
    data['updatedBy'] = this.updatedBy;
    data['active'] = this.active;
    data['name'] = this.name;
    if (this.services != null) {
      data['services'] = this.services!.toJson();
    }
    data['serviceId'] = this.serviceId;
    data['description'] = this.description;
    data['short_discribtion'] = this.shortDiscribtion;
    data['photos_url'] = this.photosUrl;
    data['costing'] = this.costing;
    return data;
  }
}

class Services {
  int? id;
  String? created;
  String? createdBy;
  String? updated;
  String? updatedBy;
  bool? active;
  String? name;
  String? description;
  String? shortDiscribtion;
  String? photosUrl;
  String? timeRequiredToComplete;
  String? serviceWarranty;
  String? defaultCosting;

  Services(
      {this.id,
        this.created,
        this.createdBy,
        this.updated,
        this.updatedBy,
        this.active,
        this.name,
        this.description,
        this.shortDiscribtion,
        this.photosUrl,
        this.timeRequiredToComplete,
        this.serviceWarranty,
        this.defaultCosting});

  Services.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    created = json['created'];
    createdBy = json['createdBy'];
    updated = json['updated'];
    updatedBy = json['updatedBy'];
    active = json['active'];
    name = json['name'];
    description = json['description'];
    shortDiscribtion = json['short_discribtion'];
    photosUrl = json['photos_url'];
    timeRequiredToComplete = json['timeRequiredToComplete'];
    serviceWarranty = json['serviceWarranty'];
    defaultCosting = json['defaultCosting'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created'] = this.created;
    data['createdBy'] = this.createdBy;
    data['updated'] = this.updated;
    data['updatedBy'] = this.updatedBy;
    data['active'] = this.active;
    data['name'] = this.name;
    data['description'] = this.description;
    data['short_discribtion'] = this.shortDiscribtion;
    data['photos_url'] = this.photosUrl;
    data['timeRequiredToComplete'] = this.timeRequiredToComplete;
    data['serviceWarranty'] = this.serviceWarranty;
    data['defaultCosting'] = this.defaultCosting;
    return data;
  }
}
