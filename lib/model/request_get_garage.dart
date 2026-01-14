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

class RequestGetGarageLatLong {
  final List<int> subserviceId;
  final double userLat;
  final double userLng;
  final int vehicleTypeId;

  RequestGetGarageLatLong({
    required this.subserviceId,
    required this.userLat,
    required this.userLng,
    required this.vehicleTypeId,
  });

  Map<String, dynamic> toJson() {
    return {
      'subservice_id': subserviceId,
      'vehicleTypeId': vehicleTypeId,
      'userLat': userLat,
      'userLng': userLng,
    };
  }

  RequestGetGarageLatLong copyWith({
    List<int>? subserviceId,
    double? userLat,
    double? userLng,
    int? vehicleTypeId,
  }) {
    return RequestGetGarageLatLong(
      subserviceId: subserviceId ?? this.subserviceId,
      userLat: userLat ?? this.userLat,
      userLng: userLng ?? this.userLng,
      vehicleTypeId: vehicleTypeId ?? this.vehicleTypeId,
    );
  }
}
