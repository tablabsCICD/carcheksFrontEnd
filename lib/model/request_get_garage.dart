class RequestGetGarage {
  List<int>? subserviceId;
  int? vehicleTypeId;

  RequestGetGarage({this.subserviceId, this.vehicleTypeId});

  RequestGetGarage.fromJson(Map<String, dynamic> json) {
    subserviceId = json['subservice_id'].cast<int>();
    vehicleTypeId = json['vehicleTypeId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subservice_id'] = this.subserviceId;
    data['vehicleTypeId'] = this.vehicleTypeId;
    return data;
  }
}